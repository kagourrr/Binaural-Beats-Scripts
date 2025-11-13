%% HiResMovavg: File to plot moving averages (line plots) and local z-scores (pcolor plots) of high-resolution data 

% Load in subject data 
% Sublist= {...
% '3002Data.mat',  ...
% '3005Data.mat',  ...
% '3006Data.mat',  ...
% '3007Data.mat',  ...
% '3008Data.mat',  ...
% '3009Data.mat',  ...
% '3010Data.mat',  ...
% '3011Data.mat',  ...
% '3012Data.mat',  ...
% '3014Data.mat',  ...
% '3015Data.mat',  ...
% '3017Data.mat',  ...
% '3018Data.mat',  ...
% '3019Data.mat',  ...
% '3020Data.mat',  ...
% '3021Data.mat',  ...
% '3022Data.mat',  ...
% '3023Data.mat',  ...
% '3025Data.mat',  ...
% '3026Data.mat',  ...
% '4006Data.mat',  ...
% '4009Data.mat',  ...
% '4010Data.mat',  ...
% '4013Data.mat',  ...
% '4014Data.mat',  ...
% '4015Data.mat',  ...
% '4017Data.mat',  ...
% '4018Data.mat',  ...
% '4019Data.mat',  ...
% '4020Data.mat',  ...
% '4022Data.mat',  ...
% '4025Data.mat',  ...
% '4026Data.mat',  ...
% '4028Data.mat',  ...
% '4029Data.mat',  ...
% '4031Data.mat',  ...
% '4032Data.mat', ... 
% '4033Data.mat',  ...
% '4034Data.mat',  ...
% '4035Data.mat',  ...
% '4036Data.mat',  ...
% '4037Data.mat',  ...
% '4038Data.mat',  ...
% '4039Data.mat',  ...
% '4040Data.mat',  ...
% '4041Data.mat',  ...
% '4042Data.mat',  ...
% '4043Data.mat',  ...
% '4044Data.mat',  ...
% '4045Data.mat'}; 

Sublist = {
'4006Data.mat',  ...
'4009Data.mat',  ...
'4010Data.mat',  ...
'4013Data.mat',  ...
'4014Data.mat',  ...
'4015Data.mat',  ...
'4017Data.mat',  ...
'4018Data.mat',  ...
'4019Data.mat',  ...
'4020Data.mat',  ...
'4022Data.mat',  ...
'4025Data.mat',  ...
'4028Data.mat',  ...
'4029Data.mat',  ...
'4031Data.mat',  ...
'4032Data.mat', ... 
'4033Data.mat',  ...
'4034Data.mat',  ...
'4035Data.mat',  ...
'4036Data.mat',  ...
'4037Data.mat',  ...
'4038Data.mat',  ...
'4039Data.mat',  ...
'4040Data.mat',  ...
'4041Data.mat',  ...
'4042Data.mat',  ...
'4043Data.mat',  ...
'4044Data.mat',  ...
'4045Data.mat'};

% Mac paths:
% % load('/Users/izzyralph/Library/CloudStorage/OneDrive-William&Mary/Research Project/PLV/HiResData') % Load folder containing subject data
% datapath = '/Users/izzyralph/Library/CloudStorage/OneDrive-William&Mary/Research Project/PLV/HiResData'; % Folder containing subject data
% path2save = '/Users/izzyralph/Library/CloudStorage/OneDrive-William&Mary/Research Project/PLV/HighResFigs'; % Path to save figures

% Windows paths:
datapath = "C:\Users\izzyg\OneDrive - William & Mary\Research Project\PLV\HiResData"; 
path2save = "C:\Users\izzyg\OneDrive - William & Mary\Research Project\PLV\HiResFigs";
% set(groot, 'defaultFigureWindowState', 'fullscreen')
num3000s = 20; % count of 3000s 
num4000s = 40; % count of 4000s
%% Create structure that holds data for all subjects (did this so it is easier to plot)
% Datastruct = dir(fullfile(datapath, '*.mat'))
AllData = struct();
AllData.AvgAll = zeros(903, 50); 
AllData.Avg3000 = zeros(903, 50);
AllData.Avg4000 = zeros(903, 50); 

for s = 1:length(Sublist)
    ID = string("S" + Sublist{s}(1:4)); % Subject data name
    load(fullfile(datapath, Sublist{s})); % Load subject data
    AllData.(ID) = SubjectData; % Add subject data to structure holding all data
    AllData.AvgAll = AllData.AvgAll + squeeze(SubjectData.PLVData(:, 2, :))./length(Sublist);
    if str2num(Sublist{s}(1)) == 3 % Average by group
        AllData.Avg3000 = AllData.Avg3000 + squeeze(SubjectData.PLVData(:, 2, :))./num3000s; % average 3000s
    else
        AllData.Avg4000 = AllData.Avg4000 + squeeze(SubjectData.PLVData(:, 2, :))./num4000s; % average 4000s
    end
end

% save()
%% Plot moving average line graphs
f_subset = [10 20 30 40 50]; 

% linepath = '/Users/izzyralph/Library/CloudStorage/OneDrive-William&Mary/Research Project/PLV/HiResFigs/Line Plots';


for s = 32 %1:length(Sublist)
    ID = string("S" + Sublist{s}(1:4)); % Subject ID
    subdata = AllData.(ID).PLVData; % Subject data
    for idx = 1:length(f_subset)
        testf = f_subset(idx); % Stimulation frequency
        freqs = AllData.(ID).f; % Response frequencies
        ma3 = movmean(subdata(:, 2, testf), 3); % 3-point moving average
        ma5 = movmean(subdata(:, 2, testf), 5); % 5-point moving average
        ma11 = movmean(subdata(:, 2, testf), 11);

        fig = figure(); 
        hold on
        % plot(freqs, subdata(:, 2, testf), 'k-', 'DisplayName', "Real Data", "LineWidth", 2); % Plain data
        % plot(freqs, ma3, 'r-', 'DisplayName', "3-point Moving Average", 'LineWidth', 2); % 3-point moving average
        % plot(freqs, ma5, 'b-', 'DisplayName', "5-point Moving Average", 'LineWidth', 2); % 5-point moving average
                plot(freqs, ma11, 'b-', 'DisplayName', "11-point Moving Average", 'LineWidth', 2); % 5-point moving average

        % xlim([testf-0.5 testf+0.5])
        xlim([0 50])
        ylim([0 1])

        xlabel("Response Frequency (Hz)", 'FontSize', 15)
        ylabel("PLV", 'FontSize', 15)
        legend('Location', 'northeastoutside', 'FontSize', 10, 'Units', 'normalized');
        title(ID + " Fz PLVs and Moving Averages (" + testf + " Hz Stimulation)", 'FontSize', 20)
        set(gcf, 'color', 'w')
        pbaspect([2 1 1])
        fontsize(fig, scale = 2)
        set(fig, 'Units', 'normalized')
        orient(fig, 'landscape')
        % f.Clipping = 'off';

        set(fig, 'PaperPositionMode', 'auto')

        % figname = string(ID + "_" + testf + "Hz_movavg_lines");
        % saveas(gcf, fullfile(linepath, (figname + '.fig')))
        % % pause(2)
        % % exportgraphics(fig, fullfile(linepath, (figname + '.png')))
        % % % close
        % % 
        % close
    end
end

%% Store 3-point moving average, standard deviation, and z-score for all subjects + average
% 
% Matrices
% ma3 = movmean(matrix(:, 2, :), 3, 1); % 3-point moving avg 
% sd3 = movstd(matrix, 3, 0, 1) % 3-point moving stdev 
% zscore = (matrix - ma3)./sd3



MovData = struct(); % Structure to hold moving average, standard deviation, and z-score for each subject 
MovData.AvgZAll = zeros(903, 50); % average z-score of all subjects at Fz
MovData.AvgZ3000 = zeros(903, 50); % average z-score of 3000s at Fz
MovData.AvgZ4000 = zeros(903, 50); % average z-score of 4000s at Fz

MovData.AvgAll = zeros(903,50); % Hold average of all 3-point moving averages
MovData.Avg3000 = zeros(903,50); % Hold average of 3000's 3-point moving avgs 
MovData.Avg4000 = zeros(903, 50); % Hold average of 4000's 3-point moving avgs 

for s = 1:length(Sublist)
    ID = string("S" + Sublist{s}(1:4));
    subdata = squeeze(AllData.(ID).PLVData(:, 2, :)); % Subject data at channel Fz (measured x channel x stimulation)
    MovData.(ID).Avg = movmean(subdata, 3, 1); % 3-point moving average
    MovData.(ID).Sd = movstd(subdata, 3, 0, 1); % 3-point moving standard deviation (w = 0 [normalized by k-1])
    MovData.(ID).Z = (subdata - MovData.(ID).Avg)./MovData.(ID).Sd; % 3-point moving z-score
    MovData.AvgAll = MovData.AvgAll + MovData.(ID).Avg./length(Sublist); % Average all subjects
    
    
    MovData.AvgZAll = MovData.AvgZAll + MovData.(ID).Z./length(Sublist); % Z-score of all subjects

    if str2num(Sublist{s}(1)) == 3 % Average subjects' z-scores based on their IDs (3000s vs 4000s)
        MovData.Avg3000 = MovData.Avg3000 + MovData.(ID).Avg./num3000s; % Average of 3000s
        MovData.AvgZ3000 = MovData.AvgZ3000 + MovData.(ID).Z./num3000s; % Z-score of 3000s (currently 20 subjects)
    else
        MovData.Avg4000 = MovData.Avg4000 + MovData.(ID).Avg./num4000s; % Average of 4000s
        MovData.AvgZ4000 = MovData.AvgZ4000 + MovData.(ID).Z./num4000s; % Z-score of 4000s (currently 30 subjects)
    end
end


%% Plotting real data
% realmatpath = '/Users/izzyralph/Library/CloudStorage/OneDrive-William&Mary/Research Project/PLV/HiResFigs/Matrices/Real Data'; 
for s = 1:length(Sublist)
    ID = string("S" + Sublist{s}(1:4));
    data = squeeze(AllData.(ID).PLVData(:, 2, :)); % PLV data at Fz

    f = figure(); 
        sgtitle(ID + " PLVs at Fz", 'FontSize', 15)
        pcolor(1:50, AllData.(ID).f, data)

        col = colorbar;
        col.Label.String = 'PLV';
        col.Label.FontSize = 12;
        col.Label.Units = 'normalized';
        col.Label.Rotation = 270;
        clim([0 1])

        shading flat
        colormap turbo
        set(gcf, 'Color', 'w')
        xlabel("Stimulation Frequency (Hz)")
        ylabel("Response Frequency (Hz)")
        fontsize(f, scale = 2)
        set(f, 'Units', 'normalized', 'outerposition', [0 0 1 1])
        orient(f, 'landscape')
        f.Clipping = 'off';
        

        % set(f, 'PaperPositionMode', 'auto')
        % pause(3) % pause to make sure figure goes fullscreen before saving
        % 
        % figname = string(ID + "_realdata_matrix");
        % saveas(gcf, fullfile(realmatpath, (figname + '.fig')))
        % exportgraphics(f, fullfile(realmatpath, (figname + '.png')))
        % close
end

%% Plotting avg real data (all subs)
f = figure(); 
    data = AllData.AvgAll; 
    sgtitle("Average PLVs at Fz (All Subjects)", 'FontSize', 15)
    pcolor(1:50, AllData.S3002.f, data)

    col = colorbar;
    col.Label.String = 'PLV';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    clim([0 1])

    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f, scale = 2)
    set(f, 'Units', 'normalized')
    orient(f, 'landscape')
    f.Clipping = 'off';

    % set(f, 'PaperPositionMode', 'auto')
    % pause(3) % pause to make sure figure goes fullscreen before saving
    % 
    % figname = "Avg_All_realdata_matrix";
    % % pause(3) % Pause to finish rendering before saving
    % saveas(gcf, fullfile(realmatpath, (figname + '.fig')))
    % exportgraphics(gcf, fullfile(realmatpath, (figname + '.png')), 'Resolution', 300)
    % close

%% Plotting avg real data (3000s)
f = figure(); 
    data = AllData.Avg3000; 
    sgtitle("Average PLVs at Fz (3000s)", 'FontSize', 15)
    pcolor(1:50, AllData.S3002.f, data)

    col = colorbar;
    col.Label.String = 'PLV';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    clim([0 1])

    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f, scale = 2)
    set(f, 'Units', 'normalized')
    orient(f, 'landscape')
    f.Clipping = 'off';

    % set(f, 'PaperPositionMode', 'auto')
    % pause(3) % pause to make sure figure goes fullscreen before saving
    % 
    % figname = "Avg_3000s_realdata_matrix";
    % saveas(gcf, fullfile(realmatpath, (figname + '.fig')))
    % exportgraphics(f, fullfile(realmatpath, (figname + '.png')))
    % close
%% Plotting avg real data (4000s)
f = figure(); 
    data = AllData.Avg4000; 
    sgtitle("Average PLVs at Fz (4000s)", 'FontSize', 15)
    pcolor(1:50, AllData.S3002.f, data)

    col = colorbar;
    col.Label.String = 'PLV';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    clim([0 1])

    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f, scale = 2)
    set(f, 'Units', 'normalized')
    orient(f, 'landscape')
    f.Clipping = 'off';

    % set(f, 'PaperPositionMode', 'auto')
    % pause(3) % pause to make sure figure goes fullscreen before saving
    % 
    % figname = "Avg_4000s_realdata_matrix";
    % saveas(gcf, fullfile(realmatpath, (figname + '.fig')))
    % exportgraphics(f, fullfile(realmatpath, (figname + '.png')))
    % close    


%% Double-checking moving averages
% mavgpath = '/Users/izzyralph/Library/CloudStorage/OneDrive-William&Mary/Research Project/PLV/HiResFigs/Matrices/Moving Average'; 
% S4025 = 32, S4035 = 40
for s = 1:length(Sublist)
    ID = string("S" + Sublist{s}(1:4));
    data = MovData.(ID).Avg; % Measured x stimulation at Fz
    f = figure(); 
        sgtitle(ID + " PLV 3-Point Moving Averages at Fz", 'FontSize', 15)
        pcolor(1:50, AllData.(ID).f, data)

        col = colorbar;
        col.Label.String = 'PLV';
        col.Label.FontSize = 12;
        col.Label.Units = 'normalized';
        col.Label.Rotation = 270;
        clim([0 1])

        shading flat
        colormap turbo
        set(gcf, 'Color', 'w')
        xlabel("Stimulation Frequency (Hz)")
        ylabel("Response Frequency (Hz)")
        fontsize(f, scale = 2)
        set(f, 'Units', 'normalized')
        orient(f, 'landscape')
        f.Clipping = 'off';

        % set(f, 'PaperPositionMode', 'auto')
        % pause(3) % pause to make sure figure goes fullscreen before saving
        % 
        % figname = string(ID + "_3pt_avg_matrix");
        % saveas(gcf, fullfile(mavgpath, (figname + '.fig')))
        % exportgraphics(f, fullfile(mavgpath, (figname + '.png')))
        % close
end

%% Plotting avg of moving avg of all subjects
f1 = figure(); % Average of all subjects
    sgtitle("3-point Moving Average at Fz (All Subjects)", 'FontSize', 15)
    pcolor(1:50, AllData.S3002.f, MovData.AvgAll) % Usage of S3002 is trivial, just need to get measured freq list
    col = colorbar;
    col.Label.String = 'PLV';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    clim([0 1])

    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f1, scale = 2)
    set(f1, 'Units', 'normalized')
    orient(f1, 'landscape')
    set(f1, 'PaperPositionMode', 'auto')
    
    % pause(3)
    % figname = "Avg_Movavg_All";
    % saveas(gcf, fullfile(mavgpath, (figname + '.fig')))
    % exportgraphics(f1, fullfile(mavgpath, (figname + '.png')))

%% Average of 3000s
f2 = figure(); 
    sgtitle("3-point Moving Average at Fz (3000s)", 'FontSize', 15)
    pcolor(1:50, AllData.S3002.f, MovData.Avg3000) % Usage of S3002 is trivial, just need to get measured freq list
    col = colorbar;
    col.Label.String = 'PLV';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    clim([0 1])

    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f2, scale = 2)
    set(f2, 'Units', 'normalized')
    orient(f2, 'landscape')
    set(f2, 'PaperPositionMode', 'auto')

    % pause(3)

    % figname = "Avg_Movavg_3000s";
    % saveas(gcf, fullfile(mavgpath, (figname + '.fig')))
    % exportgraphics(f2, fullfile(mavgpath, (figname + '.png')))

%% Average of 4000s
f3 = figure(); 
    sgtitle("3-point Moving Average at Fz (4000s)", 'FontSize', 15)
    pcolor(1:50, AllData.S3002.f, MovData.Avg4000) % Usage of S3002 is trivial, just need to get measured freq list
    col = colorbar;
    col.Label.String = 'PLV';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    clim([0 1])

    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f3, scale = 2)
    set(f3, 'Units', 'normalized')
    orient(f3, 'landscape')
    set(f3, 'PaperPositionMode', 'auto')

    % pause(3)
    % 
    % figname = "Avg_Movavg_4000s";
    % saveas(gcf, fullfile(mavgpath, (figname + '.fig')))
    % exportgraphics(f3, fullfile(mavgpath, (figname + '.png')))

%% Plotting individual z-score matrices
% nan-masked previously (commented out) and none had any significant points
% zpath = '/Users/izzyralph/Library/CloudStorage/OneDrive-William&Mary/Research Project/PLV/HiResFigs/Matrices/Z Scores'; 
for s = 1:length(Sublist)
    ID = string("S" + Sublist{s}(1:4));
    data = MovData.(ID).Z; % Measured x stimulation at Fz

    % nandata = MovData.(ID).Z;
    % nandata(nandata<1.96) = NaN;

    f = figure(); 
        sgtitle(ID + " 3-Point Moving Z-Scores at Fz", 'FontSize', 15)
        pcolor(1:50, AllData.(ID).f, data)

        % pcolor(1:50, AllData.(ID).f, nandata)

        col = colorbar;
        col.Label.String = 'Z';
        col.Label.FontSize = 12;
        col.Label.Units = 'normalized';
        col.Label.Rotation = 270;

        shading flat
        colormap turbo
        set(gcf, 'Color', 'w')
        xlabel("Stimulation Frequency (Hz)")
        ylabel("Response Frequency (Hz)")
        fontsize(f, scale = 2)
        set(f, 'Units', 'normalized')
        
        orient(f, 'landscape')
        set(f, 'PaperPositionMode', 'auto')
        % pause(3)
        % 
        % figname = string(ID + "_3pt_Z_matrix");
        % saveas(gcf, fullfile(zpath, (figname + '.fig')))
        % exportgraphics(f, fullfile(zpath, (figname + '.png')))
        % close

end

%% Plotting moving z of All subjects
f = figure(); 
    sgtitle("Average 3-point Moving Z-Scores at Fz (All Subjects)")
    pcolor(1:50, AllData.S3002.f, MovData.AvgZAll) % Chose S3002 because it seems all subjects have the same measured freqs (trivial)
    col = colorbar;
    col.Label.String = 'Z';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    
    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f, scale = 2)
    set(f, 'Units', 'normalized')

    % orient(f, 'landscape')
    % set(f, 'PaperPositionMode', 'auto')
    % pause(3)
    % 
    % figname = "AvgALL_3pt_Z_matrix";
    % saveas(gcf, fullfile(zpath, (figname + '.fig')))
    % exportgraphics(f, fullfile(zpath, (figname + '.png')))
    % close

%% Plotting moving z of 3000s
f = figure(); 
    sgtitle("Average 3-point Moving Z-Scores at Fz (3000s)")
    pcolor(1:50, AllData.S3002.f, MovData.AvgZ3000) % Chose S3002 because it seems all subjects have the same measured freqs (trivial)
    col = colorbar;
    col.Label.String = 'Z';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    
    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f, scale = 2)
    set(f, 'Units', 'normalized')

    % orient(f, 'landscape')
    % set(f, 'PaperPositionMode', 'auto')
    % pause(3)
    % 
    % figname = "Avg3000_3pt_Z_matrix";
    % saveas(gcf, fullfile(zpath, (figname + '.fig')))
    % exportgraphics(f, fullfile(zpath, (figname + '.png')))
    % close

%% Plotting moving z of 4000s
f = figure(); 
    sgtitle("Average 3-point Moving Z-Scores at Fz (4000s)")
    pcolor(1:50, AllData.S3002.f, MovData.AvgZ4000) % Chose S3002 because it seems all subjects have the same measured freqs (trivial)
    col = colorbar;
    col.Label.String = 'Z';
    col.Label.FontSize = 12;
    col.Label.Units = 'normalized';
    col.Label.Rotation = 270;
    
    shading flat
    colormap turbo
    set(gcf, 'Color', 'w')
    xlabel("Stimulation Frequency (Hz)")
    ylabel("Response Frequency (Hz)")
    fontsize(f, scale = 2)
    set(f, 'Units', 'normalized')

    orient(f, 'landscape')
    set(f, 'PaperPositionMode', 'auto')
    pause(3)

    % figname = "Avg4000_3pt_Z_matrix";
    % saveas(gcf, fullfile(zpath, (figname + '.fig')))
    % exportgraphics(f, fullfile(zpath, (figname + '.png')))
    % close