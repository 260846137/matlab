function wnc_ll(var,fname,vname,uname)
%%Load global lat/lon data from workspace to netCDF file.
%Data must be on a lat-lon grid, with latitude from -90-90
%and longitude from 0-360 (i.e. edge at Greenwich).
%Syntax:
%wnc(var,fname,vname,uname)
%var=variable array
%fname=name of netcdf file (in quotations, i.e. 'example.nc')
%vname=name of variable (also in quotations)
%uname=name of variable units (also in quotations)

global print_output

if print_output
    var=double(var);
    ncid = netcdf.create(fname,'NC_CLOBBER');
    
    dimsize=size(var);
    num_of_dims=ndims(var);
    
    lonoffset=360./dimsize(1)/2.;
    lons=lonoffset;
    lone=360-lonoffset;
    lon=linspace(lons,lone,dimsize(1));
    
    latoffset=180./dimsize(2)/2.;
    lats=-90+latoffset;
    late=90-latoffset;
    lat=linspace(lats,late,dimsize(2));
    
    if num_of_dims == 2
        idim = netcdf.defDim(ncid,'LONGITUDE',dimsize(1));
        jdim = netcdf.defDim(ncid,'LATITUDE',dimsize(2));
        varid(1) = netcdf.defVar(ncid,'LONGITUDE','double',[idim]);
        varid(2) = netcdf.defVar(ncid,'LATITUDE','double',[jdim]);
        varid(3) = netcdf.defVar(ncid,vname,'double',[idim,jdim]);
    elseif num_of_dims == 3
        idim = netcdf.defDim(ncid,'LONGITUDE',dimsize(1));
        jdim = netcdf.defDim(ncid,'LATITUDE',dimsize(2));
        kdim = netcdf.defDim(ncid,'DEPTH',dimsize(3));
        varid(1) = netcdf.defVar(ncid,'LONGITUDE','double',[idim]);
        varid(2) = netcdf.defVar(ncid,'LATITUDE','double',[jdim]);
        varid(3) = netcdf.defVar(ncid,vname,'double',[idim,jdim,kdim]);
    else
        message='Error: array sent to wnc is not 2 or 3 dimensions.'
    end
    netcdf.endDef(ncid)
    netcdf.putVar(ncid,varid(1),lon)
    netcdf.putVar(ncid,varid(2),lat)
    netcdf.putVar(ncid,varid(3),var)
    netcdf.reDef(ncid)
    netcdf.putAtt(ncid,varid(1),'units','Degrees')
    netcdf.putAtt(ncid,varid(2),'units','Degrees')
    netcdf.putAtt(ncid,varid(3),'units',uname)
    netcdf.close(ncid)
    
end
