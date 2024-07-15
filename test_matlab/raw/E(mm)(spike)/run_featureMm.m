run_featureSipke;
%%

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
tSegment=60;

meth_interp='spline';

n_code=5;
%%

addpath(genpath(path_toolbox));
%%

for r1=1:nGroup
    
    path_mm_Group=[path_data 'D_result(mm)\group_' num2code(r1,n_code) '\'];
    path_spike_GroupFeature=[path_data 'result(spike)\group_' num2code(r1,n_code) '\'];
    path_mm_GroupFeature=[path_data 'result(mm)\group_' num2code(r1,n_code) '\'];
    
    if ~exist(path_mm_GroupFeature,'file')
        mkdir(path_mm_GroupFeature);
    end
    
    for r2=1:nEpoch{r1,2}
        
        fileName=[nEpoch{r1,3} '(' num2code(tSegment,n_code) 's)(' num2code(fs,n_code) 'Hz)(epoch-' num2code(r2,n_code) ').mat'];
        path_mm_GroupFeature_temp=[path_mm_GroupFeature fileName];
        
        if exist(path_mm_GroupFeature_temp,'file')
            disp([path_mm_GroupFeature_temp ' exist, skip.']);
        else
            path_mm_Group_temp=[path_mm_Group fileName];
            
            code_mm=[];
            load(path_mm_Group_temp);
            
            path_spike_GroupFeature_temp=[path_spike_GroupFeature fileName];
            
            code_timeStamp=[];
            load(path_spike_GroupFeature_temp);
            
            [nFeature,nT_old]=size(code_mm);
            nT_new=size(code_timeStamp,2);
            code_mm_new=zeros(nFeature,nT_new);
            
            interval=floor(nT_new/(nT_old-1));
            
            t_old=1:interval:nT_new;
            t_new=1:nT_new;
            for r3=1:nFeature
                
                code_mm_new(r3,:)=interp1(t_old(1:nT_old),code_mm(r3,:),t_new,meth_interp,mean(code_mm(r3,:)));
            end
            
            code_mm=code_mm_new;
            save(path_mm_GroupFeature_temp,'code_mm');
            disp([path_mm_GroupFeature_temp ' have been done.']);
        end
    end
end
%%

rmpath(genpath(path_toolbox));
toc