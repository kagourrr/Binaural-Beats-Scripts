dataFiles = { ...
    '3002Data.mat','3005Data.mat','3006Data.mat','3007Data.mat','3008Data.mat','3009Data.mat','3010Data.mat','3011Data.mat','3012Data.mat','3014Data.mat','3015Data.mat','3017Data.mat','3018Data.mat','3019Data.mat','3020Data.mat','3021Data.mat','3022Data.mat','3023Data.mat','3025Data.mat','3026Data.mat', ...
    '4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4019Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4035Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4042Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};
dataFolder = '/Users/scien/Documents/MATLAB/HiResData';

% parameter
freqlist = [10 20 30 40];
chan = 2;
stimFreqIdx = 10;     % stimulation frequency index to visualize
windowPts = 18;
freqAxis = linspace(-0.5, 0.5, windowPts);
datacutmean = []; % Initialize variable to store mean data
datacutfmean = zeros(numel(freqlist), 37); % Preallocate for frequency data

%% Build datacutmean for all subjects
datacutmean = [];
datacutfmean = zeros(numel(freqlist), 37);

for f = 1:numel(dataFiles)
    filename = fullfile(dataFolder, dataFiles{f});
    load(filename, 'SubjectData');

    EntrainRatioData = SubjectData.EntrainRatioData;

    for stimfreq = 1:numel(freqlist)
        data = squeeze(EntrainRatioData(chan, :, freqlist(stimfreq)));
        freqpos = find(abs(SubjectData.f - freqlist(stimfreq)) == ...
                       min(abs(SubjectData.f - freqlist(stimfreq))), 1);

        datacut = data(freqpos-18:freqpos+18);
        datacutf = SubjectData.f(freqpos-18:freqpos+18);

        datacutmean = cat(1, datacutmean, datacut);
        datacutfmean(stimfreq,:) = datacutf;
    end
end

%% Plot grand mean across subj
grandmean = [];
for freq=1:numel(freqlist);
    grandmean(freq,:) = mean(datacutmean(freq:numel(freqlist):end,:),1); % Calculate the mean across all subjects for the current frequency
end

% Optional smoothing for aesthetics:
% for freq = 1:numel(freqlist)
%     plot(smooth(grandmean(freq,:), 10), 'LineWidth', 2, 'Color', colors(freq,:));
% end

%% Plot grand mean across subj (split by 3000s and 4000s)
grandmean_all = [];
grandmean_3000 = [];
grandmean_4000 = [];

% Make numeric subject IDs from filenames
subjIDs = cellfun(@(x) str2double(x(1:4)), dataFiles);

% Determine which subjects belong to each group
idx3000 = find(subjIDs >= 3000 & subjIDs < 4000);
idx4000 = find(subjIDs >= 4000 & subjIDs < 5000);

nSubj = numel(subjIDs);
nFreq = numel(freqlist);

% --- Reshape datacutmean so that we can separate subjects cleanly ---
% Current datacutmean is stacked by frequency across all subjects.
% Each subject contributes nFreq rows to datacutmean.
datacutmean_reshaped = reshape(datacutmean, [nFreq, nSubj, size(datacutmean,2)]);

% --- Compute grand means ---
for freq = 1:nFreq
    grandmean_all(freq,:)   = mean(squeeze(datacutmean_reshaped(freq,:,:)), 1, 'omitnan');
    grandmean_3000(freq,:)  = mean(squeeze(datacutmean_reshaped(freq,idx3000,:)), 1, 'omitnan');
    grandmean_4000(freq,:)  = mean(squeeze(datacutmean_reshaped(freq,idx4000,:)), 1, 'omitnan');
end

% --- Plot overall grand mean ---
figure;
set(gcf, 'Color', 'w')
hold on;
colors = lines(nFreq);
for freq = 1:nFreq
    plot(grandmean_all(freq,:), 'LineWidth', 2, 'Color', colors(freq,:));
end
title('Grand Mean Across All Subjects', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Time (ms)', 'FontSize', 14);
ylabel('Amplitude (\muV)', 'FontSize', 14);
legend(string(freqlist), 'Location', 'best', 'Box', 'off');
grid on; box off;

% --- Plot grand mean for 3000s ---
figure;
set(gcf, 'Color', 'w')
hold on;
for freq = 1:nFreq
    plot(grandmean_3000(freq,:), 'LineWidth', 2, 'Color', colors(freq,:));
end
title('Grand Mean: 3000s Subjects', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Time (ms)', 'FontSize', 14);
ylabel('Amplitude (\muV)', 'FontSize', 14);
legend(string(freqlist), 'Location', 'best', 'Box', 'off');
grid on; box off;

% --- Plot grand mean for 4000s ---
figure;
set(gcf, 'Color', 'w')
hold on;
for freq = 1:nFreq
    plot(grandmean_4000(freq,:), 'LineWidth', 2, 'Color', colors(freq,:));
end
title('Grand Mean: 4000s Subjects', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Time (ms)', 'FontSize', 14);
ylabel('Amplitude (\muV)', 'FontSize', 14);
legend(string(freqlist), 'Location', 'best', 'Box', 'off');
grid on; box off;