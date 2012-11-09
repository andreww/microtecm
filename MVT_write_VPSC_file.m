% MVT_write_VPSC_file - Create a VPSC texture file 
%
% Given an array of Euler angles, a file name and a descriptive title 
% create a properly formatted VPSC texture file that can be used as
% input to the code.
% 
% Usage: 
%     MVT_write_VPSC_file(filename, eulers, title)
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

function MVT_write_VPSC_file(filename, eulers, title)
    % Create a VPSC input or output texture file called <filename>.
    % Texture is described by a size(3,n) array of Euler angles
    % in <eulers> and these should be in degrees and in Bunge notation.
    % The string <title> is inserted into the header. At present, I assume
    % all crystals have the same volume fraction.

    % How many crystals
    n_xtals = size(eulers,2);
    % Open file for write (text mode)
    fid = fopen(filename,'wt');
    
    % Write the header lines
    fprintf(fid,'%s\n', title);
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'B  %5i\n', n_xtals);
    
    % Write the data - assume that volume fraction is the same for
    % each crystal
    for i = 1:n_xtals
        fprintf(fid,'%6.2f  %6.2f  %6.2f  %12.4f\n',...
            eulers(1,i), eulers(2,i), eulers(3,i), (1/n_xtals));
    end
    
    % Close file
    fclose(fid);  
    
end