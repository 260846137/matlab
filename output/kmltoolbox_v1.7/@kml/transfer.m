function transfer(this,axisHandle,varargin)
%KML.TRANSFER(ax) Transfer the axis from the handle ax to the KML as an overlay.
%  Example:
%  k = kml;
%  t = linspace(0,2*pi,1000);
%  figure;
%  plot(t,sin(t));
%  k.transfer(gca)
%  k.run
%  
%  The corners of the overlay are taken from the axis limits.
% 
%   Copyright 2012 Rafael Fernandes de Oliveira (rafael@rafael.aero)
%   $Revision: 1.4 $  $Date: 2012/02/08 16:00:00 $

    p = inputParser;
    
    p.addRequired('axisHandle', @(a)ishghandle(a) && strcmpi(get(a,'Type'),'axes'));

    p.addParamValue('transparentBG',true,@islogical);
    p.addParamValue('keepAxis',false,@islogical);
    p.addParamValue('inPlace',false,@islogical);
    
    p.addParamValue('id','kml_overlay',@ischar);
    p.addParamValue('name','kml_overlay',@ischar);
    p.addParamValue('description','',@ischar);
    p.addParamValue('visibility',true,@islogical);
    p.addParamValue('viewBoundScale',1,@(a)isnumeric(a) && numel(a)==1);
    p.addParamValue('color','FFFFFFFF',@(a)ischar(a) && numel(a)==8);
    p.addParamValue('altitude',1,@(a)isnumeric(a) &&~isempty(a) && numel(a)==1);
    p.addParamValue('rotation',0,@(a)isnumeric(a) &&~isempty(a) && numel(a)==1);
    p.addParamValue('drawOrder',0,@(a)isnumeric(a) &&~isempty(a) && numel(a)==1);
    p.addParamValue('altitudeMode','clampToGround',@(a)ismember(a,{'clampToGround','absolute'}));
    
    p.addParamValue('timeStamp','',@ischar);
    p.addParamValue('timeSpanBegin','',@ischar);
    p.addParamValue('timeSpanEnd','',@ischar);    
    
    p.parse(axisHandle,varargin{:});
    
    arg = p.Results;
    

    xlim = get(axisHandle,'XLim');
    ylim = get(axisHandle,'YLim');

    f = ancestor(axisHandle,'Figure');
    name = get(f,'Name');
    
    if isempty(name)
        if isnumeric(f)
            name = sprintf('Figure %i',f);
        else
            [tmpvar,name] = fileparts(tempname(pwd));
        end
    end
    
    basename = name;
    
    name = [name '.png'];
    k = 1;
    while ~isempty(dir(name))
        name = sprintf('%s (%i)%s',basename,k,'.png');
        k = k+1;
    end
    
    if ~arg.inPlace
        ftmp = figure;
        axtmp = copyobj(axisHandle,ftmp);
    else
        axtmp = axisHandle;
        ftmp = ancestor(axtmp,'figure');
    end
    
    [west,east,south,north] = deal(xlim(1),xlim(2),ylim(1),ylim(2));    
    if ~arg.keepAxis
        axis(axtmp,'off')

        set(axtmp,'XTick',[],'YTick',[],'ZTick',[])
        set(get(axtmp,'XLabel'),'Visible','off');
        set(get(axtmp,'YLabel'),'Visible','off');
        set(get(axtmp,'ZLabel'),'Visible','off');
        
        tightInset = get(axtmp, 'TightInset');
        position(1) = tightInset(1);
        position(2) = tightInset(2);
        position(3) = 1 - tightInset(1) - tightInset(3);
        position(4) = 1 - tightInset(2) - tightInset(4);
        set(axtmp, 'Position', position);
    else
        p = get(axtmp, 'Position');
        
        longSpan = abs(west-east);
        latSpan = abs(south-north);
        west  = west - (longSpan/p(3)) *p(1);
        east  = east +  (longSpan/p(3))*(1-p(3)-p(1));
        south = south -  (latSpan/p(4))*p(2);
        north = north + (latSpan/p(4))*(1-p(4)-p(2));
    end
    
    saveas(ftmp, name);    
    
    %Remove a line of 3 pixels that MATLAB adds when saving the figure...
    %MUST CHECK if this holds always or not
    im = imread(name);
    im = im(1:end-3,1:end-3,:);
    
    if arg.transparentBG
        axc = get(axtmp,'Color');
        axc = ceil(axc*255);
        alphaMap = ~(im(:,:,1)==axc(1) & im(:,:,2)==axc(2) & im(:,:,3)==axc(3)).*255;
        imwrite(im,name,'Alpha',uint8(alphaMap));
    else
        imwrite(im,name);
    end
 
    this.overlay(west,east,south,north,'file',name,...
                                       'id',arg.id,...
                                       'name',arg.name,...
                                       'description',arg.description,...
                                       'visibility',arg.visibility,...
                                       'viewBoundScale',arg.viewBoundScale,...
                                       'color',arg.color,...
                                       'altitude',arg.altitude,...
                                       'rotation',arg.rotation,...
                                       'drawOrder',arg.drawOrder,...
                                       'altitudeMode',arg.altitudeMode,...
                                       'timeStamp', arg.timeStamp ,...
                                       'timeSpanBegin', arg.timeSpanBegin ,...
                                       'timeSpanEnd', arg.timeSpanEnd ...
                                       );
        
    close(ftmp);
end