% MVT_make_random_texture - Create Euler angles for random texture 
%
% Generate a set of Euler angles (Bunge notation, in degrees) for
% a random uniform texture of nxtl crystals. 
% 
% Usage: 
%     [ eulers ] = MVT_make_random_texture( nxtl )
%         Use the default Matlab PRN generator.
% 
%     [ eulers ] = MVT_make_random_texture( nxtl, 'stream', @RandStream )
%         Use the provided PRN generator (which must be 
%         created by the user).
%
% See also: MVT_read_VPSC_file

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

function [eulers] = MVT_make_random_texture(nxtl, varargin)

    % Default PRN stream
    stream = RandStream.getGlobalStream;

    % Process the optional arguments
    iarg = 1 ;
    while iarg <= (length(varargin))
        switch lower(varargin{iarg})
            case 'stream'
                stream = varargin{iarg+1} ;
                iarg = iarg + 2 ;
            otherwise
                error(['Unknown option: ' varargin{iarg}]) ;
        end
    end
    
    % Uniform random numbers between 0 and 1. We convert these
    % into the Euler angles.
    eulers = rand(stream,3,nxtl);
    
    % Convert phi1 and phi2 to degrees between 0 and 360. Note 
    % that if Phi = 0 the orientation is determined by the sum of
    % these two rotations, but the periodicity means the orentation
    % is still uniformly distributed.
    eulers(1,:) = eulers(1,:).*360.0;
    eulers(3,:) = eulers(3,:).*360.0;
    
    % Phi can be between -90 and 90 degrees and cos(Phi) must
    % be unformly distributed (the metric space is phi1, cos(Phi)
    % phi2. So first make the number between -1 and 1 then take the
    % arccos in degrees.
    eulers(2,:) = (eulers(2,:).*2.0)-1.0;
    eulers(2,:) = acosd(eulers(2,:));
    
end
