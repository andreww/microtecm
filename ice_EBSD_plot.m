function [Cvrh, rho, eulers, n] = ice_EBSD_plot(filename)

    [eulers, n] = MVT_read_EBSD_txt(filename);
    [C, r] = MS_elasticDB('ice');
    [Cvrh, rho] = MVT_VRH_Eulers(C, r, eulers, n);
    
    MS_plot(Cvrh, rho, 'wtitle', filename, 'fontsize', 11, ...
        'avscontours', 0:0.2:10.16, 'pcontours', 3.8:0.01:3.99, ...
        'polsize', 0.18, 0.16, 2.0, 1.0, 'limitsonpol');
    
end
