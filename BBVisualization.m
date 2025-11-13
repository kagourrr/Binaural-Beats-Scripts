dataFiles = { ...
    '3002Data.mat','3005Data.mat','3006Data.mat','3007Data.mat','3008Data.mat','3009Data.mat','3010Data.mat','3011Data.mat','3012Data.mat','3014Data.mat','3015Data.mat','3017Data.mat','3018Data.mat','3019Data.mat','3020Data.mat','3021Data.mat','3022Data.mat','3023Data.mat','3025Data.mat','3026Data.mat', ...
    '4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4019Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4035Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4042Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};
dataFiles = {'4025Data.mat','4040Data.mat'}; %uncomment if i wanna do a few at a time
dataFolder = '/Users/scien/Documents/MATLAB/HiResData';

%% show full spectrum
% parameter
freqlist = [20 40];
chan = 2;
stimFreqIdx = 10;     % stimulation frequency index to visualize
windowPts = 180;
freqAxis = linspace(-0.5, 0.5, windowPts);
datacutmean = []; % initialize variable to store mean data
datacutfmean = zeros(numel(freqlist), 37); % preallocate for frequency data

% Loop over subjects
for f = 1:numel(dataFiles)
    filename = fullfile(dataFolder, dataFiles{f});

    % Load structure
    load(filename, 'SubjectData');

    % Extract data (32 × 903 × 50)
    EntrainRatioData = SubjectData.EntrainRatioData;

    for stimfreq = 1:numel(freqlist)
        % Select 1 channel × all measured frequencies × 1 stim freq
        data = squeeze(EntrainRatioData(chan, :, freqlist(stimfreq)));
        freqpos = find(abs(SubjectData.f-freqlist(stimfreq))==min(abs(SubjectData.f-freqlist(stimfreq))),1);

        % Define 18-pt window
        datacut = data(freqpos-18:freqpos+18);
        datacutf = SubjectData.f(freqpos-18:freqpos+18);
        datacutmean = cat(1,datacutmean,datacut);
        datacutfmean(stimfreq,:)=datacutf;

        % Moving averages
        movAvg3 = movmean(datacut, 3);
        movAvg5 = movmean(datacut, 5);

        % Local z-score
        zLocal = zscore(datacut);

        % Plot
        figure('Color', 'w');
        hold on;
        plot(datacutf, datacut, 'k-o', 'DisplayName', 'Raw');
        plot(datacutf, movAvg3, 'r-', 'LineWidth', 1.5, 'DisplayName', '+3pt Moving Avg');
        plot(datacutf, movAvg5, 'b-', 'LineWidth', 1.5, 'DisplayName', '+5pt Moving Avg');
        plot(datacutf, zLocal, 'g--', 'LineWidth', 1.2, 'DisplayName', 'Local Z-score');
        hold off;

        xlabel('Window range (-0.5 to +0.5)');
        ylabel('Amplitude / Z-score');
        title(sprintf('%s | Ch %d | Stim %d', dataFiles{f}, chan, freqlist(stimfreq)), 'Interpreter', 'none');
        legend('show', 'Location', 'best');
        grid on;
    end
    % Save the figure automatically
    % saveas(gcf, fullfile(dataFolder, sprintf('%s_Channel%d.png', erase(dataFiles{f}, '.mat'), chan)));
    % close(gcf);
end
