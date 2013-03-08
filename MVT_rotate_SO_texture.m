% MVT_rotate_SO_texture - Rotate a texture in an SO texture file 
%
% Given the name of a formatted texture file from the SO code, create
% a new file with the texture rotated by the three Euler angles (given in 
% degrees.
% 
% Usage: 
%     (texture_file_in, texture_file_out, g2_phi1, g2_Phi, g2_phi2)
%
% NOTE: This function may be replaced with a more general approach (not 
% tied to a specific file format.
%
% See also: MVT_read_SO_file, MVT_write_SO_file


% Copyright (c) 2013, Andrew Walker
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

function MVT_rotate_SO_texture (texture_file_in, texture_file_out, ...
    g2_phi1, g2_Phi, g2_phi2)


   % Read the texture from the input file
   [eulers, nxtls] = MVT_read_SO_file(texture_file_in);

   % Form a rotation matrix describing the rotation of
   % the texture
   g_2 = MVT_rot_from_Euler(g2_phi1, g2_Phi, g2_phi2);
   
   % Calculate the rotation describing the orientation of the rotate
   % crystal
   transformed_eulers = zeros(size(eulers));
   for x = 1:nxtls
       g_1 = MVT_rot_from_Euler(eulers(1,x), eulers(2,x), eulers(3,x));
       % g_1 is the rotation matrix needed move the frame of reference to 
       % be parallel with each crystal's lattice. This is a passive
       % rotation. g_2 is the passive rotation needed to 
       % move the frame of reference. We need to perform the active
       % rotation on the texture - thus multiply by the transpose of g_2. 
       g_1 = g_1*g_2';
       [phi1, Phi, phi2] = MVT_rot_to_Euler(g_1);
       transformed_eulers(1,x) = phi1;
       transformed_eulers(2,x) = Phi;
       transformed_eulers(3,x) = phi2;
   end
        
   % Write out the rotated texture
   MVT_write_SO_file(texture_file_out, transformed_eulers);

end