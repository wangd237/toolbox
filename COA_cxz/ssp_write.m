function ssp_write(DEP,SSP)

fid=fopen('SSP.txt','w');
for ii=1:length(SSP)
    fprintf(fid,'%f  %f  \n',DEP(ii),SSP(ii));
end
fclose(fid)