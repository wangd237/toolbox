function write_env_qp( envfil, model, TitleEnv, freq, SSP_cell, Bdry_cell, Pos, Beam, cInt, RMax, varargin )

% Write an environmental file
% mbp 2009
% note: I had an unusual case with a parabolic mirror where round-off in
% the receiver ranges was a problem (+/- 1 m in range)
% Changed the output format from %6.2f to %6f to accommodate that.
% Similar issues may occur elsewhere in the code below ...

if ( strcmp( envfil, 'ENVFIL' ) == 0 && ~strcmp( envfil( end-3: end ), '.env' ) )
  envfil = [ envfil '.env' ]; % append extension
end

if ( size( varargin ) == 0 )
    fid = fopen( envfil, 'wt' );   % create new envfil
else
    fid = fopen( envfil, 'at' );   % append to existing envfil
end

if ( fid == -1 )
    disp( envfil )
    error( 'Unable to create environmental file', 'write_env' );
end

model = upper( model );   % convert to uppercase

fprintf( fid, '''%s'' ! Title \n', TitleEnv );
fprintf( fid, '%8.2f  \t \t \t ! Frequency (Hz) \n', freq );
fprintf( fid, '%5i    \t \t \t ! NMedia \n', SSP_cell{1} );
fprintf( fid, '''%s'' \t \t \t ! Top Option \n', Bdry_cell{1} );

if ( Bdry_cell{1}( 2:2 ) == 'A' )
    fprintf( fid, '    %6.2f %6.2f %6.2f %6.2g %6.2f %6.2f /  \t ! upper halfspace \n', 0, ...
        Bdry_cell{3}, Bdry_cell{4}, Bdry_cell{5}, Bdry_cell{6}, Bdry_cell{7} );
end

% SSP
for medium = 1 : SSP_cell{1}
    
    fprintf( fid, '%5i %4.2f %6.2f \t ! N sigma depth \n', SSP_cell{(medium-1)*10+2}, SSP_cell{(medium-1)*10+3}, ...
        SSP_cell{(medium-1)*10+4} );
    for ii = 1 : length( SSP_cell{(medium-1)*10+5} )
        fprintf( fid, '\t %6.2f %6.2f %6.2f %6.2g %10.6f %6.2f / \t ! z c cs rho \n', ...
            [ SSP_cell{(medium-1)*10+5}(ii) ...
              SSP_cell{(medium-1)*10+7}(ii) SSP_cell{(medium-1)*10+8}(ii) SSP_cell{(medium-1)*10+9}(ii) ...
              SSP_cell{(medium-1)*10+10}(ii) SSP_cell{(medium-1)*10+11}(ii) ].' );
    end
end

% lower halfspace
fprintf( fid, '''%s'' %6.2f  \t \t ! Bottom Option, sigma \n', Bdry_cell{2}, 0.0 ); % SSP.sigma( 2 ) );

if ( Bdry_cell{2} == 'A' )
    fprintf( fid, '    %6.2f %6.2f %6.2f %6.2g %6.2f %6.2f /  \t ! lower halfspace \n', SSP_cell{(medium-1)*10+4}, ...
        Bdry_cell{3}, Bdry_cell{4}, Bdry_cell{5}, Bdry_cell{6}, Bdry_cell{7} );
end

if( strmatch( model, char( 'SCOOTER', 'KRAKEN', 'KRAKENC', 'SPARC' ), 'exact' ) )
    fprintf( fid, '%6.0f %6.0f \t \t ! cLow cHigh (m/s) \n', cInt.Low, cInt.High );   % phase speed limits
    fprintf( fid, '%8.2f \t \t \t ! RMax (km) \n', RMax );    % maximum range
end

% source depths

fprintf( fid, '%5i \t \t \t \t ! NSz \n', length( Pos.s.z ) );

if ( length( Pos.s.z ) >= 2 && equally_spaced( Pos.s.z ) )
    fprintf( fid, '    %6f %6f', Pos.s.z( 1 ), Pos.s.z( end ) );
else
    fprintf( fid, '    %6f  ', Pos.s.z );
end

fprintf( fid, '/ \t ! Sz(1)  ... (m) \n' );

% receiver depths

fprintf( fid, '%5i \t \t \t \t ! NRz \n', length( Pos.r.z ) );

if ( length( Pos.r.z ) >= 2 && equally_spaced( Pos.r.z ) )
    fprintf( fid, '    %6f %6f ', Pos.r.z( 1 ), Pos.r.z( end ) );
else
    fprintf( fid, '    %6f  ', Pos.r.z );
end

fprintf( fid, '/ \t ! Rz(1)  ... (m) \n' );

% receiver ranges
if ( strcmp( model, 'BELLHOP' ) ||  strcmp( model, 'simplePE' ) )
    fprintf( fid, '%5i \t \t \t \t ! NRr \n', length( Pos.r.r ) );
    
    if ( length( Pos.r.r ) >= 2 && equally_spaced( Pos.r.r ) )
        fprintf( fid, '    %6f %6f', Pos.r.r( 1 ), Pos.r.r( end ) );
    else
        fprintf( fid, '    %6f ', Pos.r.r );
    end
    fprintf( fid, '/ \t ! Rr(1)  ... (km) \n' );
    write_bell( fid, Beam );
end

if length(Bdry_cell{1}) == 6 && Bdry_cell{1}( 6:6 ) == 'B'
    fprintf( fid, '%5i \t \t \t \t ! Nfreq \n', length( Pos.freqvec ) );

if ( length( Pos.freqvec ) >= 2 && equally_spaced( Pos.freqvec ) )
    fprintf( fid, '    %6f %6f ', Pos.freqvec( 1 ), Pos.freqvec( end ) );
else
    fprintf( fid, '    %6f  ', Pos.freqvec );
end
fprintf( fid, '/ \t  ! freqVec( 1 : Nfreq ) \n' );
end

fclose( fid );
end
