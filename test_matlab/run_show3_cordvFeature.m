tic
close all;clear all;clc;
%%

% 1:11
rGroup=6;

% rGroup, rEpoch
% 01, 1:18
% 02, 1:27
% 03, 1:31
% 04, 1:38
% 05, 1:38
% 06, 1:54
% 07, 1:33
% 08, 1:41
% 09, 1:41
% 10, 1:37
% 11, 1:31
rEpoch=25;

% 1:nChannel
rChannel=[1:3:31];

% 1:nFeature
rSpike=[6];

% second
tSegment=60;
tLength=0.3;
tRange=[0,90];

oNode=1;
%%

marker='.';
markerSize=5;
markerEdgeColor='k';
markerFaceColor='k';
lineWidth=2;

ySpikeBeautyRate=0.1;
title_show=1;

featureSizeSet_xo=5;
featureSizeSet_xl=500;
featureSizeSet_yo=5;
featureSizeSet_yl=featureSizeSet_xl*(length(rChannel)*length(rSpike))/10;
figureSize_spike={0;[featureSizeSet_xo,featureSizeSet_yo,featureSizeSet_xl,featureSizeSet_yl]};

intervalSec=1/10;
pauseSec=1/1000000;
%%

fs=20000;
nChannel=31;
nFeature=7;

openField=1.8;
pPreM_x=450/openField;
pPreM_y=400/openField;

fps=29.97;

xRange=[1,720]/pPreM_x;
yRange=[-480,-1]/pPreM_y;

n_code=5;
n_node_feature=2;
%%

path_toolbox='D:\test_matlab\toolbox\eegGA\';
addpath(genpath(path_toolbox));
%%

path_data_spike=[pwd '\result(spike)\'];
path_data_spikeCluster=[pwd '\result(spikeCluster)\'];

old_file_all={
    'ec013.527';
    'ec013.528';
    'ec013.529';
    'ec013.713';
    'ec013.714';
    'ec013.754';
    'ec013.755';
    'ec013.756';
    'ec013.757';
    'ec013.808';
    'ec013.844';
    };
path_file_cord=[pwd '\result(cord_smooth)\group_' num2code(rGroup,n_code) '\' old_file_all{rGroup,1} '.mat'];
%%

D_spike=dir([path_data_spike 'group_' num2code(rGroup,n_code) '\*.mat']);
code_timeStamp=[];
load([path_data_spike 'group_' num2code(rGroup,n_code) '\' D_spike(rEpoch).name]);

D_cluster=dir([path_data_spikeCluster '\*.mat']);
clusterAll=[];
for r=1:nChannel
    
    cluster_C=[];
    load([path_data_spikeCluster '\' D_cluster(r).name]);
    clusterAll=[clusterAll;cluster_C];
end

n2_code=size(code_timeStamp,2);
t_code=(1:1:n2_code)/fs;

n2_spike=size(clusterAll,2);
t_spike=(1:1:n2_spike)/fs;

temp_color_all=colormap(jet(nChannel*nFeature));
close;

temp_code=[];
temp_spike=[];
temp_name=[];
temp_color=[];
r0=0;
for r1=1:nChannel
    for r2=1:nFeature
        
        if ismember(r1,rChannel) && ismember(r2,rSpike)
            
            temp_r=(r1-1)*nFeature+r2;
            r0=r0+1;
            
            temp_code(r0,:)=code_timeStamp(temp_r,:);
            temp_spike(r0,:)=clusterAll(temp_r,:);
            temp_name{r0,1}=['ch.(' num2code(r1,n_node_feature) ')'];
            temp_name{r0,2}=['spike(' num2code(r2,n_node_feature) ')'];
            temp_color(r0,:)=temp_color_all(temp_r,:);
        end
    end
end
temp_code(temp_code==0)=nan;

vSpike_max=max(max(temp_spike));
vSpike_min=min(min(temp_spike));

nRow=size(temp_code,1);
vLim_spike=[(1-ySpikeBeautyRate),(1+ySpikeBeautyRate)];
%%

cordMat_smooth=[];
load(path_file_cord);

cordPlot=cordMat_smooth{oNode,1};
nCord=size(cordPlot,1);

x=cordPlot(:,1);
y=cordPlot(:,2);
%%

figure
if figureSize_spike{1,1}==1
    set(gcf,'position',figureSize_spike{2,1});
end

nColumn=16;
for r=1:nRow
    
    subplot(nRow,nColumn,nColumn*(r-1)+1);
    plot(t_spike,temp_spike(r,:),'LineWidth',lineWidth,'color',temp_color(r,:));
    
    xlim([t_spike(1) t_spike(end)])
    ylim([vSpike_min vSpike_max]);
    
    if r~=nRow
        set(gca,'xTickLabel',[])
    end
    
    if title_show==1
        ylabel({temp_name{r,1};temp_name{r,2}},'fontWeight','bold');
    end
end

n_first=max([1,floor(tRange(1)*fs)]);
n_first=min([n2_code,n_first]);

n_last=min(n2_code,floor(tRange(2)*fs));
n_last=max([n_first,n_last]);

for rRefresh=n_first:floor(intervalSec*fs):n_last
    
    temp_first=rRefresh;
    temp_last=min([n_last floor(temp_first+fs*tLength)]);
    
    for r=1:nRow
        
        subplot(nRow,nColumn,[nColumn*(r-1)+2 nColumn*(r-1)+nColumn/2]);
        plot(t_code(temp_first:temp_last),temp_code(r,temp_first:temp_last),'k','Marker',marker,'MarkerSize',markerSize,'MarkerEdgeColor',markerEdgeColor,'MarkerFaceColor',markerFaceColor);
        
        xlim([temp_first temp_first+fs*tLength]/fs);
        ylim(vLim_spike);
        axis off;
    end
    
    subplot(1,2,2);
    temp_Frame_first=max([1,floor(fps*n_first/fs)]);
    temp_Frame_last=min([nCord,floor(fps*n_last/fs)]);
    
    temp_Frame_r1=max([temp_Frame_first,floor(fps*rRefresh/fs)]);
    temp_Frame_r1=min([temp_Frame_last,temp_Frame_r1]);
    
    temp_Frame_r2=min([temp_Frame_last,floor(temp_Frame_r1+fps*tLength)]);
    
    temp_Frame_first_epochAll=temp_Frame_first+(rEpoch-1)*tSegment;
    temp_Frame_r1_epochAll=temp_Frame_r1+(rEpoch-1)*tSegment;
    temp_Frame_r2_epochAll=temp_Frame_r2+(rEpoch-1)*tSegment;
    
    plot(x(temp_Frame_first_epochAll:temp_Frame_r1_epochAll)/pPreM_x,y(temp_Frame_first_epochAll:temp_Frame_r1_epochAll)/pPreM_y,'LineWidth',lineWidth,'color',0.7*[1,1,1]);
    hold on;
    plot(x(temp_Frame_r1_epochAll:temp_Frame_r2_epochAll)/pPreM_x,y(temp_Frame_r1_epochAll:temp_Frame_r2_epochAll)/pPreM_y,'LineWidth',lineWidth,'color',0*[1,1,1]);
    
    axis equal;
    if ~isempty(xRange)
        xlim(xRange);
    end
    if ~isempty(yRange)
        ylim(yRange);
    end
    
    if title_show==1
        xlabel([num2str(temp_Frame_r2/fps) ' sec'],'fontWeight','bold');
        title(['group(' num2str(rGroup) ') epoch(' num2str(rEpoch) ') t('  num2str(tLength) ' sec)'],'fontWeight','bold');
    end
    
    pause(pauseSec);
    if floor(temp_first+fs*tLength)>n2_code
        break;
    end
end
%%

rmpath(genpath(path_toolbox));
toc