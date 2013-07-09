function point(this,long,lat,alt,varargin)
%KML.POINT(long,lat,alt) Places point markers in the positions given by long, lat and alt
%  Similar to built-in scatter function. For a list of available markers, run
%    help kml.parseIconURL
%  
%   Copyright 2012 Rafael Fernandes de Oliveira (rafael@rafael.aero)
%   $Revision: 1.4 $  $Date: 2012/02/08 16:00:00 $

    [long,lat] = this.checkUnit(long,lat);

    p = inputParser;
    
    nlat = numel(lat);
    
    p.addRequired('lat', @(a)isnumeric(a) && isvector(a) &&~isempty(a));
    p.addRequired('long',@(a)isnumeric(a) && isvector(a) &&~isempty(a) && numel(a)==nlat);
    p.addRequired('alt', @(a)isnumeric(a) && isvector(a) &&~isempty(a) && numel(a)==nlat);
    
    p.addParamValue('id','kml_point',@ischar);
    p.addParamValue('name','kml_point',@ischar);
    p.addParamValue('description','',@ischar);
    p.addParamValue('visibility',true,@islogical);
    p.addParamValue('iconColor','FFFFFFFF',@(a)ischar(a) && numel(a)==8);
    p.addParamValue('iconURL','',@ischar);
    p.addParamValue('iconScale',1,@(a)isnumeric(a) && numel(a)==1);
    p.addParamValue('labelScale',1,@(a)isnumeric(a) && numel(a)==1);
    p.addParamValue('labelColor','FFFFFFFF',@(a)ischar(a) && numel(a)==8);
    p.addParamValue('altitudeMode','relativeToGround',@(a)ismember(a,{'clampToGround','relativeToGround','absolute'}));
    
    p.addParamValue('timeStamp','',@ischar);
    p.addParamValue('timeSpanBegin','',@ischar);
    p.addParamValue('timeSpanEnd','',@ischar);         
         
    p.parse(lat,long,alt,varargin{:});
    
    arg = p.Results;

    for i = 1:nlat
        coordinates = mat2str([long(i) lat(i) alt(i)]);
        coordinates = coordinates(2:end-1);
        coordinates = strrep(coordinates,' ',',');
        coordinates = strrep(coordinates,';',' ');

        placemark   = this.xml.createElement('Placemark');
        point       = this.xml.createElement('Point');
        style       = this.xml.createElement('Style');
        iconstyle   = this.xml.createElement('IconStyle');
        labelstyle  = this.xml.createElement('LabelStyle');
        icon        = this.xml.createElement('Icon');

        placemark.setAttribute('id',arg.id);
        placemark.appendChild(this.textNode('name',arg.name));
        placemark.appendChild(this.textNode('visibility',num2str(arg.visibility)));
        placemark.appendChild(this.textNode('description',arg.description));

        if ~isempty(arg.timeStamp)
            timeStamp = this.xml.createElement('TimeStamp');
            timeStamp.appendChild(this.textNode('when',arg.timeStamp));
            placemark.appendChild(timeStamp);
        elseif ~isempty(arg.timeSpanBegin) || ~isempty(arg.timeSpanEnd)
            timeSpan = this.xml.createElement('TimeSpan');
            if ~isempty(arg.timeSpanBegin) 
                timeSpan.appendChild(this.textNode('begin',arg.timeSpanBegin));
            end
            
            if ~isempty(arg.timeSpanEnd) 
                timeSpan.appendChild(this.textNode('end',arg.timeSpanEnd));
            end            
            placemark.appendChild(timeSpan);
        end
        
        iconstyle.appendChild(this.textNode('color',arg.iconColor));
        iconstyle.appendChild(this.textNode('scale',num2str(arg.iconScale)));
        icon.appendChild(this.textNode('href',kml.parseIconURL(arg.iconURL)));

        labelstyle.appendChild(this.textNode('color',arg.labelColor));
        labelstyle.appendChild(this.textNode('scale',num2str(arg.labelScale)));
        
        point.setAttribute('id',['Point_' arg.id]);
        point.appendChild(this.textNode('altitudeMode',arg.altitudeMode));
        point.appendChild(this.textNode('coordinates',coordinates));

        iconstyle.appendChild(icon);
        style.appendChild(iconstyle);
        style.appendChild(labelstyle);
        placemark.appendChild(style);
        placemark.appendChild(point);
        this.doc.appendChild(placemark);
    end
end