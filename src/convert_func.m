function convert_func(opt, func_files, func_filename, RepetitionTime)
    
    if opt.func.convert
        matlabbatch{1}.spm.util.cat.vols = cellstr(func_files);
        matlabbatch{1}.spm.util.cat.name = func_filename;
        matlabbatch{1}.spm.util.cat.dtype = 0;
        matlabbatch{1}.spm.util.cat.RT = RepetitionTime;
        spm_jobman('run', matlabbatch);
        
        % zip and delete original
        gzip(func_filename)
        delete(func_filename)
        
    end
end