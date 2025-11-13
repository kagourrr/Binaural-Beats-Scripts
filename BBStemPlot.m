% stim plots also so now add 1.5 SD demarcation lines to find sig peaks

%% conradi smith example

% close all; clc; clear
% 
% N=50;
% f=1:N;
% x = exprnd(1,N,1);
% 
% stem(f,x); hold on;
% 
% mu = mean(x);
% sigma = std(x);
% xextreme = mu+2*sigma;
% aextreme = find(x>xextreme);
% 
% plot(f,mu*ones(size(f)),'k--')
% plot(f,xextreme*ones(size(f)),'r--')
% stem(f(aextreme),x(aextreme),'r*','LineWidth',2)
% return

%% STEM plots per subject

close all; clc;

% subject files
dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};

% parameters
chan_Fz = 2;             % Fz
chans_cluster = [2 3 29]; % Fz, F3, F4
stimFreqs = 1:50;        % stim freqs
savePlots = true;

if savePlots && ~exist('subject_plots','dir')
    mkdir('subject_plots');
end

groupDiag = [];

for i = 1:length(dataFiles)
    load(dataFiles{i}, 'SubjectData');
    subjID = SubjectData.Subject;
    freqVals = SubjectData.f;

    freqDiag = zeros(1,50);
    for freq = 1:50
        [~, stimIdx] = min(abs(freqVals - freq));
        freqDiag(freq) = squeeze(SubjectData.EntrainRatioData(chan_Fz, stimIdx, freq));
    end

    groupDiag = cat(1, groupDiag, freqDiag);

    % thresholds 
    mu = mean(freqDiag);
    sigma = std(freqDiag);
    upperThresh = mu + 1.5*sigma;   
    lowerThresh = mu - 1.5*sigma;   

    % peaks above threshold
    peaksIdx = find(freqDiag > upperThresh);

    % plot
    figure('Name', ['Subject ' subjID ' - Stem Plot'], 'Position', [300 300 800 400]);
    stem(stimFreqs, freqDiag, 'filled', 'LineWidth', 1.3, 'Color', [0.2 0.4 0.8]); hold on;
    plot(stimFreqs, mu*ones(size(stimFreqs)), 'k--', 'LineWidth', 1);
    plot(stimFreqs, upperThresh*ones(size(stimFreqs)), 'r--', 'LineWidth', 1);
    stem(stimFreqs(peaksIdx), freqDiag(peaksIdx), 'r', 'filled', 'LineWidth', 2);
    hold off;

    xlabel('Frequency (Hz)');
    ylabel('Entrainment Ratio');
    title(sprintf('Subject %s | Peaks > 1.5 SD (Fz)', subjID));
    grid on; xlim([0 50]);
    legend({'Entrainment Ratio','Mean','+1.5 SD','Peaks >1.5SD'}, 'Location', 'best');

    if savePlots
        saveas(gcf, fullfile('subject_plots', ['Subject_' subjID '_StemPlot.png']));
    end

    close(gcf);
end

disp('Stem plots saved to folder: subject_plots');



% % subject files
% dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};
% 
% % parameters
% chan_Fz = 2;            % Fz
% chans_cluster = [2 3 29]; % Fz, F3, F4
% stimFreqs = 1:50;       % stim freqs
% targetStim = 40;        % 40 Hz stim
% savePlots = true;       % false to skip saving PNGs
% 
% % folder for plots
% if savePlots && ~exist('subject_plots','dir')
%     mkdir('subject_plots');
% end
% 
% % loop through each subject file
% % container for group diags
% groupDiag = [];
% for i = 1:length(dataFiles)
%     load(dataFiles{i}, 'SubjectData');
% 
%     subjID = SubjectData.Subject;
%     freqVals = SubjectData.f;  % 903 bins
% 
%     % https://www.mathworks.com/matlabcentral/answers/2129271-find-index-of-a-nearest-value
%     % Find index for 40 Hz stim 
%     freqDiag=zeros(1,50);
%     cluster_spectrum = zeros(1,50);
%     for freq=1:50
%         [~, stimIdx] = min(abs(freqVals - freq));
% 
%     % entrainment ratio spectra 
%     % Fz only
%     freqDiag(freq) = squeeze(SubjectData.EntrainRatioData(chan_Fz, stimIdx, freq));
% 
%     % Average across Fz, F3, F4
%     cluster_spectrum(freq) = squeeze(mean(SubjectData.EntrainRatioData(chans_cluster, stimIdx, freq), 1));
% 
%     end
%     groupDiag = cat(1,groupDiag,freqDiag);
%     % Plot
%     figure('Name', ['Subject ' subjID ' - EntrainmentRatio Diag'], ...
%            'Position', [400 300 900 500]);
% 
%     % Fz plot
%     subplot(1,2,1);
%     plot(stimFreqs, freqDiag, 'LineWidth', 1.5, 'Color', [0.2 0.4 0.8]);
%     xlabel('Frequency (Hz)');
%     ylabel('Entrainment Ratio');
%     title('Fz Channel Response');
%     xlim([0 50]); grid on;
% 
%     % BAPQ scores
%     text(1, max(freqDiag)*0.95, ...
%         sprintf('BAPQ Total: %d\nAloof: %d\nPragmatic: %d\nRigid: %d', ...
%         SubjectData.BAPQ_Total, SubjectData.BAPQ_Aloof, ...
%         SubjectData.BAPQ_Pragmatic, SubjectData.BAPQ_Rigid), ...
%         'VerticalAlignment', 'top', 'FontSize', 10, 'BackgroundColor', 'w');
% 
%     % cluster average plot
%     subplot(1,2,2);
%     plot(stimFreqs, cluster_spectrum, 'LineWidth', 1.5, 'Color', [0.3 0.6 0.3]);
%     xlabel('Frequency (Hz)');
%     ylabel('Entrainment Ratio');
%     title('Cluster (Fz, F3, F4) Mean');
%     xlim([0 50]); grid on;
% 
%     sgtitle(['Subject ' subjID ' | Entrainment Ratio Diag'], 'FontSize', 14);
% 
%     % comment out if dont wanna save them as png bc we merge
%     % save as PNG
%     if savePlots
%         saveas(gcf, fullfile('subject_plots', ['Subject_' subjID '_EntRatioDiag.png']));
%     end
% 
%     close(gcf);
% end
% 
% disp('Plots saved to folder: subject_plots');
% 
% % let's make the groupDiag plot
% % plot(mean(groupDiag,1));