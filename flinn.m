% Plot a flinn type diagram thing...

function flinn(file)


    Ls = MVT_read_Lij_file(file);
    [~, ~, e, v, RR] = MVT_decompose_Lijs(Ls);
    
    % Build some 'reference' points assuming maximum L in
    % input file (to fit on graph)
    lr = max(max(max(abs(Ls))));
    % Simple shear
    l_ss = [0 2*lr 0; 0 0 0; 0 0 0];
    [~, ~, e_ss, v_ss, ~] = MVT_decompose_Lijs(l_ss);
    %pure shear
    l_ps = [lr 0 0; 0 0 0; 0 0 -lr];
    [~, ~, e_ps, v_ps, ~] = MVT_decompose_Lijs(l_ps);
    % Axial compression with rotation around e(3)
    l_ac = [lr*0.5 lr*0.5 0; -lr*0.5 lr*0.5 0; 0 0 -lr];
    [~, ~, e_ac, v_ac, ~] = MVT_decompose_Lijs(l_ac);
    % Axial extension with rotation around e(2)
    l_ae = [lr 0.0 lr*0.5; 0.0 -lr*0.5 0.0; -lr*0.5 0.0 -lr*0.5];
    [~, ~, e_ae, v_ae, ~] = MVT_decompose_Lijs(l_ae);
    
    % Plot the flinn diagram
    figure
    subplot(2,1,1)
    [x, y] = flinn_xy(e);
    maxplot = max([x y]);
    vecsize = length(x);
    scatter(x, y ,20,1:length(x),'filled');
    hold on
    plot([1 maxplot], [1 maxplot])
    axis([1 maxplot 1 maxplot])
    [x, y] = flinn_xy(e_ss);
    scatter(x, y, 18, 'k', 's', 'filled');
    [x, y] = flinn_xy(e_ps);
    scatter(x, y ,22, 'r', 's');
    [x, y] = flinn_xy(e_ac);
    scatter(x, y ,18, 'r', 's', 'filled');
    [x, y] = flinn_xy(e_ae);
    scatter(x, y ,22, 'k', 's');
    hold off
    legend(file, 'simple shear', 'pure shear', ...
        'compression', 'extension');
    colorbar
    xlabel('1+e_2 / 1+e_3')
    ylabel('1+e_1 / 1+e_2')
    
    subplot(2,1,2) 
    [x, y] = vort_xy(v, e);
    scatter(x, y ,20,1:length(x),'filled');
    hold on
    [x, y] = vort_xy(v_ss, e_ss);
    scatter(x, y, 18, 'k', 's', 'filled');
    [x, y] = vort_xy(v_ps, e_ps);
    scatter(x, y ,22, 'r', 's');
    [x, y] = vort_xy(v_ac, e_ac);
    scatter(x, y ,18, 'r', 's', 'filled');
    [x, y] = vort_xy(v_ae, e_ae);
    scatter(x, y ,22, 'k', 's')
    hold off
    legend(file, 'simple shear', 'pure shear', ...
        'compression', 'extension');
    colorbar
    xlabel('|v| / e_2 projected onto e_1, e_3 plane')
    ylabel('|v_2| / e_1')
    
    % Knock up a pole figure...
    % Note that we transpose R here - which is what happens for texture
    % pole figures too
    e1axis(vecsize) = vector3d(0,0,0);
    e2axis(vecsize) = vector3d(0,0,0);
    e3axis(vecsize) = vector3d(0,0,0);
    for i = 1:vecsize
        e1axis(i) = xvector*RR(1,1,i)+yvector*RR(1,2,i)+zvector*RR(1,3,i);
        e2axis(i) = xvector*RR(2,1,i)+yvector*RR(2,2,i)+zvector*RR(2,3,i);
        e3axis(i) = xvector*RR(3,1,i)+yvector*RR(3,2,i)+zvector*RR(3,3,i);
    end
    cmap=colormap(jet);
    cmap = interp1((1:length(cmap))./(length(cmap)), cmap, (1:vecsize)./vecsize);
    cmap(1,:) = 0.0;
    cmap(1,3) = 0.5200;
    figure;
    for i = 1:vecsize
        plot(e1axis(i),'MarkerSize',5,'MarkerFaceColor', cmap(i,:));%, 'antipodal');
        hold on;
    end
    figure;
    for i = 1:vecsize
        plot(e2axis(i),'MarkerSize',5,'MarkerFaceColor', cmap(i,:));%, 'antipodal');
        hold on;
    end
    figure;
    for i = 1:vecsize
        plot(e3axis(i),'MarkerSize',5,'MarkerFaceColor', cmap(i,:));%, 'antipodal');
        hold on;
    end
end

function [x, y] = flinn_xy(e)

    % Always assume that e is small compared to 1. Should be 
    % or the strain rate is huge in a single time step.
    % X and y for data from file for flinn
    % FIXME: should we take logs?
    if length(size(e)) == 2
        y=(1+e(1,:))./(1+e(2,:));
        x=(1+e(2,:))./(1+e(3,:));
    elseif length(size(e)) == 1
        y=(1+e(1))./(1+e(2));
        x=(1+e(2))./(1+e(3));
    else
        error('Argument must be 3x3xn or 3x3')
    end
end

function [x, y] = vort_xy(v, e)

    % Normalise such that simple shear rotation is [0 1 0]
    % Don't care about direction...
    % NOTE: This returns NaN for strain free rotation.
     
    if length(size(e)) == 2
        % Projection onto e(2) direction. For simple shear this is 1.0
        % For pure shear this is zero.
        y = abs(v(2,:)./(2*e(1,:)));
        % Projection onto e(1)-e(3) plane
        x = sqrt((v(1,:)./(2*e(1,:))).^2.0 + (v(3,:)./(2*e(1,:))).^2.0);
    elseif length(size(e)) == 1
        y = abs(v(2)./(2*e(1)));
        x = sqrt((v(1)./(2*e(1))).^2.0 + (v(3)./(2*e(1))).^2.0);
    else
        error('Argument must be 3x3xn or 3x3')
    end  
end
     
%     
%     figure
%     scatter3(col(:,1), col(:,2), col(:,3), 20, 1:101, 'filled')
%     pause
%     figure
%     rgbplot(col);
%     pause
%     figure
%     y = abs(col(:,2));
%     x = abs(col(:,1))-abs(col(:,3));
%     scatter(x, y, 20, 1:101, 'filled')
% end
%                                            
                                           