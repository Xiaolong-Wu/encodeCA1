tic
close all;clear all;clc;
%%

path_data=[pwd '\'];
path_toolbox='D:\test_matlab\toolbox\eegGA\';
%%

nGroup=11;
nEpoch={
    01,18,'ec013.527';
    02,27,'ec013.528';
    03,31,'ec013.529';
    04,38,'ec013.713';
    05,38,'ec013.714';
    06,54,'ec013.754';
    07,33,'ec013.755';
    08,41,'ec013.756';
    09,41,'ec013.757';
    10,37,'ec013.808';
    11,31,'ec013.844'
    };

fs=20000;
nChannel=31;
tSegment=60;

cluster_K=7;

n_code=5;
n_code_channel=2;
%%

addpath(genpath(path_toolbox));
%%

for r1=1:nGroup
    
    path_spike_Group=[path_data 'D_result(spike)\group_' num2code(r1,n_code) '\'];
    path_spike_GroupFeature=[path_data 'result(spike)\group_' num2code(r1,n_code) '\'];
    
    if ~exist(path_spike_GroupFeature,'file')
        mkdir(path_spike_GroupFeature);
    end
    
    for r2=1:nEpoch{r1,2}
        
        fileName=[nEpoch{r1,3} '(' num2code(tSegment,n_code) 's)(' num2code(fs,n_code) 'Hz)(epoch-' num2code(r2,n_code) ').mat'];
        path_spike_GroupFeature_temp=[path_spike_GroupFeature fileName];
        
        if exist(path_spike_GroupFeature_temp,'file')
            disp([path_spike_GroupFeature_temp ' exist, skip.']);
        else
            nT=tSegment*fs;
            code_timeStamp=zeros(cluster_K*nChannel,nT);
            for r3=1:nChannel
                
                fileName_Channel=[nEpoch{r1,3} '(' num2code(tSegment,n_code) 's)(' num2code(fs,n_code) 'Hz)(epoch-' num2code(r2,n_code) ')-ch(' num2code(r3,n_code_channel) ').mat'];
                path_spike_Group_temp=[path_spike_Group fileName_Channel];
                
                sRes=[];
                timeStamp=[];
                spikeShape=[];
                timeStampSorting=[];
                spikeShapeSorting=[];
                load(path_spike_Group_temp);
                
                timeStampSorting=timeStampSorting';
                if r2==nEpoch{r1,2} && r3==1
                    temp_nT=size(timeStampSorting,2);
                    if temp_nT<nT
                        code_timeStamp(:,temp_nT+1:nT)=[];
                    end
                end
                
                first=(r3-1)*cluster_K+1;
                last=r3*cluster_K;
                code_timeStamp(first:last,:)=timeStampSorting;
            end
            save(path_spike_GroupFeature_temp,'code_timeStamp');
            disp([path_spike_GroupFeature_temp ' have been done.']);
        end
    end
end
%%

rmpath(genpath(path_toolbox));
toc