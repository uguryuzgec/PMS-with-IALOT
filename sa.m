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

%% Initialization
empty_x.Position=[];
empty_x.Cost=[];
empty_x.Sol=[];

% Initialize Population Array
x=repmat(empty_x,nPop,1);
% Initialize Best Solution Ever Found
BestSol.Cost=inf;

% Create Initial Antlion
for i=1:nPop
    [~, index]=sort(general_pop(i).Position);
    x(i).Position=index;
    [x(i).Cost, x(i).Sol]=CostFunction(x(i).Position);

   if x(i).Cost<=BestSol.Cost
       BestSol=x(i);
   end
end

% Create Initial Solution
% % % x.Position=CreateRandomSolution(model);

% Update Best Solution Ever Found
% % % BestSol=x;

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Set Initial Temperature
T=T0;


%% SA Main Loop

for it=1:MaxIt
      for i=1:nPop
        
        % Create Neighbor
        xnew.Position=CreateNeighbor(x(i).Position);
        [xnew.Cost, xnew.Sol]=CostFunction(xnew.Position);
        
        if xnew.Cost<=x(i).Cost
            % xnew is better, so it is accepted
            x(i)=xnew;
            
        else
            % xnew is not better, so it is accepted conditionally
            delta=xnew.Cost-x(i).Cost;
            p=exp(-delta/T);
            
            if rand<=p
                x(i)=xnew;
            end
            
        end
        
        % Update Best Solution
        if x(i).Cost<=BestSol.Cost
            BestSol=x(i);
        end
        
      end %  for i=1:nPop...
    
    % Store Best Cost
    BestCost(it)=BestSol.Cost;
    
     % Show Iteration Information
     if (rem(it,refresh) == 0)
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
        figure(1);
        PlotSolution(BestSol.Sol, model);
        str = sprintf('Parallel Machine Scheduling Problem with SA : %.3f',BestSol.Cost');
        title(str);
        pause(0.01);
     end
       
    % Reduce Temperature
    T=alpha_SA*T;
       
end
