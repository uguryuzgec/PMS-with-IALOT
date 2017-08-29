%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPAP107
% Project Title: Parallel Machine Scheduling using Simulated Annealing (SA)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function PlotSolution(sol,model)

    I=model.I;
    J=model.J;
    
    L=sol.L;
    ST=sol.ST;
    FT=sol.FT;

    H=1;
    h=0.75;
    
    Colors=hsv(I);
    
    for j=1:J
        y1=(j-1)*H;
        y2=y1+h;
        for i=L{j}
            
            x1=ST(i);
            x2=FT(i);
            
            X=[x1 x2 x2 x1];
            Y=[y1 y1 y2 y2];
            
            C=Colors(i,:);
            C=(C+[1 1 1])/2;
            
            fill(X,Y,C);
            hold on;
            
            xm=(x1+x2)/2;
            ym=(y1+y2)/2;
            text(xm,ym,num2str(i),...
                'FontWeight','bold',...
                'HorizontalAlignment','center',...
                'VerticalAlignment','middle');
            
        end
    end
    
    Cmax=sol.Cmax;
    plot([Cmax Cmax],[0 J*H],'r:','LineWidth',2);
    text(Cmax,J*H,['C_{max} = ' num2str(Cmax)],...
        'FontWeight','bold',...
        'HorizontalAlignment','right',...
        'VerticalAlignment','top',...
        'Color','red');
    
    grid on;
    
    hold off;

end