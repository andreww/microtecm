% MVT_decompose_Lijs - Extract strain rate and vorticity from veloc grad
%
% Given a list of velocity gradient tensors, an (3, 3, n) matrix, return 
% some useful numbers describing the defomation. 
%
% Usage: 
%     [] = MVT_decompose_Lijs(Lijs)
%
% See also: MVT_read_Lij_file

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


function [Es, Ws, e, pa, vort] = MVT_decompose_Lijs(Lijs)

    s = size(Lijs);
    assert((s(1) == 3), 'First dimension of Lijs must be size 3\n'); 
    assert((s(2) == 3), 'First dimension of Lijs must be size 3\n');
    n_t = s(3);
    
    Es = zeros(s);
    Ws = zeros(s);
    e = zeros(3, n_t);
    pa = zeros(s);
    vort = zeros(3, n_t);
    for n=1:n_t
        [E, W] = decomp(Lijs(:,:,n));
        Es(:,:,n) = E(:,:);
        Ws(:,:,n) = W(:,:);
        vort(1,n) = W(2,3)*2.0;
        vort(2,n) = W(1,3)*2.0;
        vort(3,n) = W(1,2)*2.0;
        [e(:,n) pa(:,:,n)] = principStrain(E); 
    end

end

function [e, pa] = principStrain(E)

    
    [EIVEC EIVAL] = eig(E);
    e_RAW = [EIVAL(1,1) EIVAL(2,2) EIVAL(3,3)] ;
    [e IND] = sort(e_RAW,2,'descend') ;
    pa = EIVEC ; % for dimensioning
    for i=1:3
        pa(:,i) = EIVEC(:,IND(i)) ;
    end

    % Do something with EIGVEC to get a rotation
end

function [E, W] = decomp(L)

    for i = 1:3
        for j = 1:3
            E(i,j) = (L(i,j)+L(j,i))/2.0;
            W(i,j) = (L(i,j)-L(j,i))/2.0;
        end
    end
end