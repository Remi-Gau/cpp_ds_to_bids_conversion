function save_participants(participants_tsv, source_folder, target_folder, json_opt)
    
    fields_order = {
    'participant_id'
    'OldID'
    'group'
    'match'
    'gender'
    'age'
    'handedness'
    'onset_blindness'
    'years_of_blindness'
    'total_blindness'
    'years_of_total_blindness'};
    
    participants_tsv = orderfields(participants_tsv, fields_order);
    
    bids.util.tsvwrite(fullfile(source_folder, 'participants_new.tsv'), ...
        participants_tsv);
    
    participants_tsv = rmfield(participants_tsv, 'OldID');
    
    bids.util.tsvwrite(fullfile(target_folder, 'participants.tsv'), ...
        participants_tsv);
    
    create_data_dictionnary(fullfile(target_folder, 'participants.tsv'), json_opt)
end