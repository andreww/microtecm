% MVT_olivine_pole_from_vpsc - draw a pole figure from a VPSC simulation 
%                              of olivine
%
% Makes use of MTEX to draw pole figures given afile name of a VPSC
% output file of olivine and, optionally, a title 
% and scale. Can also write output to a file in a supported graphics 
% format.
%
% Usage: 
%     MVT_olivine_pole_from_vpsc(filename, ...)
% 
%     Optional arguments are string - argument pairs. The following 
%     are supported
% 
%     MVT_olivine_pole_from_vpsc(filename, 'title', title, ...)
%         Give the plot a title
%
%     MVT_olivine_pole_from_vpsc(filename, 'scale', [x y], ...)
%         Force colour scale to run from x (minimum) to y (maximim)
%
%     MVT_olivine_pole_from_vpsc(filename, 'writefile', outfilename, format, ...)
%         Write the image to a file (the file name has the format extension 
%         added). Format can be 'eps', 'jpg', 'png' or 'tif'. 
%
% See also: MVT_plot_pole_figure


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

function MVT_olivine_pole_from_vpsc(filename, varargin)

    CS = crystalSymmetry('Pbnm', [4.75, 10.20, 5.98]);
    SS = specimenSymmetry('-1');
    
    [eulers, ~] = MVT_read_VPSC_file(filename);
    
    if (nargin == 1)
        MVT_plot_pole_figure(eulers, CS, SS);
    else
        MVT_plot_pole_figure(eulers, CS, SS, varargin{:});
    end
end


