function SSP = read_in(envfil)
fid = fopen([envfil, '.in'],'rt+');
while ~feof(fid)
    tl = fgetl(fid);
    if contains(tl,'-1');
        break;
    end
end
A = zeros(2,999);

A(:,1) = fscanf(fid,'%f %f',[2 1]);
tl = fgetl(fid);
for i =2 :999
    A(:,i) = fscanf(fid,'%f %f',[2 1]);
    if abs(A(1,i) +1) < 1E-5
        break;
    end
end
SSP = A(:,1:i-1).';
fclose (fid);
end


