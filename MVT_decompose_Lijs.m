% MVT_decompose_Lijs - Extract strain rate and vorticity from veloc grad
%
% Return the strain rate, rotation rate, and strain rate decomposed onto 
% the principal strain axis from a general velocity gradient tensor (or a
% list of tensors). Values returned are:
%
%     E and W. Strain rate and rotation rate tensors expressed on the input
%     frame of reference. For the symmetric strain rate tensor 
%     E_ij = (L_ij + L_ji) / 2 while for the skew symmetric rotation rate 
%     tensor W_ij = (L_ij - L_ji) / 2. Note that L = E + W. 
%
%     e and w. Magnitudes of the principal strain rates and vorticity vector
%     describing the rotation around the principal strain axes. These are
%     found by diagonalization of the strain rate tensor:
%         E^p = R^{-1} * E * R ,
%     by finding the Eigenvalues (the diagonal components of E^p) and 
%     Eigenvectors (columns of R) of E. These are sorted such that e(1)
%     = E^p(1,1) is the largest (most positive) strain rate, and e(3) is
%     the smallest (most negative) strain rate. The vorticity vector
%     is then found by rotating the velocity gradient tensor onto this 
%     frame of reference (L^p = R{^-1} * L * R) and extracting values. 
%     The velocity gradient tensor on the frame of the principal axes can
%     be reconstructed from:
%
%               |   e(1)   -w(3)/2   w(2)/2  | 
%         L^p = |  w(3)/2    e(2)   -w(1)/2  |
%               | -w(2)/2   w(1)/2    e(3)   |
%
%     and the input L recovered by L = R * L^p * R^{-1}
% Usage: 
%     [E, W, e, w, R] = MVT_decompose_Lijs(Lij)
%         Given a velocity gradient tensor, a (3, 3) matrix, 
%         return the details described above describing the defomation.
%
%     [Es, Ws, es, ws, R] = MVT_decompose_Lijs(Lijs)
%         Given a list of velocity gradient tensors, a (3, 3, n) matrix, 
%         return lists describing the deformation (tensor number is on the
%         final axis, otherwise as above).
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


function [Es, Ws, e, w, R] = MVT_decompose_Lijs(Lijs)

    s = size(Lijs);
    assert((s(1) == 3), 'First dimension of Lijs must be size 3\n'); 
    assert((s(2) == 3), 'First dimension of Lijs must be size 3\n');
    if length(s) == 3
        % Work through a list of tensors.
        n_t = s(3);  
        Es = zeros(s);
        Ws = zeros(s);
        e = zeros(3, n_t);
        R = zeros(s);
        w = zeros(3, n_t);
        for n=1:n_t
           
            [Es(:,:,n), Ws(:,:,n), e(:,n), R(:,:,n), w(:,n)] ...
                = decompose_serial(Lijs(:,:,n));
        end
    elseif length(s) == 2
        % Only one vel grad tensor
            [Es, Ws, e, R, w] ...
                = decompose_serial(Lijs(:,:));
    else
        error('Argument must be 3x3xn or 3x3')
    end

end

function [E, W, e, pa, vt] = decompose_serial(L)
    % Extract strain rate and rotation rate on the input ref. frame
    [E, W] = decomp(L);
    % Find the magnitude and orientation of the principal strain rate
    [e pa] = principStrain(E);
    e = e'; 
    % Rotate input vel grad tensor to principal axis frame
    Lr = pa'*L*pa;
    % On this principal frame the off-diagonals give the rotation around
    % the principal axes
    vt = [Lr(3,2)*2.0; Lr(1,3)*2.0; Lr(1,2)*2.0];
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