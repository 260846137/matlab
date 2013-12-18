function [cb] = plot_icesheet( handle , hs, h )

hold on
contourf(handle,hs',20)
contour(handle,h',[0.5 0.5],'Linecolor','k')
set(gca,'Xtick',[],'Ytick',[])
hold off
shading flat
axis equal tight
caxis([0 3500])
cb=colorbar
xlabel(cb,'m asl  ','Fontsize',15)
hold off

end