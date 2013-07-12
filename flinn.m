% Plot a flinn type diagram thing...

function flinn(file)

    Ls = MVT_read_Lij_file(file);
    [E, W, e, w, R] = MVT_decompose_Lijs(Ls);
    y=log(1+e(1,:)./1+e(2,:));
    x=abs(log(1+e(2,:)./1+e(3,:))); % Plot on +ve x axis (e(3) is always -ve)
    col = 1-abs([w(1,:)./(2*e(1,:)); ...
                 w(2,:)./(2*e(1,:)); ...
                 w(3,:)./(2*e(1,:))])'; % Simple shear is [010]. Hope
                                           % we don't have supersimple
                                           % shear Pure shear is white
    scatter(x,y,20,1:101,'filled');
    colorbar
    hold
    plot([0 4.0E-3], [0 4.0E-3])
    axis([0 4.0E-3 0 4.0E-3])
    pause
    figure
    scatter3(col(:,1), col(:,2), col(:,3), 20, 1:101, 'filled')
    pause
    rgbplot(col);
end
                                           
                                           