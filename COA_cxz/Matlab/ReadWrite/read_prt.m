function  [   k  alpha  Phase_Speed  Group_Speed] = read_prt( filename )
% Read the environmental file

fid = fopen( filename, 'r' );
if ( fid == -1 )
    errordlg( 'Unable to open prt file', 'read_prt' );
end
TitleEnv='00000';
while ~strcmp(TitleEnv(1:5),'    I')
    TitleEnv = fgetl( fid );
    if strcmp(TitleEnv,'')
        TitleEnv='00000';
    end
end
fid_s=fopen('prt.txt','w');
while 1
    tline=fgetl(fid);
    if ~ischar(tline),break,end
    fprintf(fid_s,tline);
    fprintf(fid_s,'\n');
    
%     if strcmp(tline(1,2),' _'),break,end
end
fclose(fid);
fclose(fid_s);
data=importdata('prt.txt');
k=data(:,2);
alpha=data(:,3);
Phase_Speed=data(:,4);
Group_Speed=data(:,5);