% MVT_strain_invariants - calculate inveriants of square symmetric matrix
%
% Return I_E, II_E and III_E for a strain or strain rate tensor. I_E is the
% trace and gives the volume change, II_E is a measure of strain magnitude
% and III_E is the determinant. These do not change if the tensor is
% rotated.
%
% Usage:
%     [I_E, II_E, III_E] = MVT_strain_invariants(E)
%         E must be a 3*3 symmetric real matrix.
%
% See also: MVT_decompose_Lijs

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

function [I_E, II_E, III_E] = MVT_strain_invariants(E)

    s = size(E);
    assert((s(1) == 3), '1st dimension of strain(rate) matrix must be 3');
    assert((s(2) == 3), '2nd dimension of strain(rate) matrix must be 3');
    
    if length(s) == 2
        % This is a scalar calculation (one input matrix)
        [I_E, II_E, III_E] = scalar_strain_invariants(E);
    elseif length(s) == 3
        I_E = zeros(1,s(3));
        II_E = zeros(1,s(3));
        III_E = zeros(1,s(3));
        for i = 1:s(3)
            [I_E(i), II_E(i), III_E(i)] = ...
                scalar_strain_invariants(E(:,:,i));
        end
    else
        error('Argument must be 3x3xn or 3x3');
    end    
end

function [I_E, II_E, III_E] = scalar_strain_invariants(E)
        I_E = trace(E);
        II_E = 0.5*(trace(E)^2-trace(E^2));
        II_E = trace(E*E');
        III_E = det(E);
end