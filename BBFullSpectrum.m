dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};
% removed 4019, 4035, and 4042 bc outlier (3.01 SD, 3.45 SD from mean)
% dataFiles([24, 28])=[];

% Parameters
chans = [2 3 29];      % Fz, F3, F4
targetStimFreq = 40;  % stimulation frequency
stimFreqs = 1:50;     % freq range
nSubjects = numel(dataFiles);

% load first subject to get frequency vector
load(dataFiles{1}, "SubjectData");
freqVals = SubjectData.f;    % 0–50 Hz, 903 bins
nFreqs = numel(freqVals);
groupData = zeros(nSubjects, nFreqs);

% find stimulation frequency index closest to target
[~, stimIdx] = min(abs(stimFreqs - targetStimFreq));

%% Load data & extract mean across Fz, F3, F4
for fileNum = 1:nSubjects
    load(dataFiles{fileNum}, "SubjectData");
    data = squeeze(mean(SubjectData.EntrainRatioData(chans, :, stimIdx), 1)); % average channels
    groupData(fileNum, :) = data(:)'; % store subject spectrum
end

%% Z-score within subjects (across frequency)
groupDataZ = zscore(groupData, 0, 2);

%% 40 Hz diagnostic and sorting
targetDisplayFreq = 40;
[~, f40Idx] = min(abs(freqVals - targetDisplayFreq));
subject40Hz = groupData(:, f40Idx);

mu40 = mean(subject40Hz);
sd40 = std(subject40Hz);

fprintf('\n=== 40 Hz Diagnostic ===\n');
fprintf('Mean at 40 Hz: %.4f   SD: %.4f   N=%d\n', mu40, sd40, nSubjects);

% sort subjects by 40 Hz amplitude (ascending)
[~, sortOrder] = sort(subject40Hz, 'ascend');
sortedData = groupData(sortOrder, :);

%% pad data for full pcolor display
pcolor_pad = @(data) [data, data(:,end); data(end,:), data(end,end)];

%% plot layout
figure('Name','Frequency Spectrum Across Subjects','Position',[200 200 1200 800]);

subplot(2,2,1);
padded_sorted = pcolor_pad(sortedData');
x = 1:(nSubjects+1);
y = linspace(min(freqVals), max(freqVals), numel(freqVals)+1);

pcolor(x, y, padded_sorted);
shading flat;
colormap('parula');
caxis(prctile(groupData(:), [2 98]));
colorbar;
xlabel('Subjects');
ylabel('Frequency (Hz)');
title('Entrainment Ratio Spectrum (Fz/F3/F4 Mean)');

%line plot
subplot(2,2,2);
plot(freqVals, groupData', 'LineWidth', 0.8);
xline(40, '--k', '40 Hz', 'LabelVerticalAlignment','bottom');
xlabel('Frequency (Hz)');
ylabel('Entrainment Ratio');
title('Raw Spectra (All Subjects)');
xlim([0 50]); grid on; set(gca, 'FontSize', 12);

% move mean plot
subplot(2,2,3);
win = 18;
mvmn = movmean(sortedData', win, 1)';  % moving mean along frequency
padded_mvmn = pcolor_pad(mvmn');
pcolor(x, y, padded_mvmn);
shading flat;
colormap('parula');
caxis(prctile(groupData(:), [2 98]));
colorbar;
xlabel('Subjects');
ylabel('Frequency (Hz)');
title('Moving Mean (Window = 18)');
set(gca, 'YLim', [0 55], 'FontSize', 12);

% zscore plot
subplot(2,2,4);
plot(freqVals, groupDataZ');
xline(40, '--r', '40 Hz', 'LabelVerticalAlignment','bottom');
xlabel('Frequency (Hz)');
ylabel('Z-scored Entrainment Ratio');
title('Z-scored Spectra (Per Subject)');
xlim([0 50]); grid on; set(gca, 'FontSize', 12);

sgtitle('Frequency Spectrum Analysis Across Subjects', 'FontSize', 14);


% dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4019Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4035Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4042Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};
% % removed 28 and 24
% %dataFiles([24, 28])=[];
% % chans = 2;
% chans = [2 3 4];   % Fz, F3, F4
% freq = 40;         % stim freq
% freqs = 9:903;     % freq range
% nSubjects = numel(dataFiles);
% nFreqs = numel(freqs);
% groupData = zeros(nSubjects, nFreqs);
% 
% for fileNum = 1:nSubjects
%     load(dataFiles{fileNum});
%     data = squeeze(mean(SubjectData.EntrainRatioData(chans, freqs, freq), 1)); % mean across Fz, F3, F4
%     groupData(fileNum, :) = data(:)';  % store mean spectrum per sub
% end
% 
% % z-score across freqs w/i each sub
% groupDataZ = zscore(groupData, 0, 2);
% 
% %% plot pcolor across freq spectrum
% figure('Name','Frequency Spectrum Across Subjects','Position',[200 200 1200 800]);
% 
% subplot(2,2,1);
% sortedData = sortrows(groupData,657);
% [X, Y] = meshgrid(1:size(groupData,1), SubjectData.f(freqs));
% pcolor(X, Y, sortedData');
% shading flat;
% colormap turbo;
% colorbar;
% xlabel('Subjects');
% ylabel('Frequency (Hz)');
% title('Entrain Ratio Frequency Spectrum Across Subjects');
% 
% %% plot line plots of each sub
% subplot(2,2,2);
% plot(SubjectData.f(freqs), groupData');
% xlabel('Frequency (Hz)');
% ylabel('Entrainment Ratio');
% title('Raw Spectra (All Subjects, Fz/F3/F4 Mean)');
% grid on;
% 
% %% moving z-score (window = 18)
% win = 18;
% mvmn = movmean(groupData', win, 1)'; % moving mean along frequency
% mvstd = movstd(groupData', win, 1)'; % moving std along frequency
% mvz = (groupData - mvmn) ./ mvstd;
% 
% %% plot moving mean
% subplot(2,2,3);
% pcolor(1:size(groupData,1), SubjectData.f(freqs), mvmn');
% shading flat;
% colormap turbo;
% colorbar;
% xlabel('Subjects');
% ylabel('Frequency (Hz)');
% title('Moving Mean across Subjects');
% 
% %% plot z-scored group data
% subplot(2,2,4);
% plot(SubjectData.f(freqs), groupDataZ');
% xlabel('Frequency (Hz)');
% ylabel('Z-scored Entrainment Ratio');
% title('Z-scored Spectra (per subject)');
% grid on;

%% surfc plot
%figure('Name','Surfc Plot of Z-scored Data','Position',[200 200 1200 800]);
%stackedplot(1:size(groupData,1), SubjectData.f(freqs), groupDataZ');
%surfc(1:size(groupData,1), SubjectData.f(freqs), groupDataZ');


% %% show full spectrum
% dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4019Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4035Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4042Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};
% chan = 2; % Fz
% freq = 40;
% groupData = [];
% freqs = 9:903;
% for fileNum = 1:length(dataFiles)
%     load(dataFiles{fileNum});
%     data = squeeze(SubjectData.EntrainRatioData(chan,freqs,freq));
%     groupData = cat(1,groupData,data);
% end
% groupDataZ=zscore(groupData,0,2);
% figure;
% subplot(2,2,1)
% pcolor(1:length(dataFiles),SubjectData.f(freqs),groupData');
% shading flat
% colormap turbo
% colorbar
% subplot(2,2,2);
% plot(SubjectData.f(freqs),groupData');
% % surfc(1:length(dataFiles),SubjectData.f(freqs),groupDataZ');
% 
% %% Moving Z-score
% mvmn = movmean(groupData',18)';
% mvstd = movstd(groupData',18)';
% mvz = ((groupData-mvmn)./mvstd);
% subplot(2,2,3);
% pcolor(1:length(dataFiles),SubjectData.f(freqs),mvmn');
% shading flat
% colormap turbo
% colorbar
% 
% subplot(2,2,4);
% plot(SubjectData.f(freqs),groupDataZ);
% %% plot
% %plot(SubjectData.f,data);
% %xlabel('Frequency Spectrum');
