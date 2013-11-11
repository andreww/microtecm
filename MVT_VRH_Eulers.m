function [Cout, rho_out] = MVT_VRH_Eulers(C, rho, eulers, n)

    Cs = zeros(6,6,n);
    rhos = zeros(1,n);
    for i = 1:n
       Cs(:,:,i) = C(:,:);
       rhos(i) = rho;
    end

    Cs = MS_rotEuler(Cs, eulers(1,:)', eulers(2,:)', eulers(3,:)', ...
        'sense', 'passive');
    
    [Cout, rho_out]=MS_VRH(ones(n,1), Cs, rhos);
        
end