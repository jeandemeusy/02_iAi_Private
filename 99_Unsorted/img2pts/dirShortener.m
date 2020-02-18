function [simpleStr] = dirShortener(str)

alphabet = ['A';'B';'C';'D';'E';'F';'G';'H'];

strLen = length(str);
%% Transformation de 1234 -> ABCD
for i = 1:strLen
    str(i) = alphabet(str2double(str(i)));
end

%% Concatenation des suites de directions identiques
shortStr = ['1' str(1)];
for i = 2:strLen
    if(str(i) == shortStr(end) && str2double(shortStr(end-1)) < 9)        
        shortStr(end-1) = num2str(str2double(shortStr(end-1))+1);
    else
        shortStr(end+1) = '1';
        shortStr(end+1) = str(i);
    end
end

%% Suppression des '1'
shortStrLen = length(shortStr);
simpleStr = '';
for i = 1:shortStrLen
    if shortStr(i) ~= '1'
        simpleStr(end+1) = shortStr(i);
    end 
end

