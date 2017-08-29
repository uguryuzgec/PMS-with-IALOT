%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPAP104
% Project Title: Quadratic Assignment Problem using Genetic Algorithm
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function [y1, y2]=PermutationCrossover(x1,x2)

    nVar=numel(x1);
    
    c=randi([1 nVar-1]);
    
    x11=x1(1:c);
    x12=x1(c+1:end);
    
    x21=x2(1:c);
    x22=x2(c+1:end);
    
    r1=intersect(x11,x22);
    r2=intersect(x21,x12);

    x11(ismember(x11,r1))=r2;
    x21(ismember(x21,r2))=r1;
    
    y1=[x11 x22];
    y2=[x21 x12];

end