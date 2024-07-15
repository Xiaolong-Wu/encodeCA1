function cordShow_trail(pPreM_x,pPreM_y,fps,cordMat,oNode,plotPreSec,lineWidth,markerSize,xRange,yRange,plotPause,colorMap,showQuick)

nT=size(cordMat{1,1},1);
cordPlot=cordMat{oNode,1};

figure

if showQuick==1
    x=cordPlot(:,1);
    y=cordPlot(:,2);
    plot(x/pPreM_x,y/pPreM_y,'LineWidth',lineWidth,'color','k');
    
    axis equal;
    if ~isempty(xRange)
        xlim(xRange);
    end
    if ~isempty(yRange)
        ylim(yRange);
    end
else
    eval(['colormap_temp=colormap(' colorMap '(nT));']);
    plotInterval=ceil(fps/plotPreSec);
    for r2=1:plotInterval:nT
        
        x=cordPlot(r2,1);
        y=cordPlot(r2,2);
        plot(x/pPreM_x,y/pPreM_y,'Marker','.','MarkerSize',markerSize,'MarkerFaceColor',colormap_temp(r2,:),'MarkerEdgeColor',colormap_temp(r2,:));
        hold on;
        
        axis equal;
        if ~isempty(xRange)
            xlim(xRange);
        end
        if ~isempty(yRange)
            ylim(yRange);
        end
        pause(plotPause);
    end
end
end