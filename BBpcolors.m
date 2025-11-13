%% ===============================
% Parameters
%% ===============================
dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat',...
    '4017Data.mat','4018Data.mat','4019Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat',...
    '4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4036Data.mat','4037Data.mat',...
    '4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};

chans = [2 3 4];   % Fz, F3, F4
targetStimFreq = 40;   % Hz
stimFreqs = 1:50;      % stimulation frequency conditions

%% ===============================
% Preallocate and determine indices
%% ===============================
nSubjects = numel(dataFiles);

% Load first subject to get frequency axis
load(dataFiles{1}, "SubjectData");
freqVals = SubjectData.f;   % 0–55 Hz, 903 bins
nFreqs = numel(freqVals);
groupData = zeros(nSubjects, nFreqs);

% Find stimulation frequency layer closest to target
[~, stimIdx] = min(abs(stimFreqs - targetStimFreq));

%% ===============================
% Load data & extract mean across channels
%% ===============================
for fileNum = 1:nSubjects
    load(dataFiles{fileNum}, "SubjectData");
    
    % mean across selected channels, keep full frequency spectrum
    data = squeeze(mean(SubjectData.EntrainRatioData(chans, :, stimIdx), 1));
    groupData(fileNum, :) = data(:)';
end

%% ===============================
% Z-score within subjects
%% ===============================
groupDataZ = zscore(groupData, 0, 2);

%% ===============================
% Diagnostic: Peak near 40 Hz
%% ===============================
% Find analysis frequency index closest to target (for marking 40 Hz)
[~, f40Idx] = min(abs(freqVals - targetStimFreq));
subject40Hz = groupData(:, f40Idx);

% Compute statistics
mu = mean(subject40Hz);
sigma = std(subject40Hz);
zScores = (subject40Hz - mu) / sigma;
outlierIdx = find(abs(zScores) > 3);

fprintf('\n=== 40 Hz Diagnostic Report ===\n');
fprintf('Group mean at 40 Hz: %.3f ± %.3f\n', mu, sigma);
fprintf('Number of subjects: %d\n', numel(subject40Hz));
fprintf('Outlier threshold: ±3 SD\n');

if isempty(outlierIdx)
    fprintf('✅ No outlier subjects detected.\n');
else
    fprintf('⚠️ %d outlier(s) detected:\n', numel(outlierIdx));
    for i = 1:numel(outlierIdx)
        fprintf('   • Subject %s (%.2f SD from mean)\n', dataFiles{outlierIdx(i)}, zScores(outlierIdx(i)));
    end
end

%% ===============================
% Plotting
%% ===============================
figure('Name','Frequency Spectrum Across Subjects','Position',[200 200 1200 800]);

% --- (1) Heatmap of raw spectra ---
subplot(2,2,1);
sortedData = sortrows(groupData, f40Idx);  % sort subjects by 40 Hz power
imagesc(1:nSubjects, freqVals, sortedData');
axis xy;
colormap(parula);
colorbar;
xlabel('Subjects');
ylabel('Frequency (Hz)');
title('Entrain Ratio Frequency Spectrum (Fz/F3/F4 Mean)');
hold on;
yline(freqVals(f40Idx), 'r--', 'LineWidth', 1.5);  % mark 40 Hz
set(gca, 'FontSize', 12);

% --- (2) Line plots: raw spectra per subject ---
subplot(2,2,2);
plot(freqVals, groupData');
xlabel('Frequency (Hz)');
ylabel('Entrainment Ratio');
title('Raw Spectra (All Subjects)');
grid on;
xlim([0 55]);
hold on;
yline(mu, 'k--', 'LineWidth', 1.5);       % mean across subjects
yline(mu + 3*sigma, 'r--', 'LineWidth', 1); % ±3 SD
yline(mu - 3*sigma, 'r--', 'LineWidth', 1);
set(gca, 'FontSize', 12);

% --- (3) Moving mean ---
win = 18;
mvmn = movmean(groupData', win, 1)'; % moving mean along frequency
subplot(2,2,3);
imagesc(1:nSubjects, freqVals, mvmn');
axis xy;
colormap(parula);
colorbar;
xlabel('Subjects');
ylabel('Frequency (Hz)');
title(['Moving Mean (Window = ', num2str(win), ')']);
hold on;
yline(freqVals(f40Idx), 'r--', 'LineWidth', 1.5); % mark 40 Hz
set(gca, 'FontSize', 12);

% --- (4) Z-scored spectra ---
subplot(2,2,4);
plot(freqVals, groupDataZ');
xlabel('Frequency (Hz)');
ylabel('Z-scored Entrainment Ratio');
title('Z-scored Spectra (per subject)');
grid on;
xlim([0 55]);
hold on;
yline(0, 'k--', 'LineWidth', 1.5); % baseline
set(gca, 'FontSize', 12);

sgtitle('Frequency Spectrum Analysis Across Subjects', 'FontSize', 14);
