% MVT_rot_to_Euler - Convert rotation matrix to Euler angles 
%
% Given a rotation matrix, g, return the three Euler angles phi1, Phi, 
% phi2 (Bunge notation, in degrees) representing the rotation.
% 
% Usage: 
%     [phi1, Phi, phi2] = MVT_rot_to_Euler(g)
%
% See also: MS_rotR MVT_rot_from_Euler


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


function [phi1, Phi, phi2] = MVT_rot_to_Euler(g)
 

    if (g(3,3)>1.0-eps)
        Phi = 0.0;
        phi1 = atan2(g(1,2),g(1,1));
        phi2 = 0.0;
    else
        Phi = acos(g(3,3));
        phi1 = atan2( (g(3,1)/sin(Phi)) , (-1.0*(g(3,2)/sin(Phi))) );
        phi2 = atan2( (g(1,3)/sin(Phi)) , (g(2,3)/sin(Phi)) );
    end
    
    if (phi1 < 0.0) 
        phi1 = 2*pi + phi1;
    end
    if (phi2 < 0.0)
        phi2 = 2*pi + phi2;
    end
    
    phi1 = (180.0/pi) * phi1;
    Phi =  (180.0/pi) * Phi;
    phi2 = (180.0/pi) * phi2;

end