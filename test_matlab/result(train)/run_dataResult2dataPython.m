tic
close all;clear all;clc;
%%

% unit, m-second
tCord=100;
tCordStep=tCord;

% [-1000,0000];
% [-2000,1000];
% [-4000,3000];
tCordBehind=[-1000,0000];

fsTrain=10;
%%

testRate=-0.2;
nGroup=11;
%%

n_code=5;
dataType={'behavior';'spike';'mm'};
dataResult=['tB(' num2str(tCordBehind(1,1)) ',' num2str(tCordBehind(1,2)) ')tP(' num2str(tCord) ')tStep(' num2str(tCordStep) ')nSeq(' num2str(fsTrain) ')'];
dataResult_python=[dataResult 'rate(' num2str(testRate) ')'];
%%

path_temp=[pwd '\'];
path_python='D:\test_pycharm\project_CA1\data_2022\';
path_pythonResult='D:\test_pycharm\project_CA1\data_2022\saved_models\results\';

path_toolbox='D:\test_matlab\toolbox\eegGA\';
addpath(genpath(path_toolbox));
%%

path_data=[path_temp dataResult '\'];

path_data_python1=[path_python 'data_train\'];
path_data_python2=[path_python 'data_test\'];

path_data_pythonTrain=[path_data_python1 dataResult_python '\'];
path_data_pythonTest=[path_data_python2 dataResult_python '\'];

if ~exist(path_data_pythonTrain,'dir')
    mkdir(path_data_pythonTrain);
end
if ~exist(path_data_pythonTest,'dir')
    mkdir(path_data_pythonTest);
end

path_timeStamp=[path_data 'timeStamp.mat'];

timeStamp=[];
load(path_timeStamp);
nTrain=size(timeStamp,2);

rTrain=[];
rTest=[];

r0=1;
for r=1:nTrain
    
    if testRate>0
        if r*abs(testRate)>=r0
            rTest=[rTest,r];
            r0=r0+1;
        else
            rTrain=[rTrain,r];
        end
    elseif testRate<0
        if r*abs(testRate)>=r0
            rTest=[rTest,r];
            r0=r0+1;
        end
        rTrain=[rTrain,r];
    end
end

n_rTrain=length(rTrain);
n_rTest=length(rTest);

path_data_pythonTrain_timeStamp=[path_data_pythonTrain 'timeStamp.mat'];
path_data_pythonTest_timeStamp=[path_data_pythonTest 'timeStamp.mat'];

timeStamp_temp=timeStamp;
if exist(path_data_pythonTrain_timeStamp,'file')
    disp([path_data_pythonTrain_timeStamp ' exist, skip.']);
else
    timeStamp=timeStamp_temp(1,rTrain);
    save(path_data_pythonTrain_timeStamp,'timeStamp');
    disp([path_data_pythonTrain_timeStamp ' have been done.']);
end
if exist(path_data_pythonTest_timeStamp,'file')
    disp([path_data_pythonTest_timeStamp ' exist, skip.']);
else
    timeStamp=timeStamp_temp(1,rTest);
    save(path_data_pythonTest_timeStamp,'timeStamp');
    disp([path_data_pythonTest_timeStamp ' have been done.']);
end
%%

nDataType=size(dataType,1);
for r1=1:nGroup
    
    path_data_group=[path_data 'group_' num2code(r1,n_code) '\'];
    
    path_data_pythonTrain_group=[path_data_pythonTrain 'group_' num2code(r1,n_code) '\'];
    path_data_pythonTest_group=[path_data_pythonTest 'group_' num2code(r1,n_code) '\'];
    
    if ~exist(path_data_pythonTrain_group,'dir')
        mkdir(path_data_pythonTrain_group);
    end
    if ~exist(path_data_pythonTest_group,'dir')
        mkdir(path_data_pythonTest_group);
    end
    
    D=dir([path_data_group '*.mat']);
    nEpoch=length(D)/nDataType;
    for r2=2:nEpoch+1
        for r3=1:nDataType
            
            path_data_group_temp=[path_data_group dataType{r3,1} '_' num2code(r2,n_code) '.mat'];
            
            path_data_pythonTrain_group_temp=[path_data_pythonTrain_group dataType{r3,1} '_' num2code(r2,n_code) '.mat'];
            path_data_pythonTest_group_temp=[path_data_pythonTest_group dataType{r3,1} '_' num2code(r2,n_code) '.mat'];
            
            if exist(path_data_pythonTrain_group_temp,'file')
                disp([path_data_pythonTrain_group_temp ' exist, skip.']);
            else
                if r3==1
                    of_target=[];
                    load(path_data_group_temp);
                    
                    of_target_temp=of_target;
                    of_target=of_target_temp(rTrain,:);
                    save(path_data_pythonTrain_group_temp,'of_target');
                else
                    of_data=[];
                    load(path_data_group_temp);
                    of_data_temp=of_data;
                    
                    of_data=cell(n_rTrain,1);
                    for r4=1:n_rTrain
                        of_data{r4,1}=of_data_temp{rTrain(r4),1};
                    end
                    save(path_data_pythonTrain_group_temp,'of_data');
                end
                disp([path_data_pythonTrain_group_temp ' have been done.']);
            end
            
            if exist(path_data_pythonTest_group_temp,'file')
                disp([path_data_pythonTest_group_temp ' exist, skip.']);
            else
                if r3==1
                    of_target=[];
                    load(path_data_group_temp);
                    
                    of_target_temp=of_target;
                    of_target=of_target_temp(rTest,:);
                    save(path_data_pythonTest_group_temp,'of_target');
                else
                    of_data=[];
                    load(path_data_group_temp);
                    of_data_temp=of_data;
                    
                    of_data=cell(n_rTest,1);
                    for r4=1:n_rTest
                        of_data{r4,1}=of_data_temp{rTest(r4),1};
                    end
                    save(path_data_pythonTest_group_temp,'of_data');
                end
                disp([path_data_pythonTest_group_temp ' have been done.']);
            end
        end
    end
end
%%

rmpath(genpath(path_toolbox));
toc