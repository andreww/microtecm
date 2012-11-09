% MVT_rot_from_Euler - Convert Euler angles to rotation matrix 
%
% Given three Euler angles phi1, Phi, phi2 (Bunge notation, in degrees)
% return a rotation matrix, g, representing the rotation.
% 
% Usage: 
%     [g] = MVT_rot_to_Euler(phi1, Phi, phi2)
%
% Notes: This is the 'passive' rotation, take the transpose for the 
%     active case.
%
% See also: MS_rotEuler MVT_rot_to_Euler


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


function [ g ] = MVT_rot_from_Euler(phi1, theta, phi2)
    % Given three Euler angles phi1, Phi, phi2 (Bunge notation, 
    % in degrees) return a rotation matrix, g, representing the 
    % rotation. This is the 'passive' rotation.
    
    % Pre-compute trig functions.
    cp1 = cos(phi1*pi/180.0);
    sp1 = sin(phi1*pi/180.0);
    cp2 = cos(phi2*pi/180.0);
    sp2 = sin(phi2*pi/180.0);
    cth = cos(theta*pi/180.0);
    sth = sin(theta*pi/180.0);

    % Form rotation matrix for Bunge convention of 
    % Euler angles, see eq 24 (pg81) of "Preferred
    % orientation in deformed meals and rocks... H-K Wenk (ed)"
    g = [cp1*cp2 - sp1*sp2*cth, sp1*cp2 + cp1*sp2*cth, sp2*sth ; ...
        -1*cp1*sp2 - sp1*cp2*cth, -1*sp1*sp2 + cp1*cp2*cth, cp2*sth; ...
        sp1*sth, -1*cp1*sth, cth];
    
   
end