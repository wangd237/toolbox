function write_env(NMEDIA,M_Depth,Density,Atten,Bottom_speed,freq,Source_Depth,N_Rece_H,Rece_Range,N_Rece_V,Rece_Depth)  
%                   频率 声源深度 接收距离个数 接收距离 接收深度个数 接收深度
fid=fopen('ssp.env','w');   
RMAX=Rece_Range(end);
% NMEDIA=1;
fprintf(fid,'''ssp''     ! TITLE\n');
fprintf(fid,'%f         ! FREQ (Hz)\n',freq);
fprintf(fid,'%d            ! NMEDIA\n', NMEDIA);
fprintf(fid, '''NVW''           ! OPTIONS\n');
% 读取声速剖面
fid_S=fopen('SSP.txt','r');
RMS_Rough=0;
% RMS_Rough=fscanf(fid_S,'%f',1);
% M_Depth=fscanf(fid_S,'%f',1);
% Density=fscanf(fid_S,'%f',1);
% Atten=fscanf(fid_S,'%f',1);
for i=1:NMEDIA
fprintf(fid,'0  %f %f       ! NMESH SIGMA(m) Z(NSSP)\n', RMS_Rough, M_Depth(i));
% tDepth=fscanf(fid_S,'%f',1);
% tSpeed=fscanf(fid_S,'%f',1);
% fprintf(fid,'%8.1f   %8.1f  0.0  %6.3f  %6.3f   0.0\n',tDepth, tSpeed, Density(i),Atten(i));
tDepth=0;
for ii=1:1000
    if tDepth==M_Depth(i)
        break;
    end                 % 这个if循环可以省略。
    tDepth=fscanf(fid_S,'%f',1);
    tSpeed=fscanf(fid_S,'%f',1);
    fprintf(fid, '%f   %f 0.0  %f %f 0/\n', tDepth, tSpeed,Density(i),Atten(i));
end
end

%输出基底层的参数
fprintf(fid,' ''A'' 0.0          ! BOTOPT SIGMA(m)\n');
fprintf(fid,'%f  %f  0.0   %f   %f   0.0  /\n', M_Depth(end),Bottom_speed,Density(end),Atten(end));
fprintf(fid,'0    4000                  ! CLOW CHIGH (m/s)\n');
fprintf(fid,'  %7.3f          !RMAX (km)\n', RMAX);
fprintf(fid,'%d         ! NSD\n', length(Source_Depth));
for jj=1:length( Source_Depth)  % jj=1:N_Rece_V  
fprintf(fid,'%f ', Source_Depth(jj) );
end
fprintf(fid,'/');
fprintf(fid,'%s \n',' ! SD(1:NSD)  (m)');
fprintf(fid,'%d          ! NRD\n', N_Rece_V);
% for i=1:(N_Rece_V-1)
%     fprintf(fid,'%d   %7.1f / \n',i, Rece_Depth(i));
% end
for jj=1:length( Rece_Depth)  % jj=1:N_Rece_V  
fprintf(fid,'%f ', Rece_Depth(jj) );
end
fprintf(fid,'/');
fprintf(fid,'%s \n',' !RD(1:NRD)   (m)'); %  把后面的部分以字符串形式输入env中。
fclose(fid);
fclose(fid_S);
%写field环境文件
fid=fopen('field.flp','w');
fprintf(fid, '/,				! TITLE\n');
fprintf(fid,'''RA''				! OPT ''X/R'' (coords), ''C/A'' (couple/adiab)\n');
fprintf(fid,'9900       	! M  (number of modes to include)\n');
fprintf(fid,'1     ！NPROF\n');
fprintf(fid,'   0.0 	  ! RPROF(1:NPROF) (km)\n');
fprintf(fid,'%d     ! NR\n', N_Rece_H);
for j=1:length(Rece_Range)
fprintf(fid,'%f  ',Rece_Range(j));
end
%fprintf(fid,'0.0 400.0 /  !R(1:NR) (km) ');    % 与上面的for循环和下一语句起的效果等同
fprintf(fid,'%s\n','/ !R(1:NR) (km)');
fprintf(fid,'%d         ! NSD\n', length(Source_Depth));
for jj=1:length( Source_Depth)  % jj=1:N_Rece_V  
fprintf(fid,'%f ', Source_Depth(jj) );
end
fprintf(fid,'/');
fprintf(fid,'%s \n',' ! SD(1:NSD)  (m)');
fprintf(fid,'%d     ! NRD\n', N_Rece_V);
for jj=1:length( Rece_Depth)
fprintf(fid,'%f ', Rece_Depth(jj) );
end

fprintf(fid,'%s\n',' / !RD(1:NRD)   (m)');
%fprintf(fid,'0.0 5000.0 /  !RD (1:NRD) (m) ');   %与上面四行程序相同作用
%fprintf(fid,'1      !NRR\n');
fprintf(fid,'%d      !NRR\n', N_Rece_V);
fprintf(fid,'0.0 /			! RR(1:NRR)   (m)\n');
fclose(fid);