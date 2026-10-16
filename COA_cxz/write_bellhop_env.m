function write_bellhop_env(M_Depth,Density,Atten,Bottom_speed,freq,Source_Depth,N_Rece_R,Rece_Range,N_Rece_D,Rece_Depth,runtype)  
%                   频率 声源深度 接收距离个数 接收距离 接收深度个数 接收深度
fid=fopen('ssp.env','w');   
fprintf(fid,'''ssp''     ! TITLE\n');
fprintf(fid,'%d         ! FREQ (Hz)\n',freq);
fprintf(fid,'1            ! NMEDIA\n');
fprintf(fid, '''SVW''           ! OPTIONS\n');
% 读取声速剖面
fid_S=fopen('SSP.txt','r');
RMS_Rough=0;
% RMS_Rough=fscanf(fid_S,'%f',1);
% M_Depth=fscanf(fid_S,'%f',1);
% Density=fscanf(fid_S,'%f',1);
% Atten=fscanf(fid_S,'%f',1);
fprintf(fid,'0  %f %f       ! NMESH SIGMA(m) Z(NSSP)\n', RMS_Rough, M_Depth);
% tDepth=fscanf(fid_S,'%f',1);
% tSpeed=fscanf(fid_S,'%f',1);
% fprintf(fid,'%8.1f   %8.1f  0.0  %6.3f  %6.3f   0.0\n',tDepth, tSpeed, Density(i),Atten(i));
for i=1:1000 
    tDepth=fscanf(fid_S,'%f',1);
    tSpeed=fscanf(fid_S,'%f',1);
    fprintf(fid, '%f   %f/\n', tDepth, tSpeed);
    if tDepth==M_Depth
        break;
    end   
end

%输出基底层的参数
fprintf(fid,' ''A'' 0.0          ! BOTOPT SIGMA(m)\n');
fprintf(fid,'%f  %f  0.0   %f   %f   0.0  /\n', M_Depth(end),Bottom_speed,Density,Atten);
fprintf(fid,'1         ! NSD\n');
fprintf(fid,'%f /              ! SD(1:NSD)  (m)\n', Source_Depth);
fprintf(fid,'%d          ! NRD\n', N_Rece_D);
for jj=1:N_Rece_D
fprintf(fid,'%f ', Rece_Depth(jj) );
end
fprintf(fid,'/');
fprintf(fid,'%s \n',' !RD(1:NRD)   (m)');

fprintf(fid,'%d          ! NRR\n', N_Rece_R);
for jj=1:N_Rece_R
fprintf(fid,'%f ', Rece_Range(jj) );
end
fprintf(fid,'/');
fprintf(fid,'%s \n',' !RR(1:NRR)   (m)');

fprintf(fid, '%s           ! R/C/I/S\n',runtype);
fprintf(fid,'00            ! NBeams\n');
fprintf(fid,'-80 80 /      ! ALPHA(1:NBEAMS) (degrees)\n');
fprintf(fid,'0.0 %f %f      ! STEP (m)  ZBOX (m)  RBOX (km)\n', Rece_Depth(end)+1e2,Rece_Range(end)+1);

fclose(fid);
fclose(fid_S);