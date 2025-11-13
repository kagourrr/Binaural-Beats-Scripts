% load("4025Data.mat");
% for chan = 1:32
% test = squeeze(SubjectData.EntrainRatioData(chan,:,:));
% figure();
% pcolor(1:50, SubjectData.f, test);
% title(["channel " int2str(chan)]);
% shading flat;
% colorbar;
% end

dataFiles = { ...
'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat', ...
'4015Data.mat','4017Data.mat','4018Data.mat','4020Data.mat','4022Data.mat', ...
'4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat', ...
'4033Data.mat','4034Data.mat','4036Data.mat','4037Data.mat','4038Data.mat', ...
'4039Data.mat','4040Data.mat','4041Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};

stimFreqs = [20 30 40];  % stimulation frequencies
nSubjects = numel(dataFiles);

% f-axis
load(dataFiles{1}, 'SubjectData');
faxis = SubjectData.f;
nFreqs = length(faxis);
nChans = 32;

% measured freq x channels x subjects x stimFreq
allDiags = zeros(nFreqs, nChans, nSubjects, numel(stimFreqs));

for s = 1:nSubjects
    load(dataFiles{s}, 'SubjectData');
    data = SubjectData.EntrainRatioData;  % 32 x 903 x 50

    for fStimIdx = 1:numel(stimFreqs)
        stim = stimFreqs(fStimIdx);

        % closest measured frequency to stim
        [~, freqIdx] = min(abs(faxis - stim));

        % diagonal across channels at this frequency
        diagVals = squeeze(data(:, freqIdx, stim)); % 32 x 1

        % store for all subjects
        allDiags(freqIdx, :, s, fStimIdx) = diagVals;  % only freqIdx row populated
    end
end

% average across subjects
meanDiags = mean(allDiags, 3, 'omitnan'); % measured freq x channels x stimFreq

% pcolor per stim freq
for fStimIdx = 1:numel(stimFreqs)
    figure('Name', [num2str(stimFreqs(fStimIdx)) ' Hz Diagonal'], 'NumberTitle', 'off');

    diagRow = meanDiags(:, :, fStimIdx); % measured freq x channels

    % pcolor requires a full matrix, so we can plot freq x channels
    pcolor(1:nChans, faxis, diagRow);
    shading flat;
    colorbar;
    colormap jet;
    clim([0 max(diagRow, [], 'all')]); % set limits to max of measured freq x channels diag
    xlabel('Channels');
    ylabel('Measured Frequency (Hz)');
    title([num2str(stimFreqs(fStimIdx)) ' Hz Stimulation - Diagonal']);
end
