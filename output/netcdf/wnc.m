function wnc(var,fname,vname,uname,dnames)
%%Load data from workspace to netCDF file.
%Syntax:
%wnc(var,fname,vname,uname)
%var=variable array
%fname=name of netcdf file (in quotations, i.e. 'example.nc')
%vname=name of variable (also in quotations)
%uname=name of variable units (also in quotations)
%dnames=names of dimensions
var=double(var);
%if file doesn't exist, create it.  If it exists, open it.

ncid = netcdf.create(fname,'CLOBBER');


dims=ndims(var);
dimsize=size(var);

for ndim=1:length(dimsize)
    ndim
    dimID(ndim)=netcdf.defDim(ncid,dnames{ndim},dimsize(ndim));
end
varid = netcdf.defVar(ncid,vname,'double',dimID);

netcdf.endDef(ncid)
netcdf.putVar(ncid,varid,var)
netcdf.reDef(ncid)
netcdf.putAtt(ncid,varid,'units',uname)
netcdf.close(ncid)
