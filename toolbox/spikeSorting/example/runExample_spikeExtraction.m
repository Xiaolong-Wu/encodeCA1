tic
close all;clear all;clc;
%%

path_data=[pwd '\'];
path_toolbox='D:\test_matlab\toolbox\spikeSorting';
%%

fs=20000;
segmentationShow=3;
segmentationT=2;
olr=0.5;
threshold=[-90,30];
Center='mid';
Modify=0;
%%

load([path_data 'lfp.mat']); % unit: V
S=lfp*10^6; % unit: ¦ÌV

sAll=S'; % extract all of the typical spikes from signal sAll
sSorting=S'; % analyze sSorting by all of the extracted typical spikes
%%

cluster_K=4;
cluster_thr_iter=100;
cluster_thr_replicates=5;
%%

plot_show=1;

LineWidthOri=2;
LineWidth=1;
MarkerSize=0;

vLim=[-2000 2000];
%%

addpath(genpath(path_toolbox));
path_spikeCluster=[path_data 'spikeCluster.mat'];

if exist(path_spikeCluster,'file')
    disp([path_spikeCluster ' exist, skip.']);
else
    [~,spikeShapeAll,~]=spikeExtraction(sAll,fs,segmentationShow,segmentationT,olr,threshold,Center,Modify);
    cluster_C=spikeSortingCluster(spikeShapeAll,cluster_K,cluster_thr_iter,cluster_thr_replicates);
    
    save(path_spikeCluster,'cluster_C');
    disp([path_spikeCluster ' have been done.']);
end
%%

load(path_spikeCluster);
[timeStamp,spikeShape,sRes]=spikeExtraction(sSorting,fs,segmentationShow,segmentationT,olr,threshold,Center,Modify);
[timeStampSorting,spikeShapeSorting]=spikeSortingResult(timeStamp,spikeShape,cluster_K,cluster_C);

rmpath(genpath(path_toolbox));
%%

if plot_show
    n_t=length(sSorting);
    seconds=(0:1:n_t-1)/fs;
    
    color_temp=jet(cluster_K);
    
    figure
    plot(seconds,sSorting,'Color',[0,0,0],'LineWidth',LineWidthOri);
    xlim([seconds(1) seconds(end)]);
    ylim(vLim);
    xlabel('time (sec)','Fontweight','bold');
    ylabel('LFP/ \muV','Fontweight','bold');
    title('raw LFP','Fontweight','bold');
    
    figure
    plot(seconds,sSorting,'Color',[0,0,0],'LineWidth',LineWidthOri);
    hold on;
    plot(seconds,sRes,'Color',[1,0,0],'LineWidth',LineWidth);
    xlim([seconds(1) seconds(end)]);
    ylim(vLim);
    xlabel('time (sec)','Fontweight','bold');
    ylabel('LFP/ \muV','Fontweight','bold');
    legend({'raw LFP';'residual'});
    
    figure
    stem(seconds,timeStamp,'Color',[0,0,0],'LineWidth',LineWidth,'markerSize',MarkerSize);
    xlim([seconds(1) seconds(end)]);
    ylim([0,1.2]);
    set(gca,'YTickLabel',[]);
    xlabel('time (sec)','Fontweight','bold');
    title('time stamps of spikes','Fontweight','bold');
    
    figure
    Legend=[];
    for r=1:cluster_K
        
        plot(0,0,'Color',color_temp(r,:),'LineWidth',LineWidth);
        hold on;
        
        Legend{r,1}=['spike-' num2str(r)];
    end
    for r=1:cluster_K
        
        stem(seconds,timeStampSorting(:,r),'Color',color_temp(r,:),'LineWidth',LineWidth,'markerSize',MarkerSize);
        hold on;
    end
    xlim([seconds(1) seconds(end)]);
    ylim([0,1.2]);
    set(gca,'YTickLabel',[]);
    xlabel('time (sec)','Fontweight','bold');
    title('time stamps of spikes with clustering','Fontweight','bold');
    legend(Legend);
    
    Min=min(min(spikeShape));
    Max=max(max(spikeShape));
    
    n_tTemp=size(spikeShape,2);
    secondsTemp=(0:1:n_tTemp-1)/fs;
    switch Center
        case 'down'
            xBar=(n_tTemp-1)/(4*fs);
        case 'up'
            xBar=3*(n_tTemp-1)/(4*fs);
        case 'mid'
            xBar=2*(n_tTemp-1)/(4*fs);
    end
    
    figure
    for r=1:size(spikeShape,1)
        
        spikeTemp=spikeShape(r,:);
        for r2=1:n_tTemp
            
            if spikeTemp(1,r2)==0
                spikeTemp(1,r2)=nan;
            else
                break;
            end
        end
        for r2=1:n_tTemp
            
            if spikeTemp(1,end+1-r2)==0
                spikeTemp(1,end+1-r2)=nan;
            else
                break;
            end
        end
        
        plot(secondsTemp,spikeTemp,'Color',[0,0,0],'LineWidth',LineWidth);
        hold on;
    end
    plot([secondsTemp(1),secondsTemp(end)],[0,0],'Color',[0,0,0],'LineWidth',LineWidthOri);
    hold on;
    plot([xBar,xBar],[Min,Max],'Color',[0,0,0],'LineWidth',LineWidthOri);
    hold on;
    xlim([secondsTemp(1) secondsTemp(end)]);
    ylim([Min Max]);
    xlabel('time (sec)','Fontweight','bold');
    ylabel('spike/ \muV','Fontweight','bold');
    title('spike-all','Fontweight','bold');
    
    for r1=1:cluster_K
        
        figure
        for r2=1:size(spikeShapeSorting{1,r1},1)
            
            spikeTemp=spikeShapeSorting{1,r1}(r2,:);
            for r3=1:n_tTemp
                
                if spikeTemp(1,r3)==0
                    spikeTemp(1,r3)=nan;
                else
                    break;
                end
            end
            for r3=1:n_tTemp
                
                if spikeTemp(1,end+1-r3)==0
                    spikeTemp(1,end+1-r3)=nan;
                else
                    break;
                end
            end
            
            plot(secondsTemp,spikeTemp,'Color',color_temp(r1,:),'LineWidth',LineWidth);
            hold on;
        end
        plot([secondsTemp(1),secondsTemp(end)],[0,0],'Color',[0,0,0],'LineWidth',LineWidthOri);
        hold on;
        plot([xBar,xBar],[Min,Max],'Color',[0,0,0],'LineWidth',LineWidthOri);
        hold on;
        xlim([secondsTemp(1) secondsTemp(end)]);
        ylim([Min Max]);
        xlabel('time (sec)','Fontweight','bold');
        ylabel('spike/ \muV','Fontweight','bold');
        title(Legend{r1,1},'Fontweight','bold');
    end
end
toc