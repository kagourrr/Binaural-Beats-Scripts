% pcolor sorted by BAPQ scores and (subjs on y, freqs on x) with diag
% (4 subplots thru a loop) total top left, aloof top right, prag bot left,
% and rigid bot right
% also a pcolor plot with diag values z-scored
% stim plots also so now add 1.5 SD demarcation lines to find sig peaks

% subject files
dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};

% parameters
chan_Fz = 2;            % Fz
chans_cluster = [2 3 29]; % Fz, F3, F4
stimFreqs = 1:50;       % stim freqs
targetStim = 40;        % 40 Hz stim
savePlots = true;       % false to skip saving PNGs

% folder for plots
if savePlots && ~exist('subject_plots','dir')
    mkdir('subject_plots');
end

% loop through each subject file
% container for group diags
groupDiag = [];
for i = 1:length(dataFiles)
    load(dataFiles{i}, 'SubjectData');

    subjID = SubjectData.Subject;
    freqVals = SubjectData.f;  % 903 bins

    % https://www.mathworks.com/matlabcentral/answers/2129271-find-index-of-a-nearest-value
    % Find index for 40 Hz stim 
    freqDiag=zeros(1,50);
    cluster_spectrum = zeros(1,50);
    for freq=1:50
        [~, stimIdx] = min(abs(freqVals - freq));

    % entrainment ratio spectra 
    % Fz only
    freqDiag(freq) = squeeze(SubjectData.EntrainRatioData(chan_Fz, stimIdx, freq));

    % Average across Fz, F3, F4
    cluster_spectrum(freq) = squeeze(mean(SubjectData.EntrainRatioData(chans_cluster, stimIdx, freq), 1));

    end
    groupDiag = cat(1,groupDiag,freqDiag);
    % Plot
    figure('Name', ['Subject ' subjID ' - EntrainmentRatio Diag'], ...
           'Position', [400 300 900 500]);

    % Fz plot
    subplot(1,2,1);
    plot(stimFreqs, freqDiag, 'LineWidth', 1.5, 'Color', [0.2 0.4 0.8]);
    xlabel('Frequency (Hz)');
    ylabel('Entrainment Ratio');
    title('Fz Channel Response');
    xlim([0 50]); grid on;

    % BAPQ scores
    text(1, max(freqDiag)*0.95, ...
        sprintf('BAPQ Total: %d\nAloof: %d\nPragmatic: %d\nRigid: %d', ...
        SubjectData.BAPQ_Total, SubjectData.BAPQ_Aloof, ...
        SubjectData.BAPQ_Pragmatic, SubjectData.BAPQ_Rigid), ...
        'VerticalAlignment', 'top', 'FontSize', 10, 'BackgroundColor', 'w');

    % cluster average plot
    subplot(1,2,2);
    plot(stimFreqs, cluster_spectrum, 'LineWidth', 1.5, 'Color', [0.3 0.6 0.3]);
    xlabel('Frequency (Hz)');
    ylabel('Entrainment Ratio');
    title('Cluster (Fz, F3, F4) Mean');
    xlim([0 50]); grid on;

    sgtitle(['Subject ' subjID ' | Entrainment Ratio Diag'], 'FontSize', 14);

    % comment out if dont wanna save them as png bc we merge
    % save as PNG
    if savePlots
        saveas(gcf, fullfile('subject_plots', ['Subject_' subjID '_EntRatioDiag.png']));
    end

    close(gcf);
end

disp('Plots saved to folder: subject_plots');

% let's make the groupDiag plot
% plot(mean(groupDiag,1));

%% Group-level pcolor plots by BAPQ scores

% all BAPQ scores from SubjectData structs
BAPQ_Total = zeros(length(dataFiles),1);
BAPQ_Aloof = zeros(length(dataFiles),1);
BAPQ_Pragmatic = zeros(length(dataFiles),1);
BAPQ_Rigid = zeros(length(dataFiles),1);

for i = 1:length(dataFiles)
    load(dataFiles{i}, 'SubjectData');
    BAPQ_Total(i) = SubjectData.BAPQ_Total;
    BAPQ_Aloof(i) = SubjectData.BAPQ_Aloof;
    BAPQ_Pragmatic(i) = SubjectData.BAPQ_Pragmatic;
    BAPQ_Rigid(i) = SubjectData.BAPQ_Rigid;
end

% frequency axis (x)
freqAxis = stimFreqs; % 1:50

% plot diag entrainratio
figure('Name','Group EntrainmentRatio Diag by BAPQ','Position',[300 100 1000 800]);

bapqVars = {BAPQ_Total, BAPQ_Aloof, BAPQ_Pragmatic, BAPQ_Rigid};
titles = {'BAPQ Total','Aloof','Pragmatic','Rigid'};

for k = 1:4
    [~, sortIdx] = sort(bapqVars{k}, 'ascend');
    subplot(2,2,k);
    pcolor(freqAxis, 1:length(dataFiles), groupDiag(sortIdx,:));
    shading flat; colormap bone; colorbar;
    xlabel('Frequency (Hz)');
    ylabel('Subjects (sorted)');
    title(titles{k});
end

sgtitle('Group Entrainment Ratio Diagonal (Sorted by BAPQ)', 'FontSize', 14);

% btwn subj z-score
% plot z-score within each frequency (column-wise)
zGroupDiag = (groupDiag - repmat(mean(groupDiag,1),size(groupDiag,1),1)) ./ repmat(std(groupDiag,1),size(groupDiag,1),1);

figure('Name','Z-scored Group EntrainmentRatio Diag by BAPQ','Position',[300 100 1000 800]);

for k = 1:4
    [~, sortIdx] = sort(bapqVars{k}, 'ascend');
    subplot(2,2,k);
    pcolor(freqAxis, 1:length(dataFiles), zGroupDiag(sortIdx,:));
    shading flat; colormap jet; colorbar;
    xlabel('Frequency (Hz)');
    ylabel('Subjects (sorted)');
    title([titles{k} ' (z-scored)']);
end

sgtitle('Between Subjs Z-scored Group Entrainment Ratio Diagonal (Sorted by BAPQ)', 'FontSize', 14);

% w/i subj z-score (every subj z-score calc according to themselves)
% plot z-score within each frequency (column-wise)
zGroupDiag = (groupDiag - repmat(mean(groupDiag,2),1,size(groupDiag,2))) ./ repmat(std(groupDiag,[],2),1,size(groupDiag,2));
% wherever zscore is less than 2 set it to not a number
zGroupDiag(zGroupDiag < 1.5) = NaN;
zGroupDiag = -zGroupDiag;
figure('Name','Within Z-scored Group EntrainmentRatio Diag by BAPQ','Position',[300 100 1000 800]);

for k = 1:4
    [~, sortIdx] = sort(bapqVars{k}, 'ascend');
    subplot(2,2,k);
    pcolor(freqAxis, 1:length(dataFiles), zGroupDiag(sortIdx,:));
    shading flat; colormap bone; colorbar;
    xlabel('Frequency (Hz)');
    ylabel('Subjects (sorted)');
    title([titles{k} ' (z-scored)']);
end

sgtitle('Within Subjs Z-scored Group Entrainment Ratio Diagonal (Sorted by BAPQ)', 'FontSize', 14);


% Conduct Principal Component Analysis (PCA) on the groupDiag data
[coeff, score, latent, tsquared, explained, mu] = pca(groupDiag');

% Plot the scree plot
figure('Name', 'Scree Plot of PCA', 'Position', [300 100 800 600]);
pareto(explained);
xlabel('Principal Component');
ylabel('Variance Explained (%)');
title('Scree Plot');
grid on;

%% note for later
% rmatio; r.matlab package to load subjdata into our old rscript