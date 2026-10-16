function varargout = plotgrid(varargin)
% plot a single TL surface in dB
% usage:
% plotshd( filename, m, n, p )
% (m, n, p) optional subplot spec
% '.shd' is the default file extension if not specified
%
% mbp
global units 

filename = varargin{1};
[ PlotTitle,  freq, Pos, pressure ]  = read_grid(filename);

switch nargin
    case 2
        iz = varargin{2};
        pressure = pressure(iz,:);
        
    case 4
        m = varargin{2};
        n = varargin{3};
        p = varargin{4};
end



if ( nargin == 1 )
%     figure
else
    if ( nargin == 4 )
        if ( p == 1 )
            %figure( 'units', 'normalized', 'outerposition', [ 0 0 1 1 ] ); % first subplot
            figure
        else
            hold on   % not first subplot
        end
        subplot( m, n, p )
    end
end

zt       = Pos.r.z;
rt       = Pos.r.range;
if ( nargin == 2 )
    zt = zt(iz);
end

% set labels in m or km
xlab     = 'Range (m)';
if ( strcmp( units, 'km' ) )
   rt      = rt / 1000.0;
   xlab    = 'Range (km)';
end

tlt = double( abs( pressure ) );   % pcolor needs 'double' because field.m produces a single precision
tlt( isnan( tlt ) ) = 1e-6;   % remove NaNs
tlt( isinf( tlt ) ) = 1e-6;   % remove infinities

icount = find( tlt > 1e-37 );        % for stats, only these values count
tlt( tlt < 1e-37 ) = 1e-37;          % remove zeros
tlt = -20.0 * log10( tlt ) ;          % so there's no error when we take the log
% compute some statistics to automatically set the color bar

tlmed = median( tlt( icount ) );    % median value
tlstd = std( tlt( icount ) );       % standard deviation
tlmax = tlmed + 0.75 * tlstd;       % max for colorbar
tlmax = 10 * round( tlmax / 10 );   % make sure the limits are round numbers
tlmin = tlmax - 50;                 % min for colorbar

tej = flipud( jet( 256 ) );  % 'jet' colormap reversed

if ( size( tlt, 1 ) > 1 && size( tlt, 2 ) > 1 )
    % imagesc produces a better PostScript file, using PostScript fonts
    % however, it ignores the actual r, z, coordinates and assumes they're
    % equispaced
    %h = imagesc( rt, zt, tlt );
    % h = imagesc( tlt );
    %    figure;
    h = pcolor( rt, zt, tlt );  ...
        shading flat
    colormap( tej )
    caxisrev( [ tlmin, tlmax ] )
    set( gca, 'YDir', 'Reverse' )
    xlabel( xlab )
    ylabel( 'Depth (m)' );
    title( { deblank( PlotTitle ); [ 'Freq = ' num2str( freq ) ' Hz    z_{src} = ' num2str( Pos.s.z ) ' m' ] } )
    rb = Pos.bty.rb/1000;
    zb = Pos.bty.zb;
    
    hold on
    plot(rb,zb,'white','linewidth',2)
else   % line plots
    if ( length(rt)> 1 )   % TL vs. range
        h = plot( rt, tlt,'r' );
        xlabel( xlab );
        ylabel( 'TL (dB)' )
        set( gca, 'YDir', 'Reverse' )
        title( deblank( PlotTitle ) )
    else
        % TL vs. depth
        h = plot( tlt', zt,'r' );
        set( gca, 'YDir', 'Reverse' )
        set( gca, 'Xdir', 'Reverse' )
        xlabel( 'TL (dB)' )
        ylabel( 'Depth (m)' );
        title( deblank( PlotTitle ) )
    end
end

drawnow

if ( nargout == 1 )
    varargout( 1 ) = { h };   % return a handle to the figure
end


end
