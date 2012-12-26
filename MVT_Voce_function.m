% MVT_Voce_function - Evaluate CRSS with strain (Voce hardening) 
% 
% Usage: 
%     [ tau_hat ] = MVT_Voce_function(tau_0, tau_1, theta_0, ...
%                                        theta_1, Gamma)
% 
%         Evauate CRSS (tau_hat) for a slip system in a deformed crystal
%         using the Voce hardening law. Parameters are:
%         * tau_0: initial CRSS of the slip system.
%         * tau_1: extra contribution to CRSS at high strain such that
%         (tau_0+tau_1) is the back-extrapolated CRSS. 
%         * theta_0: initial hardening rate.
%         * theta_1: asymptotic hardening rate.
%         * Gamma: sum of the total shear strain for all slip systems in
%         this grain. Can be scalar or array.
%
% Notes: The functional form is given in section 1-6-1 of the VPSC manual.
%     This function only accounts for the simple form without use of the
%     coupling oefficents (h) and the user is expected to evaulate Gamma.
%     Reproducing the figure is just a case of doing:
%     plot(MVT_Voce_function([0:0.1:3], 1.0, 1.0, 5, 0.2, [0:0.1:3]))
%

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

function [ tau_hat ] = MVT_Voce_function(tau_0, tau_1, theta_0, ...
    theta_1, Gamma)

    if length(Gamma) == 1
        tau_hat = tau_0 + (tau_1 + theta_1*Gamma) * ...
            (1-exp(-Gamma*abs(theta_0/tau_1)));
    else
        tau_hat = zeros(size(Gamma));
        for i = 1:length(Gamma)
            tau_hat(i) = MVT_Voce_function(tau_0, tau_1, theta_0, ...
                theta_1, Gamma(i));
        end
    end
            
end