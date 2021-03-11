function save_scans_tsv(sub_label, func_files, func_filename)
    
    hdr = spm_vol(func_files(1,:));
    fprintf('\n %s\n', func_files(1,:));
    fprintf(' %s\n', hdr.descrip);
    
    hdr.descrip = convert_month(hdr.descrip);
    hdr.descrip = strrep(hdr.descrip, '-',  ' ');
    hdr.descrip = strrep(hdr.descrip, '.',  ' ');
    hdr.descrip = strrep(hdr.descrip, ':',  ' ');
    pattern = '3T 2D EP TR=2200ms/TE=30ms/FA=90deg %f %f %f %f %f %f %f Mosaic';
    C = textscan(hdr.descrip, pattern);
    
    real_acq_time = sprintf('%4.0f-%02.0f-%02.0fT%02.0f:%02.0f:%02.0f', ...
        C{3}, C{2}, C{1}, C{4}, C{5}, C{6});
    disp(real_acq_time)
    
    year_offset = 150;
    acq_time = sprintf('%4.0f-%02.0f-%02.0fT%02.0f:%02.0f:%02.0f', ...
        C{3}-year_offset, C{2}, C{1}, C{4}, C{5}, C{6});
    disp(acq_time)

    [source_folder, source_filename, ext] = fileparts(hdr.fname);
    scans_tsv.source_filename = [source_filename, ext];
    
    [target_folder, target_filename, ext] = fileparts(func_filename);
    scans_tsv.filename = ['func/' target_filename, ext, '.gz'];
    
     scans_tsv.real_acq_time = real_acq_time;
    scans_tsv.acq_time = acq_time;

    bids.util.tsvwrite(fullfile(source_folder, 'scans.tsv'), ...
                       scans_tsv);
                   
    scans_tsv = rmfield(scans_tsv, 'source_filename');
    scans_tsv = rmfield(scans_tsv, 'real_acq_time');
    
    bids.util.tsvwrite(fullfile(target_folder, '..', ['sub-' sub_label '_scans.tsv']), ...
                       scans_tsv);
                   
                   

            %             filename    acq_time
            %             func/sub-control01_task-nback_bold.nii.gz   1877-06-15T13:45:30
    
end