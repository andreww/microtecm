% MVT_read_Lij_file - Read list of velocity gradient tensors from file
%
% Given the name of a VPSC formatted file with variable velocity gradient 
% tensors, return an (3, 3, n) matrix. 
%
% Usage: 
%     [Lijs] = MVT_read_Lij_file(filename)
%
% See also: MVT_read_VPSC_file


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

function [Lijs, eps, timeincr] = MVT_read_Lij_file(filename)
    % Reads data from a VPSC output or input texture file.
    % Must be Bunge convention and in degrees. Returns eulers, a (3,nxtl) 
    % array of Euler angles (Bunge convention, (1,:) = phi1, (2,:) = Phi
    % and (3,:) = phi2) and a scalar nxtl, specifying the number of 
    % crystals / Euler angle triples.

    % Read data from the file
    fid = fopen(filename); % Read - the default
    % Read first header line
    H = sscanf(fgetl(fid), '%d %d %f %d');
    % Next line is a comment
    fgetl(fid);
    % Slurp the rest of the file for processing 
    L = fscanf(fid, '%i %g %g %g %g %g %g %g %g %g %g', [11 Inf] );
    fclose(fid);
    
    % Get hold of header info
    n_steps = H(1);
    modecode = H(2);
    eps = H(3);
    % temperature = H(4); By convention, this is not used.
    assert((modecode==7), ... % Check the file mode is OK
        'File mode (second integer on the header line) must be 7\n');
    
    % Build useful data out of array.
    Lijs = zeros(3,3,n_steps);
    timeincr = zeros(n_steps, 1);
    L = L';
    for i=1:n_steps
        assert((L(i, 1) == i), 'miscounting in loop!\n') 
        Lijs(1, 1, i) = L(i, 2);
        Lijs(1, 2, i) = L(i, 3);
        Lijs(1, 3, i) = L(i, 4);
        Lijs(2, 1, i) = L(i, 5);
        Lijs(2, 2, i) = L(i, 6);
        Lijs(2, 3, i) = L(i, 7);
        Lijs(3, 1, i) = L(i, 8);
        Lijs(3, 2, i) = L(i, 9);
        Lijs(3, 3, i) = L(i, 10);
        timeincr(i) = L(i, 11);
    end
   
end