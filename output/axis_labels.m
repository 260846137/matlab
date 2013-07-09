% check for arrays that are not 100x100
dimsize=size(pv);
if dimsize(1)==100 & dimsize(2)==100
  %generate lon/lat labelling
  lon_labels={'60W','','180W','','60E'};
  lon_ticks=linspace(0,100,7);
  lon_ticks=lon_ticks(2:6);
  set(gca,'XTick',lon_ticks,'XTicklabel',lon_labels);

  lat_labels={'60S','','EQ','','60N'};
  lat_ticks=linspace(0,100,7);
  lat_ticks=lat_ticks(2:6);
  set(gca,'YTick',lat_ticks,'YTicklabel',lat_labels);

  set(gca,'TickLength',[0.02 0],'Tickdir','out');
  
elseif dimsize(1)==19 & dimsize(2)==100
  %generate latitude-depth labelling
  lon_labels={'60S','','0','','60N'};
  lon_ticks=linspace(-100,100,7);
  lon_ticks=lon_ticks(2:6);
  set(gca,'XTick',lon_ticks,'XTicklabel',lon_labels); 
  
  %depth_labels={'0m','-1500m','-3000m','-4500m','-6000m'}
  %depth_ticks=linspace(0,6000,5);
  %set(gca,'YTick',depth_ticks,'YTicklabel',depth_labels);
end
  