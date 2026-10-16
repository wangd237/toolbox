function ram_p(filename)

% run the RAM program
%
% usage: ram
% where filename is the environmental file (without the extension)

runram = which( 'for_ram.exe' );
eval( [ '! "' runram '" ' filename ] );
end