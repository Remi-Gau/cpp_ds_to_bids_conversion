
function save_func_json(target_folder, json_opt, bold_json)

    spm_jsonwrite(fullfile(target_folder, ...
        ['task-' bold_json.TaskName '_bold.json']), ...
        bold_json, json_opt);
end