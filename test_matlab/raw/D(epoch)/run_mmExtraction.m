tic
close all; % clear all;clc;
%%

path_data=[pwd '\'];
path_toolbox='D:\test_matlab\toolbox\eegGA\';

path_mm_result=[path_data 'result(mm)\'];
%%

% rGroup=1; % 1:11
% rEpoch=1;
%%

fs=20000;
fs_filter=[800,5000];

% ms
mm_scale={
    [0,1.25];
    [0,0.50];
    [0,0.75];
    };
segmentationT=1;
olr=0.75;

n_code=5;
n_code_channel=2;
%%

addpath(genpath(path_toolbox));
%%

path_sSorting_group=[path_data 'group_' num2code(rGroup,n_code) '\'];
D=dir([path_sSorting_group '*.mat']);

path_mm_resultGroup=[path_mm_result 'group_' num2code(rGroup,n_code) '\'];
if ~exist(path_mm_resultGroup,'dir')
    mkdir(path_mm_resultGroup);
end

path_mm_resultEpoch=[path_mm_resultGroup D(rEpoch).name];
if exist(path_mm_resultEpoch,'file')
    disp([path_mm_resultEpoch ' exist, skip.']);
else
    path_sSorting=[path_sSorting_group D(rEpoch).name];
    
    new_data=[];
    load(path_sSorting);
    
    disp(' ');
    disp(['load (' num2str(rEpoch) '/' num2str(length(D)) '):']);
    disp(path_sSorting);
    
    wbar=waitbar(0,sprintf('mm processing ...\n0\0'));
    set(findall(wbar,'type','text'),'Interpreter','none');
    
    [nChannel,nT]=size(new_data);
    n_window=floor(segmentationT*fs/1000);
    n_step=ceil(n_window*(1-olr));
    n_scale=size(mm_scale,1);
    
    first_all=1:n_step:nT;
    n_first=length(first_all)-1;
    for r=1:length(first_all)-1
        
        if first_all(n_first)+n_window-1>nT
            n_first=n_first-1;
        else
            break;
        end
    end
    
    code_mm=zeros(2*n_scale*nChannel,n_first);
    for r1=1:nChannel
        
        first_1=2*n_scale*(r1-1)+1;
        last_1=2*n_scale*r1;
        
        [~,eegPS]=wave_PS(new_data(r1,:),fs,fs_filter,[0,0],'flat');
        temp_data=eegPS{1,1}(1,:);
        
        for r2=1:n_first
            
            first_2=first_all(r2);
            last_2=first_2+n_window-1;
            
            PS_all=zeros(2*n_scale,1);
            for r3=1:n_scale
                
                first_3=2*(r3-1)+1;
                last_3=2*r3;
                
                [PS,~]=wave_PS(temp_data(1,first_2:last_2),fs,[0,inf],mm_scale{r3,1}/1000,'flat');
                PS_all(first_3:last_3,1)=PS;
            end
            
            code_mm(first_1:last_1,r2)=PS_all;
            waitbar(r2/n_first,wbar,sprintf('mm processing %s\n%s',['ch. ' num2code(r1,n_code_channel) '/' num2code(nChannel,n_code_channel)],[num2code(r2,2*n_code) '/' num2code(n_first,2*n_code)]));
        end
    end
    delete(wbar);
    
    save(path_mm_resultEpoch,'code_mm');
    disp([path_mm_resultEpoch ' have been done.']);
end
%%

rmpath(genpath(path_toolbox));
toc