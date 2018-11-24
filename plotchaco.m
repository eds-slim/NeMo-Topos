load('ChaCo86.mat')

%% 
figure
%% plot mean ChaCo Score over all Wake-Up subjects

subplot(2,3,1:3)
[~,idx]=sort(nanmedian(CD.mean),'descend');
boxplot(CD.mean(:,idx),'plotstyle','compact', 'datalim',[0,1])
set(gca,'xtick',1:atlassize,'xticklabel',CD.labels(idx),'XTickLabelRotation',45)
title('mean Chaco Score')

%%
%% plot raw ChaCo Score for one Wake-Up subject. Variability from 73 subjects included in the NeMo toolbox.
IDs=[1 floor(n/2) n];

for i=1:length(IDs)
subplot(2,3,3+i)
boxplot(squeeze(CD.raw(IDs(i),:,:)),'plotstyle','compact', 'datalim',[0,1])
set(gca,'xtick',1:atlassize,'xticklabel',CD.labels(:),'XTickLabelRotation',45)
title(sprintf('raw Chaco Score for WakeUp subject %s', subjects(IDs(i)).name));
pos = get(gca, 'Position');
pos = [(i-1)/3+0.02, .1, .3, .45];
set(gca, 'Position', pos);
ax=gca;
ax.FontSize=8;
ax.TitleFontSizeMultiplier=2;
end