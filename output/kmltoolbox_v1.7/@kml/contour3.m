function contour3(this,long,lat,alt,varargin)
%KML.CONTOUR(long,lat,alt) Create a 3D contour of alt in a grid defined by long and lat.
%  The altitude of each line is given by its associated contour level
%  Similar to built-in contour3 function
%
%   Copyright 2012 Rafael Fernandes de Oliveira (rafael@rafael.aero)
%   $Revision: 1.4 $  $Date: 2012/02/08 16:00:00 $

    p = inputParser;
    
    nlat = numel(lat);

    p.addRequired('lat',  @(a)isnumeric(a) && ~isempty(a));
    p.addRequired('long', @(a)isnumeric(a) && ~isempty(a) && numel(a)==nlat);
    p.addRequired('alt',  @(a)isnumeric(a) && ~isempty(a) && numel(a)==nlat);
    
    p.addParamValue('name','kml_contour',@ischar);
    p.addParamValue('description','',@ischar);
    p.addParamValue('visibility',true,@islogical);
    p.addParamValue('colorMap','jet',@ischar);
    p.addParamValue('numberOfLevels','auto',@(a)(ischar(a) && strcmpi(a,'auto')) ||(isnumeric(a)&&numel(a)==1));
    p.addParamValue('altitudeMode','relativeToGround',@(a)ismember(a,{'clampToGround','relativeToGround','absolute'}));

    p.addParamValue('timeStamp','',@ischar);
    p.addParamValue('timeSpanBegin','',@ischar);
    p.addParamValue('timeSpanEnd','',@ischar);    
    
    p.parse(lat,long,alt,varargin{:});
    
    arg = p.Results;
    
    f = this.createFolder(arg.name);
    if isnumeric(arg.numberOfLevels)
        c = contours(lat,long,alt,arg.numberOfLevels);
    else
        c = contours(lat,long,alt);
    end
    
    minAlt = min(min(alt));
    maxAlt = max(max(alt));
    
    i = 1; k=1;
    while true
        l = c(1,i);
        n = c(2,i);
        C(k).lat = c(1,(i+1):(i+n));
        C(k).long = c(2,(i+1):(i+n));
        C(k).l = l;
        i = i + n + 1;
        k = k + 1;
        if i > size(c,2)
            break;
        end
    end
    
    ncolors = 100;
    cmap = feval(arg.colorMap,ncolors);
    zs = linspace(minAlt,maxAlt,ncolors);
    for i = 1:numel(C)
        
        color = [interp1(zs,cmap(:,1),C(i).l) interp1(zs,cmap(:,2),C(i).l) interp1(zs,cmap(:,3),C(i).l)];

        color = min(max(floor(color*255),0),255);
        [r,g,b,a] = deal(color(1),color(2),color(3),255); 
        [rhex, ghex, bhex, ahex ]= deal(dec2hex(r),dec2hex(g),dec2hex(b),dec2hex(a));
        if length(rhex)==1,rhex=['0' rhex];end
        if length(ghex)==1,ghex=['0' ghex];end
        if length(bhex)==1,bhex=['0' bhex];end
        if length(ahex)==1,ahex=['0' ahex];end

        colorHex = [ahex bhex ghex rhex];
           
        f.plot(C(i).long,C(i).lat, 'lineColor', colorHex, ...
                                   'altitudeMode',arg.altitudeMode, ...
                                   'altitude',C(i).l,...
                                   'visibility',arg.visibility, ...
                                   'name',sprintf('Level %g',C(i).l), ...
                                   'timeStamp', arg.timeStamp , ...
                                   'timeSpanBegin', arg.timeSpanBegin , ...
                                   'timeSpanEnd', arg.timeSpanEnd ...                                   
                                   );
    end
end