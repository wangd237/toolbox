function  [ PlotTitle,  freqVec, Pos, pressure ]  = read_grid(filename)
% Read the grid file
% Output is a 2-D pressure field p(Nrd,Nrr)

fid = fopen(filename, 'rb');
PlotTitle = fread(fid, 80,'*char').';
env(1:10) = fread(fid, 10, 'float32');
env(11:16) = fread(fid, 6, 'int');
tt = { 'freq','zs','zr','rmax','dr','zmax','dz','zmplt','c0','rs','ndr','ndz','np','ns','lz','nnn'};


for i = 1:length(env)
    eval([tt{i},'=',num2str(env(i)),';']);
end

Pos.bty.nnn = nnn;
Pos.bty.rb = fread(fid, nnn, 'float32');
Pos.bty.zb = fread(fid, nnn,'float32');
%freqVec
freqVec = freq;

%pos
Pos.s.z = zs;
Pos.s.x = 0;
Pos.s.y = 0;
r = ndr*dr :ndr*dr :rmax;
nzplt=floor(zmplt/dz-0.5);
z = (ndz: ndz: nzplt) * dz;
Pos.r.z = z;
Pos.r.range = r;

pr = zeros(length(z),length(r));
pim = zeros(length(z),length(r));
for l = 1: length(r)
    pr(:,l) = fread(fid, length(z), 'float32');
    pim(:,l) = fread(fid, length(z), 'float32');
end
pressure = (pr+1j*pim);
feof(fid);
fclose(fid);
end