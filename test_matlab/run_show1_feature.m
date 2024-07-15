tic
close all;clear all;clc;
%%

% 1:11
rGroup=1;

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
rEpoch=1;

% 1:nChannel
rChannel=1;

% tLim{1,1}
% -1, nothing
% 0, plot range
% 1, zoom out the range
% tLim{2,1}
% the time range
tLim={1;[23,24]};

ySpikeBeautyRate=0.1;
vLim_mm=[-500;500];

marker='.';
markerSize=5;
markerEdgeColor='k';
markerFaceColor='k';
lineWidth=2;

title_show=1;

featureSizeSet_xo=10;
featureSizeSet_xl=800;
featureSizeSet_yo=300;
featureSizeSet_yl=90;
figureSize_spike={1;[featureSizeSet_xo,featureSizeSet_yo,featureSizeSet_xl,featureSizeSet_yl]};
figureSize_mm={1;[featureSizeSet_xl,featureSizeSet_yo,featureSizeSet_xl,3*featureSizeSet_yl]};
%%

fs=20000;
nChannel=31;
fireRateFeature=[7]; % 1:7
fireRateRange=[0.1,0.5]; % range and overlapRate
yLimFireRate=[0,200];

n_code=5;

path_data={
    [pwd '\result(spike)\'];
    [pwd '\result(mm)\']
    };
path_toolbox='D:\test_matlab\toolbox\eegGA\';
%%

addpath(genpath(path_toolbox));
%%

for r1=1:size(path_data,1)
    
    D=dir([path_data{r1,1} 'group_' num2code(rGroup,n_code) '\*.mat']);
    
    code_timeStamp=[];
    code_mm=[];
    load([path_data{r1,1} 'group_' num2code(rGroup,n_code) '\' D(rEpoch).name]);
    
    temp_title='';
    if r1==1
        temp_code=code_timeStamp;
        if title_show==1
            temp_title=['  spike: [group(' num2str(rGroup) ') epoch(' num2str(rEpoch) ') channel('  num2str(rChannel) ')]'];
        end
    elseif r1==2
        temp_code=code_mm;
        if title_show==1
            temp_title=['  mm: [group(' num2str(rGroup) ') epoch(' num2str(rEpoch) ') channel('  num2str(rChannel) ')]'];
        end
    end
    code_timeStamp=[];
    code_mm=[];
    
    [n1,n2]=size(temp_code);
    nFeature=n1/nChannel;
    t=(1:1:n2)/fs;
    
    first=(rChannel-1)*nFeature+1;
    last=rChannel*nFeature;
    temp_feature=temp_code(first:last,:);
    temp_code=[];
    
    if r1==1
        vLim_spike=[(1-ySpikeBeautyRate*nFeature),(nFeature+ySpikeBeautyRate*nFeature)];
        
        figure
        if figureSize_spike{1,1}==1
            set(gcf,'position',figureSize_spike{2,1});
        end
        
        for r2=1:nFeature
            for r3=1:n2
                
                if temp_feature(r2,r3)==0
                    temp_feature(r2,r3)=nan;
                end
            end
            plot(t,r2*temp_feature(r2,:),'k','Marker',marker,'MarkerSize',markerSize,'MarkerEdgeColor',markerEdgeColor,'MarkerFaceColor',markerFaceColor);
            hold on;
        end
        xlim([t(1) t(end)]);
        ylim(vLim_spike);
        
        xlabel(['time/ s' temp_title],'FontWeight','bold');
        
        if tLim{1,1}==0
            plot([tLim{2,1}(1) tLim{2,1}(1)],vLim_spike,'g','LineWidth',lineWidth);
            hold on;
            plot([tLim{2,1}(2) tLim{2,1}(2)],vLim_spike,'g','LineWidth',lineWidth);
        elseif tLim{1,1}==1
            xlim(tLim{2,1});
        end
        
        figure
        if figureSize_spike{1,1}==1
            set(gcf,'position',figureSize_spike{2,1});
        end
        
        temp_fireRateAll=temp_feature(fireRateFeature,:);
        temp_fireRate=zeros(1,n2);
        for r2=1:n2
            
            if ismember(1,temp_fireRateAll(:,r2))
                temp_fireRate(1,r2)=1;
            end
        end
        
        stepRange=fireRateRange(1,1)*(1-fireRateRange(1,2));
        for r2=1:n2
            
            temp_first=floor((r2-1)*stepRange*fs+1);
            temp_last=floor(temp_first-1+fireRateRange(1,1)*fs);
            if temp_last>n2
                break;
            end
            fireRate(1,r2)=sum(temp_fireRate(1,temp_first:temp_last))/fireRateRange(1,1);
        end
        
        nFireRate=size(fireRate,2);
        tFireRate=(1:1:nFireRate)*stepRange;
        bar(tFireRate,fireRate,1,'FaceColor','w','EdgeColor','k','LineWidth',lineWidth);
        hold on;
        
        xlim([t(1) t(end)]);
        ylim(yLimFireRate);
        
        xlabel(['time/ s' temp_title],'FontWeight','bold');
        ylabel('fire rating','FontWeight','bold')
        
        if tLim{1,1}==0
            plot([tLim{2,1}(1) tLim{2,1}(1)],yLimFireRate,'g','LineWidth',lineWidth);
            hold on;
            plot([tLim{2,1}(2) tLim{2,1}(2)],yLimFireRate,'g','LineWidth',lineWidth);
        elseif tLim{1,1}==1
            xlim(tLim{2,1});
        end
        
    elseif r1==2
        figure
        if figureSize_mm{1,1}==1
            set(gcf,'position',figureSize_mm{2,1});
        end
        
        r0=0;
        for r2=1:nFeature
            
            if mod(r2,2)==1
                r0=r0+1;
                subplot(nFeature/2,1,r0);
                plot(t,temp_feature(r2,:),'b');
                hold on;
            elseif mod(r2,2)==0
                plot(t,-temp_feature(r2,:),'r');
                xlim([t(1) t(end)]);
                ylim(vLim_mm);
            end
            
            if r2==nFeature
                xlabel(['time/ s' temp_title],'FontWeight','bold');
            end
            
            if tLim{1,1}==0
                plot([tLim{2,1}(1) tLim{2,1}(1)],vLim_mm,'g','LineWidth',lineWidth);
                hold on;
                plot([tLim{2,1}(2) tLim{2,1}(2)],vLim_mm,'g','LineWidth',lineWidth);
            elseif tLim{1,1}==1
                xlim(tLim{2,1});
            end
        end
    end
end
%%

rmpath(genpath(path_toolbox));
toc