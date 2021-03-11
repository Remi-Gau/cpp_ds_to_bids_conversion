function string = convert_month(string)
    
    string = strrep(string, 'Jan', '01');
    string = strrep(string, 'Feb', '02');
    string = strrep(string, 'Mar', '03');
    string = strrep(string, 'Apr', '04');
    string = strrep(string, 'May', '05');
    string = strrep(string, 'Jun', '06');
    string = strrep(string, 'Jul', '07');
    string = strrep(string, 'Aug', '08');
    string = strrep(string, 'Sep', '09');
    string = strrep(string, 'Oct', '10');
    string = strrep(string, 'Nov', '11');
    string = strrep(string, 'Dec', '12');
    
end