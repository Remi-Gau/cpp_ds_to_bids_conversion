% main script to convert data

clear

TaskName = 'rest';
RepetitionTime = 2.2;
EchoTime = 0.03;
FlipAngle = 90;

% missing info:
%   - tesla
%   - slice timning
%

json_opt = struct('indent', '  ');

spm('defaults', 'FMRI');

target_folder = fullfile(fileparts(mfilename('fullpath')), ...
    '..', ...
    '..');

source_folder = fullfile(target_folder, 'source');

groups = spm_select('List', source_folder, 'dir');
group_paths = spm_select('FPList', source_folder, 'dir');

% missing covariates:
%   - sex
%   - age
%   - language
%   - SES
%   - education
participants_tsv = struc( ...
    'participant_id', [], ...
    'group', []);

participant_id = {};
group_id = {};

for iGroup = 1:size(groups, 1)
    
    this_group = lower(deblank(groups(iGroup, :)));
    
    fprintf('\n\n');
    disp(this_group);
    fprintf('\n');
    
    subjects = spm_select('List', deblank(group_paths(iGroup, :)), 'dir');
    subjejct_paths = spm_select('FPList', deblank(group_paths(iGroup, :)), 'dir');
    
    for iSub = 1:size(subjects, 1)
        
        subLabel = lower([this_group, sprintf('%02.0f', iSub)]);
        participant_id{end + 1} = subLabel; %#ok<*SAGROW>
        group_id{end + 1} = this_group;
        
        fprintf(' %s --> %s\n', subjects(iSub, :), subLabel);
        
        subject_dir = fullfile(target_folder, ['sub-' subLabel]);
        [~, ~, ~] = mkdir(subject_dir);
        spm_mkdir(subject_dir, {'anat', 'func'});
        
        %% anat
        anat_file = spm_select('FPList', ...
            deblank(subjejct_paths(iSub, :)), ...
            ['^s.*' deblank(subjects(iSub, 1)) '.*.nii$']);
        assert(~isempty(anat_file))
        
        convert_anat(anat_file, subject_dir, subLabel)
        
        %% functional
        func_files = spm_select('FPList', ...
            deblank(subjejct_paths(iSub, :)), ...
            ['^f.*' deblank(subjects(iSub, 1)) '.*.img$']);
        
        func_filename = fullfile(subject_dir, 'func', ...
            ['sub-' subLabel '_task-' TaskName '_bold.nii']);
        
        matlabbatch{1}.spm.util.cat.vols = cellstr(func_files);
        matlabbatch{1}.spm.util.cat.name = func_filename;
        matlabbatch{1}.spm.util.cat.dtype = 0;
        matlabbatch{1}.spm.util.cat.RT = RepetitionTime;
        spm_jobman('run', matlabbatch);
        
        % TODO: extract scan date from header
        %         hdr = spm_vol(func_files);
        %         vol = spm_read_vols(hdr);
        %         strfind(this_run.descrip, 'deg ')
        
        % zip and delete original
        gzip(func_filename)
        delete(func_filename)
        
    end
    
end

%% participants.tsv
participants_tsv.participant_id = participant_id;
participants_tsv.group_id = group_id;

spm_save(fullfile(target_folder, 'participants.tsv'), ...
    participants_tsv);

%% dataset description
data_description = struct('Name', 'blind and control - canadian dataset', 'BIDSVersion', '1.5');
data_description.DatasetType = 'raw';
data_description.License = 'CC0';
data_description.Authors = {'', '', ''};
data_description.Acknowledgements = '';
data_description.HowToAcknowledge = '';
data_description.Funding = {'', '', ''};
% data_description.EthicsApprovals = '';
data_description.ReferencesAndLinks = {'', '', ''};
data_description.DatasetDOI = '';

spm_jsonwrite(fullfile(target_folder, 'dataset_description.json'), ...
    data_description, json_opt);

%% func json
task_bold = struct(...
    'TaskName', TaskName, ...
    'RepetitionTime', RepetitionTime, ...
    'EchoTime', EchoTime, ...
    'FlipAngle', FlipAngle);

spm_jsonwrite(fullfile(target_folder, ['task-' TaskName '_bold.json']), ...
    task_bold, json_opt);
