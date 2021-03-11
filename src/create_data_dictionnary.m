function create_data_dictionnary(tsv_file, json_opt)

    tsv_content =  spm_load(tsv_file);
    column_names = fieldnames(tsv_content);
    
    json_content = struct([]);
    
    for iColumn = 1:numel(column_names)
        
        json_content(1).(column_names{iColumn}) = data_dict_template();
        
        if ~strcmp(column_names{iColumn}, {'participant_id'})
            
            levels = unique(tsv_content.(column_names{iColumn}));
            if iscell(levels)
            for iLevel = 1:numel(levels)
                json_content(1).(column_names{iColumn}).Levels.(levels{iLevel}) = '';
            end
            end
        end
    end
    
    [target_folder, json_file] = fileparts(tsv_file);
    json_file = fullfile(target_folder, [json_file , '.json']);
    
    spm_jsonwrite(json_file, json_content, json_opt);


%     logFile(1).columns = struct( ...
%                                 'onset', struct( ...
%                                                 'Description', ...
%                                                 'time elapsed since experiment start', ...
%                                                 'Units', 's'), ...
%                                 'trial_type', struct( ...
%                                                      'Description', 'types of trial', ...
%                                                      'Levels', struct()), ...
%                                 'duration', struct( ...
%                                                    'Description', ...
%                                                    'duration of the event or the block', ...
%                                                    'Units', 's') ...
%                                );


end

function template = data_dict_template()

    template.LongName = '';
    template.Description = '';
    template.Levels = struct();
    template.TermURL = '';
    template.Units = '';
    
end