% Plot a flinn type diagram thing...

function flinn(file)

    Ls = MVT_read_Lij_file(file);
    [E, W, e, w, R] = MVT_decompose_Lijs(Ls);
    y=log(1+e(1,:)./1+e(2,:));
    x=-log(1+e(2,:)./1+e(3,:)); % Plot on +ve x axis (e(3) is always -ve)
    col = 1-abs([w(1,:)./(2*e(1,:)); ...
                 w(2,:)./(2*e(1,:)); ...
                 w(3,:)./(2*e(1,:))])' % Simple shear is [010]. Hope
                                           % we don't have supersimple
                                           % shear Pure shear is white
    scatter(x,y,20,col,'filled');
    pause
    rgbplot(col);
end
                                           
                                           