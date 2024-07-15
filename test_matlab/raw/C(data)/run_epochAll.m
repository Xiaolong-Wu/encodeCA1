tic
close all;clear all;clc;
%%

for r_old_file=1:11
    
    if r_old_file==1
        tSegment=300;
        run_epoch;
    end
    
    tSegment=60;
    run_epoch;
end
toc