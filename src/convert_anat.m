function convert_anat(anat_file, subject_dir, subLabel)
    
    disp(anat_file);
    
    anat_filename = fullfile(subject_dir, 'anat', ...
        ['sub-' subLabel '_T1w.nii']);
    
    disp(anat_filename);
    
    % copy anat
    spm_copy(anat_file, anat_filename);
    
    % deface ane remove non defaced
    matlabbatch{1}.spm.util.deface.images = {anat_filename};
    spm_jobman('run', matlabbatch);
    delete(anat_filename)
    
    % rename defaced to BIDS compatible T1w
    movefile(spm_file(anat_filename, 'basename', ['anon_sub-' subLabel '_T1w']), anat_filename);
    
    % zip and delete original
    gzip(anat_filename)
    delete(anat_filename)
    
end