function ice_VPSC_phasevels_plot(filename)
    
    [alleulers, ns] = MVT_read_VPSC_file(filename);
    [C, r] = MS_elasticDB('ice');

    if iscell(alleulers)
        for i = 1:length(alleulers)
            eulers = alleulers{i};
            n = ns{i};
            [Cvrh, rho] = MVT_VRH_Eulers(C, r, eulers, n);
            Cvrh = MS_rot3(Cvrh, 0.0, 90.0, 0.0);
            MS_plot(Cvrh, rho, 'wtitle', filename, 'fontsize', 11, ...
               'avscontours', 0:0.05:6.9, 'pcontours', 3.8:0.001:3.9, ...
               'polsize', 0.18, 0.16, 2.0, 1.0, 'limitsonpol');
        end
    else
        eulers = alleulers;
        n = ns;
        [Cvrh, rho] = MVT_VRH_Eulers(C, r, eulers, n);
        Cvrh = MS_rot3(Cvrh, 0.0, 90.0, 0.0);
        MS_plot(Cvrh, rho, 'wtitle', filename, 'fontsize', 11, ...
            'avscontours', 0:0.05:6.0, 'pcontours', 3.8:0.001:3.9, ...
            'polsize', 0.18, 0.16, 2.0, 1.0, 'limitsonpol');

    end
    
end