% MVT_make_random_texture - Create Euler angles for random texture 
%
% Generate a set of Euler angles (Bunge notation, in degrees) for
% a random uniform texture of nxtl crystals. 
% 
% Usage: 
%     [ eulers ] = MVT_read_VPSC_file( nxtl )
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

function [eulers] = MVT_make_random_texture(nxtl)

    phi = 2 * pi * rand(1,nxtl);
    theta = asin(rand(1,nxtl));
    psi = pi * (rand(1,nxtl)*2 - 1);
    
    R1 = zeros(3,3,nxtl) ;
    R1(1,1,:) = 1;
    R1(2,2,:) = cos(phi);
    R1(2,3,:) = sin(phi);
    R1(3,2,:) = -sin(phi);
    R1(3,3,:) = cos(phi);
    
    R2 = zeros(3,3,nxtl) ;
    R2(1,1,:) = cos(theta);
    R2(2,3,:) = -sin(theta);
    R2(2,2,:) = 1;
    R2(3,1,:) = sin(theta);
    R2(3,3,:) = cos(theta);
    
    R3 = zeros(3,3,nxtl) ;
    R3(1,1,:) = cos(psi);
    R3(1,2,:) = sin(psi);
    R3(2,1,:) = -sin(psi);
    R3(2,2,:) = cos(psi);
    R3(3,3,:) = 1;

    
 
    eulers = zeros(3,nxtl);
    for i = 1:nxtl
        %R = R3(:,:,i)*R2(:,:,i)*R1(:,:,i);
        %[phi1, Phi, phi2] = MVT_rot_to_Euler(R);   
        eulers(1,i) = (180.0/pi) *phi(i);
        eulers(2,i) = (180.0/pi) *theta(i);
        eulers(3,i) = (180.0/pi) *psi(i);
    end
end