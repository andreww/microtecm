% MVT_flinn - Plot Flinn-like diagrams from velocity gradient tensors
% 
% Generate a plot motivated by the classic Flinn diagram from structural
% geology. The basic idea is to extract the principal strains and plot
% e_1/e_2 on the y-axis and e_2/e_3 on the x-axis. Points plotting on the 
% line x=y then correspond to plane strain, points plotting on line x=0 
% correspond to axial extension and points plotting on the line y=0
% correspond to axial compression. This basic idea is extended to cope with
% strain rates and vorticity as follows.
%
% First, the velocity gradient tensor(s) are decomposed into three principle
% strain rates (e), components of the vorticity vector (v), and a matrix 
% representing the orientation of the strain rate ellipsoid. See
% MVT_decompose_Lijs. For the Flinn diagram, points are plotted on a graph
% where y=(1+e(1))/(1+e(2)) and x=(1+e(2))/(1+e(3)), i.e. we plot the strain
% expected after unit time. The vorticity vector is normalised by the second
% invariant of the strain rate tensor such that the vorticity vector for 
% simple shear will be (0.0 1.0 0.0). The magnitude of the vorticity vector
% (the vorticity number) can be represented as the colour of the point 
% on the Flinn diagram, or the vorticity can be plotted separately along
% with a pole figure representing the orientation of the strain rate
% ellipsoid. Exactly what is plotted is set by optional arguments as
% outlined below.
%
% Usage:
%     MVT_flinn(data, ...)  
%         Where data is either a size (3,3,n) array of velocity gradient 
%         tensors or a string representing a filename passed to 
%         MVT_read_Lij_file: Generate a Flinn diagram as described above.
%
%     MVT_flinn(data, 'flinn_only', ...)  
%         Only plot the Flinn diagram, not the vorticity plot or pole 
%         figures (the default)
%
%     MVT_flinn(data, 'colourtime', ...)  
%         Mark the timestep of each velocity gradent tesnsor by a colour 
%         (rather than the default vorticity number).
%
%     MVT_flinn(data, 'max_e', x)  
%         Set the maximum value of the x and y axes in the Flinn plot.
%
%     MVT_flinn(data, 'max_v', x)  
%         Set the maximum value of the x and y axes in the Vorticity plot
%         and the color range if 'colourtime' is not set.
%
% See also: MVT_decompose_Lijs, MVT_strain_invariants, MVT_read_Lij_file

% Copyright (c) 2013 Andrew Walker
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

function MVT_flinn(data, varargin)

      with_time = 0;
      flinn_only = 0;
      max_e = NaN;
      max_v = NaN;
      iarg = 1 ;
      while iarg <= (length(varargin))
         switch lower(varargin{iarg})
             case 'colourtime'
               with_time = 1 ;
               iarg = iarg + 1 ;
             case 'flinn_only'
                 flinn_only = 1;
                 iarg = iarg + 1;
             case 'max_e'
                 max_e = varargin{iarg+1};
                 iarg = iarg + 2;
             case 'max_v'
                 max_v = varargin{iarg+1};
                 iarg = iarg + 2;
             otherwise 
                error(['Unknown option: ' varargin{iarg}]) ;   
         end   
      end 

    % Get hold of the vel grad tensors.
    if ischar(data)
        Ls = MVT_read_Lij_file(data);
        file = data;
    else
        Ls = data;
        file = '';
    end

    [Es, ~, e, v, RR] = MVT_decompose_Lijs(Ls);
    
    % Calculate vorticity number
    [~, II_E, ~] = MVT_strain_invariants(Es);
    vortnum = zeros(size(II_E));
    for i = 1:length(vortnum)
        vortnum(i) = sqrt(v(1,i).^2+v(2,i).^2+v(3,i).^2)/sqrt(2*II_E(i));
        % Also normalise the elements of the vorticity
        v(1,i) = v(1,i)/sqrt(2*II_E(i));
        v(2,i) = v(2,i)/sqrt(2*II_E(i));
        v(3,i) = v(3,i)/sqrt(2*II_E(i));
    end

    % Plot the flinn diagram
    if flinn_only
        figure
    else
        figure('Position',[100 100 500 1000])
        subplot(3,3,1:3)
    end
    [x, y] = flinn_xy(e);
    if isnan(max_e)
        maxplot = max([x y]);
    else
        maxplot = max_e;
    end
    vecsize = length(x);
    if with_time
        scatter(x, y ,20,1:length(x),'filled');
    else
        scatter(x, y ,20,vortnum,'filled');
    end
    hold on
    plot([1 maxplot], [1 maxplot])
    axis([1 maxplot 1 maxplot])
    hold off
    xlabel('1+e_2 / 1+e_3')
    ylabel('1+e_1 / 1+e_2')
    pbaspect('manual');
    pbaspect([1 1 1]);
    if flinn_only
        cba = colorbar('EastOutside');
        if with_time
            set(get(cba,'title'),'string','Time step');
        else
            if ~isnan(max_v)
                caxis([0 max_v])
            end
            set(get(cba,'title'),'string','Vorticity number');
        end
    end
    title(file)

    if ~flinn_only
        subplot(3,3,4:6)
        [x, y] = vort_xy(v, e);
        if isnan(max_e)
            maxplot = max([x y]);
        else
            maxplot = max_v;
        end
        axis([0 maxplot 0 maxplot])
        hold on
        plot([0 maxplot], [1 1], '--')
        if with_time
            scatter(x, y ,20,1:length(x),'filled');
        else
            scatter(x, y ,20,vortnum,'filled');
        end
        xlabel('|v| / II_E projected onto e_1, e_3 plane')
        ylabel('|v_2| / II_E')
        pbaspect('manual');
        pbaspect([1 1 1]);
        cba = colorbar('EastOutside');
        if with_time
            set(get(cba,'title'),'string','Time step');
        else
            if ~isnan(max_v)
                caxis([0 max_v])
            end
            set(get(cba,'title'),'string','Vorticity number');
        end
        
        % Knock up a pole figure...
        % Note that we transpose R here - which is what happens for texture
        % pole figures too - or not...
        e1axis(vecsize) = vector3d(0,0,0);
        e2axis(vecsize) = vector3d(0,0,0);
        e3axis(vecsize) = vector3d(0,0,0);
        for i = 1:vecsize
            e1axis(i) = xvector*RR(1,1,i)+yvector*RR(2,1,i)+zvector*RR(3,1,i);
            e2axis(i) = xvector*RR(1,2,i)+yvector*RR(2,2,i)+zvector*RR(3,2,i);
            e3axis(i) = xvector*RR(1,3,i)+yvector*RR(2,3,i)+zvector*RR(3,3,i);
        end
        cmap=colormap(jet);
        if with_time
            cmap = interp1((1:length(cmap))./(length(cmap)), cmap, ...
                ((1:vecsize)./vecsize), 'linear', 'extrap');
        else
            cmap = zeros(vecsize, 3);
        end
        subplot(3,3,7);
        for i = 1:vecsize
            plot(e1axis(i),'MarkerSize',4,'MarkerFaceColor', cmap(i,:), 'antipodal', 'axis', gca);
            hold on;
        end
        title('e1');
        subplot(3,3,8);
        for i = 1:vecsize
            plot(e2axis(i),'MarkerSize',4,'MarkerFaceColor', cmap(i,:), 'antipodal', 'axis', gca);
            hold on;
        end
        title('e2');
        subplot(3,3,9);
        for i = 1:vecsize
            plot(e3axis(i),'MarkerSize',4,'MarkerFaceColor', cmap(i,:), 'antipodal', 'axis', gca);
            hold on;
        end
        title('e3');
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
        y = abs(v(2,:));
        % Projection onto e(1)-e(3) plane
        x = sqrt(v(1,:).^2.0 + v(3,:).^2.0);
    elseif length(size(e)) == 1
        y = abs(v(2));
        x = sqrt(v(1).^2.0 + v(3).^2.0);
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
                                           