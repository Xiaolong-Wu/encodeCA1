tic
close all;clear all;clc;
%%

% rGroup, rEpoch
nEpoch={
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
    11,31
    };

for rGroup=1:11 % 1:11
    for rEpoch=1:nEpoch{rGroup,2}
        for rChannel=1:31 % 1:31
            
            run_spikeExtraction;
        end
    end
end
toc