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

% second
tSegment=60;

all_epoch=[
    01,18;
    02,27;
    03,31;
    04,38;
    05,38;
    06,54;
    07,33;
    08,41;
    09,41;
    10,37;
    11,31;
    ];

n_code=5;

path_data=[pwd '\'];
path_data_train=[path_data 'result(train)\'];
%%

openField=1.8;
pPreM_x=450/openField;
pPreM_y=400/openField;

fps=29.97;
oNode=2;
pNode=1;

xRange=[1,720]/pPreM_x;
yRange=[-480,-1]/pPreM_y;

path_cord=[path_data 'result(cord_smooth)\'];
%%

fs=20000;
path_spike=[path_data 'result(spike)\'];
%%

path_mm=[path_data 'result(mm)\'];
%%

path_toolbox='D:\test_matlab\toolbox\eegGA\';
addpath(genpath(path_toolbox));
%%

if ~exist(path_data_train,'dir')
    mkdir(path_data_train);
end

path_data_train_temp=[path_data_train 'tB(' num2str(tCordBehind(1,1)) ',' num2str(tCordBehind(1,2)) ')tP(' num2str(tCord) ')tStep(' num2str(tCordStep) ')nSeq(' num2str(fsTrain) ')\'];
if ~exist(path_data_train_temp,'dir')
    mkdir(path_data_train_temp);
end

path_data_train_timeStamp=[path_data_train_temp 'timeStamp.mat'];
if exist(path_data_train_timeStamp,'file')
    disp([path_data_train_timeStamp ' exist, skip.']);
else
    tStart=max([0,(0-tCordBehind(1,1)/1000)]);
    tEnd=min([tSegment,(tSegment-tCordBehind(1,2)/1000)]);
    tInterval=tCordStep/1000;
    
    timeStamp=tStart:tInterval:tEnd;
    save(path_data_train_timeStamp,'timeStamp');
    disp([path_data_train_timeStamp ' have been done.']);
end

timeStamp=[];
load(path_data_train_timeStamp);

cordCenter=[mean(xRange),mean(yRange)];

nGroup=size(all_epoch,1);
nTrain=size(timeStamp,2);

nSeq=floor(fsTrain*diff(tCordBehind)/1000);
nData=floor(fs*diff(tCordBehind)/1000/nSeq)-1;
for r1=1:nGroup
    
    path_data_train_group=[path_data_train_temp 'group_' num2code(r1,n_code) '\'];
    if ~exist(path_data_train_group,'dir')
        mkdir(path_data_train_group);
    end
    
    nEpoch=all_epoch(r1,2);
    for r2=2:nEpoch-1
        
        path_data_train_group_temp1=[path_data_train_group 'behavior_' num2code(r2,n_code) '.mat'];
        path_data_train_group_temp2=[path_data_train_group 'spike_' num2code(r2,n_code) '.mat'];
        path_data_train_group_temp3=[path_data_train_group 'mm_' num2code(r2,n_code) '.mat'];
        %%
        
        if exist(path_data_train_group_temp1,'file')
            disp([path_data_train_group_temp1 ' exist, skip.']);
        else
            % 01:02, cord_location1
            % 03:04, cord_posture1
            % 05:07, cord_direction1
            
            % 08, cord_quadrant
            
            % 09:10, cord_location2
            % 11:12, cord_posture2
            % 13:15, cord_direction2
            
            % 16:17, cord_egocentric
            of_target=zeros(nTrain,7+1+7+2);
            
            path_cord_group=[path_cord 'group_' num2code(r1,n_code) '\'];
            D1=dir([path_cord_group '*.mat']);
            path_cord_group_temp=[path_cord_group D1.name];
            
            cordMat_smooth=[];
            load(path_cord_group_temp);
            
            timeStamp_temp=(r2-1)*tSegment+timeStamp;
            timeStamp_cord1=ceil(timeStamp_temp*fps);
            timeStamp_cord2=ceil((timeStamp_temp+tCord/1000)*fps);
            
            for r3=1:nTrain
                
                cord_0=cordMat_smooth{oNode,1}(timeStamp_cord1(1,r3),:);
                cord_P=cordMat_smooth{pNode,1}(timeStamp_cord1(1,r3),:);
                cord_F=cordMat_smooth{oNode,1}(timeStamp_cord2(1,r3),:);
                
                xO=cord_0(1,1)/pPreM_x-cordCenter(1,1);
                yO=cord_0(1,2)/pPreM_y-cordCenter(1,2);
                xP=cord_P(1,1)/pPreM_x-cordCenter(1,1);
                yP=cord_P(1,2)/pPreM_y-cordCenter(1,2);
                xF=cord_F(1,1)/pPreM_x-cordCenter(1,1);
                yF=cord_F(1,2)/pPreM_y-cordCenter(1,2);
                
                cord_location1=[xO,yO]/(openField/2);
                
                cordVector1=[xP-xO,yP-yO];
                cordVector_mod1=(cordVector1*cordVector1')^(1/2);
                cord_posture1=cordVector1/cordVector_mod1;
                
                cordDirection1=[xF-xO,yF-yO];
                cordDirection_mod1=(cordDirection1*cordDirection1')^(1/2);
                if cordDirection_mod1==0
                    cord_direction1=[0,0,0];
                else
                    cord_direction1=[cordDirection1/cordDirection_mod1,cordDirection_mod1/(tCord/1000)];
                end
                cord_egocentric1=egocentricCoor([xF,yF],[xO,yO],[xP,yP]);
                
                if yO<=-xO && yO>xO % left isosceles right triangle of open field
                    cord_quadrant=4;
                    
                    xO_new=-yO;
                    yO_new=xO+(openField/2);
                    
                    xP_new=-yP;
                    yP_new=xP+(openField/2);
                    
                    xF_new=-yF;
                    yF_new=xF+(openField/2);
                elseif yO>=-xO && yO>xO % up isosceles right triangle of open field
                    cord_quadrant=3;
                    
                    xO_new=-xO;
                    yO_new=-yO+(openField/2);
                    
                    xP_new=-xP;
                    yP_new=-yP+(openField/2);
                    
                    xF_new=-xF;
                    yF_new=-yF+(openField/2);
                elseif yO>=-xO && yO<xO % right isosceles right triangle of open field
                    cord_quadrant=2;
                    
                    xO_new=yO;
                    yO_new=-xO+(openField/2);
                    
                    xP_new=yP;
                    yP_new=-xP+(openField/2);
                    
                    xF_new=yF;
                    yF_new=-xF+(openField/2);
                elseif yO<=-xO && yO<xO % down isosceles right triangle of open field
                    cord_quadrant=1;
                    
                    xO_new=xO;
                    yO_new=yO+(openField/2);
                    
                    xP_new=xP;
                    yP_new=yP+(openField/2);
                    
                    xF_new=xF;
                    yF_new=yF+(openField/2);
                end
                
                cord_location2=[xO_new,yO_new]/(openField/2);
                
                cordVector2=[xP_new-xO_new,yP_new-yO_new];
                cordVector_mod2=(cordVector2*cordVector2')^(1/2);
                cord_posture2=cordVector2/cordVector_mod2;
                
                cordDirection2=[xF_new-xO_new,yF_new-yO_new];
                cordDirection_mod2=(cordDirection2*cordDirection2')^(1/2);
                if cordDirection_mod2==0
                    cord_direction2=[0,0,0];
                else
                    cord_direction2=[cordDirection2/cordDirection_mod2,cordDirection_mod2/(tCord/1000)];
                end
                cord_egocentric2=egocentricCoor([xF_new,yF_new],[xO_new,yO_new],[xP_new,yP_new]);
                
                if sum(abs(cord_egocentric1-cord_egocentric2))==0
                    cord_egocentric=cord_egocentric1;
                end
                of_target(r3,:)=[cord_location1,cord_posture1,cord_direction1,cord_quadrant,cord_location2,cord_posture2,cord_direction2,cord_egocentric];
            end
            
            save(path_data_train_group_temp1,'of_target');
            disp([path_data_train_group_temp1 ' have been done.']);
        end
        %%
        
        if exist(path_data_train_group_temp2,'file')
            disp([path_data_train_group_temp2 ' exist, skip.']);
        else
            of_data=cell(nTrain,1);
            
            path_spike_group=[path_spike 'group_' num2code(r1,n_code) '\'];
            D2=dir([path_spike_group '*.mat']);
            path_spike_group_temp=[path_spike_group D2(r2).name];
            
            code_timeStamp=[];
            load(path_spike_group_temp);
            
            timeStamp_n1=ceil((timeStamp+tCordBehind(1,1)/1000)*fs+1);
            timeStamp_n2=ceil((timeStamp+tCordBehind(1,2)/1000)*fs);
            
            for r3=1:nTrain
                
                of_data_temp=code_timeStamp(:,timeStamp_n1(1,r3):timeStamp_n2(1,r3))';
                timeStamp_n=timeStamp_n2(1,r3)-timeStamp_n1(1,r3)+1;
                for r4=1:nSeq
                    
                    r4_inv=nSeq-r4+1;
                    first=timeStamp_n-r4*nData+1;
                    last=timeStamp_n-(r4-1)*nData;
                    of_data{r3,1}(r4_inv,:)=sum(of_data_temp(first:last,:));
                end
            end
            
            save(path_data_train_group_temp2,'of_data');
            disp([path_data_train_group_temp2 ' have been done.']);
        end
        %%
        
        if exist(path_data_train_group_temp3,'file')
            disp([path_data_train_group_temp3 ' exist, skip.']);
        else
            of_data=cell(nTrain,1);
            
            path_mm_group=[path_mm 'group_' num2code(r1,n_code) '\'];
            D2=dir([path_mm_group '*.mat']);
            path_mm_group_temp=[path_mm_group D2(r2).name];
            
            code_mm=[];
            load(path_mm_group_temp);
            
            timeStamp_n1=ceil((timeStamp+tCordBehind(1,1)/1000)*fs+1);
            timeStamp_n2=ceil((timeStamp+tCordBehind(1,2)/1000)*fs);
            timeStamp_n=timeStamp_n2-timeStamp_n1+1;
            
            for r3=1:nTrain
                
                of_data_temp=code_mm(:,timeStamp_n1(1,r3):timeStamp_n2(1,r3))';
                timeStamp_n=timeStamp_n2(1,r3)-timeStamp_n1(1,r3)+1;
                for r4=1:nSeq
                    
                    r4_inv=nSeq-r4+1;
                    first=timeStamp_n-r4*nData+1;
                    last=timeStamp_n-(r4-1)*nData;
                    of_data{r3,1}(r4_inv,:)=mean(of_data_temp(first:last,:),1);
                end
            end
            
            save(path_data_train_group_temp3,'of_data');
            disp([path_data_train_group_temp3 ' have been done.']);
        end
    end
end
%%

rmpath(genpath(path_toolbox));
toc
