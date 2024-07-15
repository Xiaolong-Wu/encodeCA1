tic
close all; % clear all;clc;
%%

path_data=[pwd '\'];
path_toolbox={
    'D:\test_matlab\toolbox\eegGA\';
    'D:\test_matlab\toolbox\spikeSorting\'
    };
path_sAll=[path_data 'ec013.527(00300s)(20000Hz)(epoch-00001).mat'];
path_spike_result=[path_data 'result(spike)\'];
%%

% rGroup=1; % 1:11
% rEpoch=1;
% rChannel=1; % 1:31
%%

fs=20000;
fs_filter=[800,5000];

nChannel=31;

% ms
segmentationShow=1.2;
segmentationT=1;
olr=0.75;

% unit: ¦ÌV
threshold=[-30,0];
Center='down';
Modify=0;

n_code=5;
n_code_channel=2;
%%

cluster_K=7;
cluster_thr_iter=1000;
cluster_thr_replicates=5;
%%

plot_show=1;
plot_show_spike=1;

LineWidthOri=2;
LineWidth=1;
MarkerSize=1;

% unit: ¦ÌV
vLim=[-1000 1000];

% vLim_spike(1,1):
% 1, according to all cluster_C vLim_spike(1,2)*[Max-Min] extend [Min,Max]
% 2, according to all spike [Min,Max]
vLim_spike=[1,0.5];

timePause=5;
%%

addpath(genpath(path_toolbox{1,1}));
addpath(genpath(path_toolbox{2,1}));
%%

path_sSorting_group=[path_data 'group_' num2code(rGroup,n_code) '\'];
D=dir([path_sSorting_group '*.mat']);
path_sSorting=[path_sSorting_group D(rEpoch).name];

disp(' ');
disp(['load (' num2str(rEpoch) '/' num2str(length(D)) '):']);
disp(path_sSorting);

new_data=[];
load(path_sSorting);

sSorting_ori=new_data(rChannel,:);
new_data=[];

[~,eegPS]=wave_PS(sSorting_ori,fs,fs_filter,[0,0],'flat');
sSorting=eegPS{1,1}(1,:)'; % analyze sSorting by all of the extracted typical spikes
%%

path_spikeCluster=[path_data 'spikeCluster-ch(' num2code(rChannel,n_code_channel) ').mat'];

if exist(path_spikeCluster,'file')
    disp([path_spikeCluster ' exist, skip.']);
else
    new_data=[];
    load(path_sAll);
    
    sAll_ori=new_data(rChannel,:);
    new_data=[];
    
    [~,eegPS]=wave_PS(sAll_ori,fs,fs_filter,[0,0],'flat');
    sAll=eegPS{1,1}(1,:)'; % extract all of the typical spikes from signal sAll
    
    [~,spikeShapeAll,~]=spikeExtraction(sAll,fs,segmentationShow,segmentationT,olr,threshold,Center,Modify);
    cluster_C=spikeSortingCluster(spikeShapeAll,cluster_K,cluster_thr_iter,cluster_thr_replicates);
    
    cluster_C_power=sum(abs(cluster_C),2);
    [~,ind]=sort(cluster_C_power,'ascend');
    cluster_C_temp=cluster_C;
    for r=1:cluster_K
        
        cluster_C(r,:)=cluster_C_temp(ind(r),:);
    end
    
    save(path_spikeCluster,'cluster_C');
    disp([path_spikeCluster ' have been done.']);
end
%%

sRes=[];
timeStamp=[];
spikeShape=[];
timeStampSorting=[];
spikeShapeSorting=[];

path_spike_resultGroup=[path_spike_result 'group_' num2code(rGroup,n_code) '\'];
if ~exist(path_spike_resultGroup,'dir')
    mkdir(path_spike_resultGroup);
end

epochName=D(rEpoch).name(1:end-4);
path_spike_resultEpoch=[path_spike_resultGroup epochName '-ch(' num2code(rChannel,n_code_channel) ').mat'];

if exist(path_spike_resultEpoch,'file')
    disp([path_spike_resultEpoch ' exist, skip.']);
    load(path_spike_resultEpoch);
else
    cluster_C=[];
    load(path_spikeCluster);
    
    [timeStamp,spikeShape,sRes]=spikeExtraction(sSorting,fs,segmentationShow,segmentationT,olr,threshold,Center,Modify);
    [timeStampSorting,spikeShapeSorting]=spikeSortingResult(timeStamp,spikeShape,cluster_K,cluster_C);
    
    save(path_spike_resultEpoch,'sRes','timeStamp','spikeShape','timeStampSorting','spikeShapeSorting');
    disp([path_spike_resultEpoch ' have been done.']);
end
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
    plot(seconds,sSorting-sRes,'Color',[0,1,0],'LineWidth',LineWidth);
    xlim([seconds(1) seconds(end)]);
    ylim(vLim);
    xlabel('time (sec)','Fontweight','bold');
    ylabel('LFP/ \muV','Fontweight','bold');
    legend({'raw LFP';'reconstruction'});
    
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
    
    if plot_show_spike
        if vLim_spike(1,1)==1
            cluster_C_all=[];
            for r=1:nChannel
                
                path_spikeCluster_temp=[path_data 'spikeCluster-ch(' num2code(r,n_code_channel) ').mat'];
                
                cluster_C=[];
                load(path_spikeCluster_temp);
                
                cluster_C_all=[cluster_C_all;cluster_C];
            end
            Min=min(min(cluster_C_all));
            Max=max(max(cluster_C_all));
            
            Range=vLim_spike(1,2)*(Max-Min);
            Min=Min-Range;
            Max=Max+Range;
        elseif vLim_spike(1,1)==2
            Min=min(min(spikeShape));
            Max=max(max(spikeShape));
        end
        
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
            
            plot(secondsTemp*1000,spikeTemp,'Color',[0,0,0],'LineWidth',LineWidth);
            hold on;
        end
        plot([secondsTemp(1),secondsTemp(end)]*1000,[0,0],'Color',[0,0,0],'LineWidth',LineWidthOri);
        hold on;
        plot([xBar,xBar]*1000,[Min,Max],'Color',[0,0,0],'LineWidth',LineWidthOri);
        hold on;
        xlim([secondsTemp(1) secondsTemp(end)]*1000);
        ylim([Min Max]);
        xlabel('time (msec)','Fontweight','bold');
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
                
                plot(secondsTemp*1000,spikeTemp,'Color',color_temp(r1,:),'LineWidth',LineWidth);
                hold on;
            end
            plot([secondsTemp(1),secondsTemp(end)]*1000,[0,0],'Color',[0,0,0],'LineWidth',LineWidthOri);
            hold on;
            plot([xBar,xBar]*1000,[Min,Max],'Color',[0,0,0],'LineWidth',LineWidthOri);
            hold on;
            xlim([secondsTemp(1) secondsTemp(end)]*1000);
            ylim([Min Max]);
            xlabel('time (msec)','Fontweight','bold');
            ylabel('spike/ \muV','Fontweight','bold');
            title(Legend{r1,1},'Fontweight','bold');
        end
    end
    
    pause(timePause);
end

rmpath(genpath(path_toolbox{1,1}));
rmpath(genpath(path_toolbox{2,1}));
toc