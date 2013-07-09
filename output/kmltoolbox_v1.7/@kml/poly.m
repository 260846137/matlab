function poly(this,long,lat,varargin)
%KML.POLY(long,lat) Draw a closed polygon with vertices given by long, lat.
%  To change the altitude of the polygon, use KML.POLY(...,'altitude', 10000)
%  
%   Copyright 2012 Rafael Fernandes de Oliveira (rafael@rafael.aero)
%   $Revision: 1.4 $  $Date: 2012/02/08 16:00:00 $

    p = inputParser;
    p.KeepUnmatched = true;
    p.addParamValue('altitude',1,@(a)isnumeric(a) && isvector(a) &&~isempty(a));
    p.parse(varargin{:});
    
    arg = p.Results;
    
    v = varargin;
    
    [tmpvar,hasAltitude ]= ismemberVarargin('altitude',v);
    
    if any(hasAltitude)
        v(hasAltitude+1) = [];
        v(hasAltitude) = [];
    end

    this.poly3(long,lat,ones(size(lat)).*arg.altitude,v{:});
end


function [tf,loc] = ismemberVarargin(a,varin)
    if mod(numel(varin),2)==1
        error('Invalid number of named arguments.')
    end
    if ~iscell(a)
        a = {a};
    end
    tf  = false(size(a));
    loc = zeros(size(a));
    for i = 1:numel(a)
        for j = 1:2:numel(varin)
            if ischar(varin{j}) && strcmp(varin{j},a{i})
               tf(i) = true;
               loc(i) = j;
            end
        end
    end
end