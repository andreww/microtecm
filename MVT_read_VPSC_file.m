% MVT_read_VPSC_file - Create a VPSC texture file 
%
% Given the name of a VPSC formatted texture file, return an array 
% of Euler angles and the number of crystals in the file.
% 
% Usage: 
%     [eulers, nxtl] = MVT_read_VPSC_file(filename)
%
% See also: MVT_write_VPSC_file


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

function [eulers, nxtl] = MVT_read_VPSC_file(filename)
    % Reads data from a VPSC output or input texture file.
    % Must be Bunge convention and in degrees. Returns eulers, a (3,nxtl) 
    % array of Euler angles (Bunge convention, (1,:) = phi1, (2,:) = Phi
    % and (3,:) = phi2) and a scalar nxtl, specifying the number of 
    % crystals / Euler angle triples.

    % Read data from the file
    fid = fopen(filename); % Read - the default
    fgetl(fid); % Header line - ignore
    fgetl(fid); % Lengths of phase ellipsoid axes - ignore
    fgetl(fid); % Euler angles for phase ellipsoid - ignore
    L = sscanf(fgetl(fid), '%s %d'); % Convention and number of crystals
    E = fscanf(fid, '%f');
    fclose(fid);
    
    % Get hold of header info
    assert((char(L(1))=='B'), ... % Check Euler angle convention
        'Could not read VPSC file - not Bunge format\n');
    nxtl = L(2); % Number of crystals
    
    % Build Euler angles array.
    eulers = zeros(3,nxtl);
    eulers(1,:) = E(1:4:4*nxtl);
    eulers(2,:) = E(2:4:4*nxtl);
    eulers(3,:) = E(3:4:4*nxtl);
   
end