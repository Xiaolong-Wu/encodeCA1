function [timeStampSorting,spikeShapeSorting]=spikeSortingResult(timeStamp,spikeShape,cluster_K,cluster_C)

n_t=size(timeStamp,1);
n_spike=size(spikeShape,1);
timeStampSorting=zeros(n_t,cluster_K);
spikeShapeSorting=cell(1,cluster_K);

[cluster_IDX,~]=knnsearch(cluster_C,spikeShape,'K',cluster_K,'Distance','euclidean');

indTime=find(timeStamp==1);
for r=1:n_spike
    
    timeStampSorting(indTime(r),cluster_IDX(r))=1;
    spikeShapeSorting{1,cluster_IDX(r)}=[spikeShapeSorting{1,cluster_IDX(r)};spikeShape(r,:)];
end
end