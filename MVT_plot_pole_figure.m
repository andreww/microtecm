% MVT_plot_pole_figure - Draw pole figures from Euler angles 
%
% Makes use of MTEX to draw pole figures given an array of Euler 
% angles, the crystal and sample symmetry and, optionally, a title 
% and scale. Can also write output to a file in a supported graphics 
% format.
%
% Usage: 
%     MVT_plot_pole_figure(eulers, CS, SS, ...)
% 
%     Optional arguments are string - argument pairs. The following 
%     are supported
% 
%     MVT_plot_pole_figure(eulers, CS, SS, 'title', title, ...)
%         Give the plot a title
%
%     MVT_plot_pole_figure(eulers, CS, SS, 'scale', [x y], ...)
%         Force colour scale to run from x (minimum) to y (maximim)
%
%     MVT_plot_pole_figure(eulers, CS, SS, 'writefile', filename, format, ...)
%         Write the image to a file (the file name has the format extension 
%         added). Format can be 'eps', 'jpg', 'png' or 'tif'. 
%
% See also: MS_plot


% Copyright (c) 2012, Andrew Walker
% All rights reserved.
% 
% Redistribution and use in source and binary forms, 
% with or without modification, are permitted provided 
% that the following conditions are met:
% 
%    * Redistributions of source code must retain the 
%      above copyright notice, this list of conditions 
%      and the following disclaimer.
%    * Redistributions in binary form must reproduce 
%      the above copyright notice, this list of conditions 
%      and the following disclaimer in the documentation 
%      and/or other materials provided with the distribution.
%    * Neither the name of the University of Bristol nor the names 
%      of its contributors may be used to endorse or promote 
%      products derived from this software without specific 
%      prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS 
% AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
% WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
% THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF 
% USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
% OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function MVT_plot_pole_figure(eulers, CS, SS, varargin)
    % Use MTEX to plot a pole figure of a set of Euler 
    % angles. Euler angles are in Bunge notation and 
    % degrees. User must pass in cystal symmetry (CS)
    % and sample symmetry (SS) generated using MTEX symmetry
    % constructor along with a title (a string for the plot
    % header) and an array of two values - the mimimum and 
    % maximum value for the contour scheme.
   
    % Default settings
    fix_scale = 0;
    scale_setting = [];
    add_title = 0;
    title_string = '';
    write_file = 0;
    filename = '';
    fileformat = '';
    axes = [Miller(1,0,0,CS),Miller(0,1,0,CS),Miller(0,0,1,CS)];
    
    % Process the optional arguments
    iarg = 1 ;
    while iarg <= (length(varargin))
        switch lower(varargin{iarg})
            case 'title'
                add_title = 1;
                title_string = varargin{iarg+1} ;
                iarg = iarg + 2 ;
            case 'scale'
                fix_scale = 1;
                scale_setting = varargin{iarg+1} ;
                iarg = iarg + 2 ;
            case 'writefile'
                write_file = 1;
                filename = varargin{iarg+1} ;
                fileformat = lower(varargin{iarg+2}) ;
                iarg = iarg + 3 ;
            case 'axes'
                axes = varargin{iarg+1};
                iarg=iarg+2;
            otherwise
                error(['Unknown option: ' varargin{iarg}]) ;
        end
    end
    
    if write_file
        switch fileformat
            case 'eps'
                filename = [filename '.eps'];
                fileformat = '-depsc';
            case 'jpg'
                filename = [filename '.jpg'];
                fileformat = '-djpeg';
            case 'tif'
                filename = [filename '.tif'];
                fileformat = '-dtiff';
            case 'png'
                filename = [filename '.png'];
                fileformat = '-dpng';
            otherwise
                warning('MVT:NoFormat', ...
                    'File format not recongised - not writing file');
                filename = '';
                write_file = 0;
        end
    end
                
    
    % Work in radians.
    eulers_r = eulers*degree;
    
    % Generate a list of orientation objects and an ebsd wrapper
    o = orientation('Euler', eulers_r(1,:), eulers_r(2,:), ...
        eulers_r(3,:), CS, SS, 'Bunge');
    
    % Fit an ODF
    odf = calcODF(o,'HALFWIDTH', 10*degree, 'silent');
    
    % Make a new figure and plot three pole figures in it...
    scrsz = get(0,'ScreenSize');
    % Always plot in the same place.
    h = figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]); 
    
    if fix_scale
        plotPDF(odf,axes, ...
            'antipodal','silent', 'colorrange', scale_setting);
    else
        plotPDF(odf,axes, ...
        'antipodal','silent');
    end
    
    colorbar;
   
    if add_title
        set(h, 'Name', title_string);
    end
    
    if write_file
        set(h, 'PaperPositionMode', 'auto');
        print(h, fileformat, filename);
    end
end