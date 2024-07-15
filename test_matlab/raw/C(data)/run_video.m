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

n_code=5;
%%

addpath(genpath(path_toolbox));
%%

path_data=[pwd '\' old_file_all{r_old_file,1} '\' old_file_all{r_old_file,1} '.mpg\crcns\hc2\' old_file_all{r_old_file,1} '\'];
path_data_new=[pwd '\result(video)\group_' num2code(r_old_file,n_code) '\'];

if ~exist(path_data_new,'dir')
    mkdir(path_data_new);
end

D=dir([path_data '*.mpg']);
for r=1:length(D)
    
    old_file=D(r).name;
    
    path_data_temp=[path_data old_file];
    path_data_new_temp=[path_data_new old_file];
    
    if exist(path_data_new_temp,'file')
        disp([path_data_new_temp ' exist, skip.']);
    else
        copyfile(path_data_temp,path_data_new_temp);
        disp([path_data_new_temp ' have been done.']);
    end
end
%%

rmpath(genpath(path_toolbox));
toc