function cluster_C=spikeSortingCluster(spikeShapeAll,cluster_K,cluster_thr_iter,cluster_thr_replicates)

opts=statset('Display','final','MaxIter',cluster_thr_iter);
[~,cluster_C]=kmeans(spikeShapeAll,cluster_K,'Distance','sqeuclidean','Replicates',cluster_thr_replicates,'Options',opts);
end