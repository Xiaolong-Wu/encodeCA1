function [timeStamp,spikeShape,sRes]=spikeExtraction(S,fs,segmentationShow,segmentationT,olr,threshold,Center,Modify)

% segmentationT: unit, millisecond
% threshold: [downThr,upThr], unit, ¦ÌV
% Center: 'down', 'up', 'mid'
%%

N=size(S,1);
segmentationShowN=floor(segmentationShow*fs/1000);
segmentationN=floor(segmentationT*fs/1000);
segmentationNquarter=floor(segmentationN/4);
segmentationNolrNega=floor(segmentationN*(1-olr));

timeStamp=zeros(N,1);
last=(segmentationN+segmentationNolrNega);
EdgeOld=[0,0];
while last<=N-(segmentationN+segmentationNolrNega)
    
    first=last+1;
    last=first+segmentationNolrNega-1;
    switch Center
        case 'down'
            [val,indTemp]=min(S(first:last));
            
            NoPass=1;
            Edge=double([indTemp==1,indTemp==(segmentationNolrNega)]);
            if sum(Edge)>0
                NoPass=0;
                if Edge(1,1)==1 && EdgeOld(1,2)==1
                    NoPass=1;
                end
            end
            EdgeOld=Edge;
            
            if val<=threshold(1,1) && NoPass
                ind=first+indTemp-1;
                timeStamp(ind,1)=1;
            end
        case 'up'
            [val,indTemp]=max(S(first:last));
            
            NoPass=1;
            Edge=double([indTemp==1,indTemp==(segmentationNolrNega)]);
            if sum(Edge)>0
                NoPass=0;
                if Edge(1,1)==1 && EdgeOld(1,2)==1
                    NoPass=1;
                end
            end
            EdgeOld=Edge;
            
            if val>=threshold(1,2) && NoPass
                ind=first+indTemp-1;
                timeStamp(ind,1)=1;
            end
        case 'mid'
            r0=0;
            for r=first:last
                [valMin,indTempMin]=min(S(r-segmentationNquarter:r));
                [valMax,indTempMax]=max(S(r:r+segmentationNquarter-1));
                
                Edge=(indTempMin==1 || indTempMin==(segmentationNquarter+1) || indTempMax==1 || indTempMax==segmentationNquarter);
                if valMin>threshold(1,1) || valMax<threshold(1,2) || Edge
                    continue;
                end
                
                r0=r0+1;
                rAll(r0,1)=r-segmentationNquarter+indTempMin-1;
                rAll(r0,2)=r+indTempMax-1;
                valDiff(r0,1)=valMax-valMin;
            end
            
            if r0>1
                [~,indTemp]=max(valDiff);
                ind=floor(mean(rAll(indTemp,:)));
                
                timeStamp(ind,1)=1;
            end
    end
end

nSpike=sum(timeStamp);
spikeShape=zeros(nSpike,segmentationShowN);
sRes=S;

r0=0;
for r1=1:N
    
    if timeStamp(r1,1)==1
        r0=r0+1;
        
        rModify=r1;
        if Modify==1
            for r2=1:segmentationNquarter
                
                if S(r1)*S(r1-r2)<=0
                    comTemp=[S(r1),S(r1-r2)];
                    [~,indTemp]=min(abs(comTemp));
                    if indTemp==1
                        rModify=r1;
                    else
                        rModify=r1-2;
                    end
                    break;
                elseif S(r1)*S(r1+r2)<=0
                    comTemp=[S(r1),S(r1+r2)];
                    [~,indTemp]=min(abs(comTemp));
                    if indTemp==1
                        rModify=r1;
                    else
                        rModify=r1+2;
                    end
                    break;
                end
            end
        end
        
        segmentationDiffN=segmentationShowN-segmentationN;
        switch Center
            case 'down'
                first=rModify-segmentationNquarter;
                segmentationDiffN_1=floor(segmentationDiffN/4);
            case 'up'
                first=rModify-3*segmentationNquarter;
                segmentationDiffN_1=floor(3*segmentationDiffN/4);
            case 'mid'
                first=rModify-2*segmentationNquarter;
                segmentationDiffN_1=floor(2*segmentationDiffN/4);
        end
        segmentationDiffN_2=segmentationDiffN-segmentationDiffN_1;
        
        last=first+segmentationN-1;
        spikeShapeTemp=[zeros(segmentationDiffN_1,1);S(first:last);zeros(segmentationDiffN_2,1)];
        spikeShape(r0,:)=spikeShapeTemp;
        
        sTemp=zeros(N,1);
        sTemp(first:last)=S(first:last);
        sRes=sRes-sTemp;
    end
end
end