dataFiles = { ...
'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat', ...
'4015Data.mat','4017Data.mat','4018Data.mat','4020Data.mat','4022Data.mat', ...
'4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat', ...
'4033Data.mat','4034Data.mat','4036Data.mat','4037Data.mat','4038Data.mat', ...
'4039Data.mat','4040Data.mat','4041Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};

% freq bands
bands = struct();
bands.delta = 1:4;
bands.theta = 5:7;
bands.alpha = 8:12;
bands.beta  = 13:30;
bands.gamma = 31:50;
bandNames = fieldnames(bands);

% store band names
groupTopos = cell(numel(bandNames),1);

for s = 1:numel(dataFiles)
    load(dataFiles{s}, 'SubjectData');
    data = SubjectData.EntrainRatioData;  % 32 x 903 x 50
    faxis = SubjectData.f;                % 903 x 1
    stimFreqs = 1:50;                     % stim frequencies

    % map stim freqs to nearest f-axis indices
    freqIdx = zeros(size(stimFreqs));
    for i = 1:numel(stimFreqs)
        [~, freqIdx(i)] = min(abs(faxis - stimFreqs(i)));
    end

    for b = 1:numel(bandNames)
        stimRange = bands.(bandNames{b});
        fIdxs = freqIdx(stimRange);

        % diagonal entrainment for all channels
        diagVals = arrayfun(@(fi, si) data(:, fi, si), fIdxs, stimRange, 'UniformOutput', false);
        diagVals = cat(3, diagVals{:});  % 32 x 1 x nFreqs
        diagVals = squeeze(mean(diagVals, 2, 'omitnan')); % 32 x nFreqs

        % average across frequencies in the band
        bandTopo = mean(diagVals, 2, 'omitnan');  % 32 x 1

        % store per subject
        groupTopos{b} = [groupTopos{b}, bandTopo]; % 32 x nSubjects
    end
end

% average across subjects
meanTopos = cellfun(@(x) mean(x,2,'omitnan'), groupTopos, 'UniformOutput', false);

% determine color limits
allVals = cell2mat(meanTopos);
vmin = min(allVals(:));
vmax = max(allVals(:));
if vmin == vmax || isnan(vmin)
    vmin = -0.1; vmax = 0.1;
end
mapLimits = [vmin vmax];

% topoplots
figure('Name','Entrainment Ratio Topoplots','NumberTitle','off');
sgtitle('Average Entrainment Ratio by Band (All Subjects)');

for b = 1:numel(bandNames)
    subplot(2,3,b);
    topoplot(meanTopos{b}, SubjectData.chanlocs, ...
             'electrodes','on', 'numcontour',0, ...
             'maplimits',mapLimits);
    title(upper(bandNames{b}));
end

% for future try to put beta on a smaller scale (squeeze range)
% 'tiled layout' in the subplot!
colormap jet;
h = colorbar('Position',[0.92 0.1 0.02 0.8]);
ylabel(h, 'Entrainment Ratio');
