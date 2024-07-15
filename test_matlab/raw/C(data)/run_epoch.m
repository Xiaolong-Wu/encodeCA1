tic
% close all;clear all;clc;
%%

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
path_toolbox='D:\test_matlab\toolbox\eegGA\function\';

% r_old_file=1;
old_fs=20000;

new_fs=old_fs;

nChannel=31;
% tSegment=60; % 60 300
n_code=5;
%%

addpath(genpath(path_toolbox));
%%

temp_nT=tSegment*old_fs;
fsRe=old_fs/new_fs;

nT=floor(temp_nT/fsRe);

path_data=[pwd '\' old_file_all{r_old_file,1} '\' old_file_all{r_old_file,1} '.dat\crcns\hc2\' old_file_all{r_old_file,1} '\'];
if tSegment==60
    path_data_new=[pwd '\result(epoch)\group_' num2code(r_old_file,n_code) '\'];
elseif tSegment==300
    r_old_file=1;
    path_data_new=[pwd '\result(epoch)\'];
end

if ~exist(path_data_new,'dir')
    mkdir(path_data_new);
end

D=dir([path_data '*.dat']);
for r1=1:length(D)
    
    old_file=D(r1).name(1:end-4);
    old_data=fopen([path_data old_file '.dat'],'r');
    
    frewind(old_data);
    rSegment=0;
    while ~feof(old_data)
        
        temp_data=fread(old_data,[nChannel,temp_nT],'int16');
        
        rSegment=rSegment+1;
        new_file=[path_data_new old_file '(' num2code(tSegment,n_code) 's)(' num2code(new_fs,n_code) 'Hz)(epoch-' num2code(rSegment,n_code) ').mat'];
        
        if exist(new_file,'file')
            disp([new_file ' exist, skip.']);
        else
            rPoint=0;
            new_data=zeros(nChannel,nT);
            temp_temp_nT=size(temp_data,2);
            for r2=1:temp_temp_nT
                
                if floor(r2/fsRe)>rPoint
                    rPoint=rPoint+1;
                    new_data(:,rPoint)=temp_data(:,r2);
                end
            end
            
            if temp_temp_nT<temp_nT && rPoint<nT
                new_data(:,rPoint+1:end)=[];
            end
            
            save(new_file,'new_data');
            disp([new_file ' have been done.']);
        end
    end
    
    fclose(old_data);
end
%%

rmpath(genpath(path_toolbox));
toc