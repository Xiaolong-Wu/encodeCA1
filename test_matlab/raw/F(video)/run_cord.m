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

nNode=2;

xNegative=0;
yNegative=1;

pPreM_x=450/1.8;
pPreM_y=400/1.8;

fps=29.97;
mPreSec=[15;15];
smoothSec=0.01;

nT_bad=[
    0;
    0;
    0;
    530;
    580;
    720;
    1050;
    0;
    0;
    0;
    0
    ];
%%

addpath(genpath(path_toolbox));
%%

path_file=[pwd '\project_posture\data\predictions\group_' num2code(r_old_file,n_code) '\' old_file_all{r_old_file,1} '.txt'];

path_data_cord_ori=[pwd '\result(cord_ori)\group_' num2code(r_old_file,n_code) '\'];
path_file_cord_ori=[path_data_cord_ori old_file_all{r_old_file,1} '.mat'];

if ~exist(path_data_cord_ori,'dir')
    mkdir(path_data_cord_ori);
end

if exist(path_file_cord_ori,'file')
    disp([path_file_cord_ori ' exist, skip.']);
else
    cordTxt=load(path_file);
    nP=size(cordTxt,1);
    
    cordMat_ori=cell(nNode,1);
    for r=1:nNode
        
        temp=cordTxt(r:nNode:nP,1:2);
        if xNegative==1
            temp(:,1)=-temp(:,1);
        end
        if yNegative==1
            temp(:,2)=-temp(:,2);
        end
        
        cordMat_ori{r,1}=temp;
    end
    
    save(path_file_cord_ori,'cordMat_ori');
    disp([path_file_cord_ori ' have been done.']);
end
%%

path_data_cord_smooth=[pwd '\result(cord_smooth)\group_' num2code(r_old_file,n_code) '\'];
path_file_cord_smooth=[path_data_cord_smooth old_file_all{r_old_file,1} '.mat'];

if ~exist(path_data_cord_smooth,'dir')
    mkdir(path_data_cord_smooth);
end

if exist(path_file_cord_smooth,'file')
    disp([path_file_cord_smooth ' exist, skip.']);
else
    cordMat_ori=[];
    load(path_file_cord_ori);
    
    nT=size(cordMat_ori{1,1},1);
    
    cordMat_smooth=cordMat_ori;
    if nT_bad(r_old_file,1)>0
        for r1=1:nT_bad(r_old_file,1)
            for r2=1:nNode
                
                cordMat_smooth{r2,1}(r1,1)=nan;
                cordMat_smooth{r2,1}(r1,2)=nan;
            end
        end
    end
    for r1=(nT_bad(r_old_file,1)+2):nT
        
        overLim=0;
        for r2=1:nNode
            
            xDiff=(cordMat_smooth{r2,1}(r1,1)-cordMat_smooth{r2,1}(r1-1,1))/pPreM_x;
            yDiff=(cordMat_smooth{r2,1}(r1,2)-cordMat_smooth{r2,1}(r1-1,2))/pPreM_y;
            pLength=sqrt(xDiff^2+yDiff^2);
            if pLength>mPreSec(r2,1)/fps
                overLim=1;
                break;
            end
        end
        
        if overLim==1
            for r2=1:nNode
                
                cordMat_smooth{r2,1}(r1,:)=cordMat_smooth{r2,1}(r1-1,:);
            end
        end
    end
    
    smoothSpan=ceil(fps*smoothSec);
    if smoothSpan>1
        for r2=1:nNode
            
            for r3=1:2
                cordMat_smooth{r2,1}(:,r3)=smooth(cordMat_smooth{r2,1}(:,r3),smoothSpan,'moving');
            end
        end
    end
    
    save(path_file_cord_smooth,'cordMat_smooth');
    disp([path_file_cord_smooth ' have been done.']);
end
%%

rmpath(genpath(path_toolbox));
toc