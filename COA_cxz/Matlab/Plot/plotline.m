function h = plotline(filename)
% RUN test: plotline Munkbty.line


% fid = fopen([filename '.grid'],'rb');
% PlotTitle = fread(fid, 80,'*char').';
% env(1:10) = fread(fid, 10, 'float32');
% env(11:16) = fread(fid, 6, 'int');
% tt = { 'freq','zs','zr','rmax','dr','zmax','dz','zmplt','c0','rs','ndr','ndz','np','ns','lz','nnn'};
% 
% for i = 1:length(env)
%     eval([tt{i},'=',num2str(env(i)),';']);
% end
% for i = 1:15
%     eval([tt{i},'=',num2str(env(i)),';']);
% end
tl_g= load([filename,'.line']);
% figure;
hold on;
if nargout == 0
    plot( tl_g(:,1) / 1000, tl_g(:,2),'r');    
else if nargout ==1
        h = plot( tl_g(:,1) / 1000, tl_g(:,2),'r');
    end
end
axis ij
xlabel('Range(km)')
ylabel('TL(dB)')
% title( { deblank( PlotTitle ); [ 'Freq = ' num2str( freq ) ' Hz    z_{src} = ' num2str(zs ) ' m    z_r=', num2str(zr) 'm'] } )
% fclose(fid);
end