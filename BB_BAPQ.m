%% we gotta put the BAPQ scores to SubjectData structure in each .mat file
% load the our BAPQ scores .csv
scores = readtable('BB BAPQ SCORES - CURRENT SUBJ LIST.csv');

% file list
dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};

% loop through each file
for i = 1:length(dataFiles)
    load(dataFiles{i}, 'SubjectData');
    
    % convert the subject ID to numeric (i was getting a text error lol)
    subjID = str2double(SubjectData.Subject);
    
    % matching row in the .csv by PID
    matchRow = scores(scores.PID == subjID, :);
    
    % add each bapq field to SubjectData
    SubjectData.BAPQ_Total     = matchRow.BAPQ_Total;
    SubjectData.BAPQ_Aloof     = matchRow.BAPQ_Aloof;
    SubjectData.BAPQ_Pragmatic = matchRow.BAPQ_Pragmatic;
    SubjectData.BAPQ_Rigid     = matchRow.BAPQ_Rigid;
    
    % save the updated structure back to file
    save(dataFiles{i}, 'SubjectData', '-v7.3');
    
    fprintf('Added BAPQ scores to %s (PID %d)\n', dataFiles{i}, subjID);
end
