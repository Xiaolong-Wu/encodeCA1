tic
% close all;clear all;clc;
%%

% 1:11
rGroup=11;
%%

% sec
rT={0;1:100};

% 1, posture
% 2, trail
plotMeth=2;

plotSmooth=1;
%%

openField=1.8;
pPreM_x=450/openField;
pPreM_y=400/openField;

nNode=2;
fps=29.97;
colorMap='jet';
oNode=2;

% []: no shift;
% 0: shift oNode to zero;
% positive: shift oNode to zero and a line with cordShift m/ sec;
% negtive: shift oNode to a line with cordShift m/ sec;
cordShift=[];

plotPreSec=30;

connNode={
    [1,2]
    };
colorNode=[
    0.5,0.5,0.5;
    1,1,1
    ];
lineWidth=2;
markerSize=5;

xRange=[1,720]/pPreM_x;
yRange=[-480,-1]/pPreM_y;

plotPause=0.0000;
%%

showQuick=1;
%%

n_code=5;

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
%%

addpath(genpath(path_toolbox));
%%

if plotSmooth==0
    path_data_cord=[pwd '\result(cord_ori)\group_' num2code(rGroup,n_code) '\'];
elseif plotSmooth==1
    path_data_cord=[pwd '\result(cord_smooth)\group_' num2code(rGroup,n_code) '\'];
end

path_file_cord=[path_data_cord old_file_all{rGroup,1} '.mat'];

cordMat_ori=[];
cordMat_smooth=[];
load(path_file_cord);
if plotSmooth==0
    cordMat=cordMat_ori;
elseif plotSmooth==1
    cordMat=cordMat_smooth;
end

if rT{1,1}==1
    for r=1:nNode
        
        cordMat{r,1}=cordMat{r,1}(floor(rT{2,1}(1)*fps):floor(rT{2,1}(2)*fps),:);
    end
end

if plotMeth==1
    cordShow_posture(pPreM_x,pPreM_y,fps,cordMat,nNode,oNode,cordShift,plotPreSec,connNode,colorNode,lineWidth,markerSize,xRange,yRange,plotPause,colorMap);
elseif plotMeth==2
    cordShow_trail(pPreM_x,pPreM_y,fps,cordMat,oNode,plotPreSec,lineWidth,markerSize,xRange,yRange,plotPause,colorMap,showQuick);
end
%%

rmpath(genpath(path_toolbox));
toc