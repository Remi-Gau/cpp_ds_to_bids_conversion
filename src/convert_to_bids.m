function convert_to_bids()
    %
    % main function to convert data
    %
    
    opt.anat.convert = false;
    opt.func.convert = false;
    
    % missing info:
    %   - slice timning
    %
    TaskName = 'rest';
    RepetitionTime = 2.2;
    
    %%
    base_json.Manufacturer = 'siemens';
    base_json.ManufacturersModelName = 'trio';
    base_json.MagneticFieldStrength = 3;
    
    % func
    bold_json = base_json;
    bold_json.TaskName = TaskName;
    bold_json.RepetitionTime = RepetitionTime;
    bold_json.EchoTime = 0.03;
    bold_json.FlipAngle = 90;
    bold_json.PulseSequenceType = 'gradient-echo EPI';
    bold_json.NumberOfVolumesDiscardedByUser = 4;
    
    % anat
    anat_json = base_json;
    anat_json.RepetitionTime = 2.3;
    anat_json.EchoTime = 0.0291;
    anat_json.InversionTime = 0.9;
    
    %%
    json_opt = struct('indent', '  ');
    
    target_folder = fullfile(...
        fileparts(mfilename('fullpath')), ...
        '..', ...
        '..');
    
    source_folder = fullfile(target_folder, 'source');
    
    groups = spm_select('List', source_folder, 'dir');
    group_paths = spm_select('FPList', source_folder, 'dir');

    participants_tsv = spm_load(fullfile(source_folder, 'participants.tsv'));
    participants_tsv.participant_id = cell(size(participants_tsv.OldID));

    %%
    spm('defaults', 'FMRI');
    
    for iGroup = 1:size(groups, 1)
        
        this_group = lower(deblank(groups(iGroup, :)));
        
        fprintf('\n\n');
        disp(this_group);
        fprintf('\n');
        
        subjects = spm_select('List', deblank(group_paths(iGroup, :)), 'dir');
        subjejct_paths = spm_select('FPList', deblank(group_paths(iGroup, :)), 'dir');
        
        for iSub = 1:size(subjects, 1)
            
            sub_label = lower([this_group, sprintf('%02.0f', iSub)]);
            
            sub_idx = find(all([strcmp(participants_tsv.OldID, deblank(subjects(iSub, :))),  ...
                       strcmpi(participants_tsv.group, this_group)], 2));
            participants_tsv.participant_id{sub_idx} = sub_label; %#ok<*FNDSB>
            
            fprintf('\n\n %s --> %s\n', subjects(iSub, :), sub_label);
            
            subject_dir = fullfile(target_folder, ['sub-' sub_label]);
            [~, ~, ~] = mkdir(subject_dir);
            spm_mkdir(subject_dir, {'anat', 'func'});
            
            %% anat
            anat_file = spm_select('FPList', ...
                deblank(subjejct_paths(iSub, :)), ...
                ['^s.*' deblank(subjects(iSub, 1)) '.*.nii$']);
            assert(~isempty(anat_file))
            
            convert_anat(opt, anat_file, subject_dir, sub_label);
            
            %% functional
            func_files = spm_select('FPList', ...
                deblank(subjejct_paths(iSub, :)), ...
                ['^f.*' deblank(subjects(iSub, 1)) '.*.img$']);
            
            func_filename = fullfile(subject_dir, 'func', ...
                ['sub-' sub_label '_task-' TaskName '_bold.nii']);
            
            convert_func(opt, func_files, func_filename, RepetitionTime);
            
            save_scans_tsv(sub_label, func_files, func_filename);


        end
        
    end
    
    save_participants(participants_tsv, source_folder, target_folder, json_opt)
    save_dataset_description(target_folder, json_opt)
    save_func_json(target_folder, json_opt, bold_json)
    save_anat_json(target_folder, json_opt, anat_json)
    
end



