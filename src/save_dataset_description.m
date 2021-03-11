
function save_dataset_description(target_folder, json_opt)
    
    data_description = struct(...
        'Name', 'blind and control - canadian dataset', ...
        'BIDSVersion', '1.5');
    data_description.DatasetType = 'raw';
    data_description.License = 'CC0';
    data_description.Authors = {'', '', ''};
    data_description.Acknowledgements = '';
    data_description.HowToAcknowledge = '';
    data_description.Funding = {'', '', ''};
    % data_description.EthicsApprovals = '';
    data_description.ReferencesAndLinks = {'', '', ''};
    data_description.DatasetDOI = '';
    
    spm_jsonwrite(...
        fullfile(target_folder, 'dataset_description.json'), ...
        data_description, ...
        json_opt);
    
end