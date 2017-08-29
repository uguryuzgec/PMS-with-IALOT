%
% Improved Ant Lion Optimization Algorithm
% by Haydar Kilic & Ugur Yuzgec

%% Initialization

% Empty AntLion Structure
empty_antlion.Position=[];
empty_ant.Position=[];
empty_antlion.Cost=[];
empty_ant.Cost=[];
empty_antlion.Sol=[];
empty_ant.Sol=[];
sorted_antlion_fitness=zeros(1,nPop);
% Initialize Population Array
antlion=repmat(empty_antlion,nPop,1);
ant=repmat(empty_ant,nPop,1);
% Initialize Best Solution Ever Found
BestSol.Cost=inf;

% Create Initial Antlion
for i=1:nPop
%    antlion(i).Position=unifrnd(VarMin,VarMax,VarSize);
    antlion(i).Position=general_pop(i).Position;
    [~, p] = sort(antlion(i).Position);
    [antlion(i).Cost, antlion(i).Sol]=CostFunction(p);
   
   if antlion(i).Cost<=BestSol.Cost
       BestSol=antlion(i);
   end
end

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);
NNN=MaxIt*0.2; 
%% Improved Antlion Algorithm Main Loop

for it=1:MaxIt
    for i=1:nPop
        sorted_antlion_fitness(i)=antlion(i).Cost;
    end
    X = [0 cumsum(2*(rand(NNN,1)>0.5)-1)'];
    Y = [0 cumsum(2*(rand(NNN,1)>0.5)-1)'];
    for i=1:nPop,
        % Select ant lions based on their fitness (the better anlion the higher chance of catching ant)
        Rolette_index=RouletteWheelSelection_ALO(abs(1./sorted_antlion_fitness));
        if Rolette_index==-1  
            Rolette_index=1;
        end
        
      % RA is the random walk around the selected antlion by rolette wheel
        RA=Random_walk_NEW(model.nVar,MaxIt,VarMin,VarMax,antlion(Rolette_index).Position,it,X);
        
        % RA is the random walk around the elite (best antlion so far)
        RE=Random_walk_NEW(model.nVar,MaxIt,VarMin,VarMax,BestSol.Position,it,Y);
        
        ant(i).Position = (RA(randi(NNN,1,1),:)+RE(randi(NNN,1,1),:))/2;
        % Boundar checking (bring back the antlions of ants inside search
        % space if they go beyoud the boundaries
       
            for j=1:model.nVar
                if (ant(i).Position(j)>VarMax) || (ant(i).Position(j)<VarMin)
                     ant(i).Position(j)=unifrnd(VarMin,VarMax,1);
                end
            end
       
        % Evaluation
        [~, p] = sort(ant(i).Position);        
        [ant(i).Cost, ant(i).Sol] = CostFunction(p);
         
        % Selection
  
        if(ant(i).Cost<antlion(i).Cost)
            antlion(i)=ant(i);
            if(ant(i).Cost<BestSol.Cost)
                 BestSol=ant(i);
            end
        end
        
        % Perform Mutation
        for k=1:nMutation
            newsol.Position = Mutate(antlion(i).Position);
            [~, p] = sort(newsol.Position);
            [newsol.Cost, newsol.Sol]=CostFunction(p);
            if newsol.Cost <= antlion(i).Cost
                antlion(i) = newsol;
                if newsol.Cost<=BestSol.Cost
                    BestSol=newsol;
                end
            end
        end
    end %  for i=1:nPop...
     
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
       
    % Show Iteration Information
     if (rem(it,refresh) == 0)
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
        figure(6);
        PlotSolution(BestSol.Sol, model);
        str = sprintf('Parallel Machine Scheduling with IALO : %.3f',BestSol.Cost');
        title(str);
        pause(0.01);
     end
  
end %for it=1:MaxIt...
