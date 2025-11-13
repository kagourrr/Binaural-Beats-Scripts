%% show full spectrum
dataFiles = {'4006Data.mat','4009Data.mat','4010Data.mat','4013Data.mat','4014Data.mat','4015Data.mat','4017Data.mat','4018Data.mat','4019Data.mat','4020Data.mat','4022Data.mat','4025Data.mat','4028Data.mat','4029Data.mat','4031Data.mat','4032Data.mat','4033Data.mat','4034Data.mat','4035Data.mat','4036Data.mat','4037Data.mat','4038Data.mat','4039Data.mat','4040Data.mat','4041Data.mat','4042Data.mat','4043Data.mat','4044Data.mat','4045Data.mat'};
chan = 2; % Fz
freq = 40;
groupData = [];
freqs = 9:903;
for fileNum = 1:length(dataFiles)
    load(dataFiles{fileNum});
    data = squeeze(SubjectData.EntrainRatioData(chan,freqs,freq));
    groupData = cat(1,groupData,data);
end
groupDataZ=zscore(groupData,0,2);
figure;
subplot(2,2,1)
pcolor(1:length(dataFiles),SubjectData.f(freqs),groupData');
shading flat
colormap turbo
colorbar
subplot(2,2,2);
plot(SubjectData.f(freqs),groupData');
% surfc(1:length(dataFiles),SubjectData.f(freqs),groupDataZ');

%% Moving Z-score
mvmn = movmean(groupData',18)';
mvstd = movstd(groupData',18)';
mvz = ((groupData-mvmn)./mvstd);
subplot(2,2,3);
pcolor(1:length(dataFiles),SubjectData.f(freqs),mvmn');
shading flat
colormap turbo
colorbar

subplot(2,2,4);
plot(SubjectData.f(freqs),groupDataZ);
%% plot
%plot(SubjectData.f,data);
%xlabel('Frequency Spectrum');
