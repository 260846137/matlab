function [b2r] = rbcbar(mincv,maxcv)
%Given maximum and minimum values, 
%routine will return a blue-white-red RGB mapping that 
%can be used as a colormap.
%if the min/max values are -/+, respectively, will return
%a colormap with blue in negative territory and red in
%positive territory (i.e. centered on 0).  
%If min/max values are -/- or +/+, will be all blue, or all red,
%respectively.
dval=maxcv-mincv;
nc=100;
b2r=ones(nc,3);
if mincv < 0 && maxcv > 0
  zp=floor(abs(nc*(mincv/dval)));
  b2r(1:zp,1)=linspace(0,1,zp);
  b2r(1:zp,2)=linspace(0,1,zp);
  b2r(zp:nc,3)=linspace(1,0,nc-zp+1);
  b2r(zp:nc,2)=linspace(1,0,nc-zp+1);
elseif  mincv < 0 && maxcv < 0
  b2r(:,1)=linspace(0,1,nc);
  b2r(:,2)=linspace(0,1,nc);
elseif  mincv>0 && maxcv>0
  b2r(:,3)=linspace(1,0,nc);
  b2r(:,2)=linspace(1,0,nc);  
end