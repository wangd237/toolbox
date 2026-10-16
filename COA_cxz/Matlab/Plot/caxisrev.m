function caxisrev( clim )

% sets the color axis limits and reverses the ticks
%
% usage: caxisrev( clim )
%
% MBP January 2010

caxis( clim )
colorbar
% h=colorbar('v');
% set(get(h,'ylabel'),'string','Evaporation Duct Height (m)','FontSize',12);
% colorbar( 'YDir', 'Reverse' )
