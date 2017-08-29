%
% Ant Lion Optimization Algorithm
%

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

for i=1:nPop
        sorted_antlion_fitness(i)=antlion(i).Cost;
end
% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

%% Antlion Algorithm Main Loop

for it=1:MaxIt
    
    for i=1:nPop,
        % Select ant lions based on their fitness (the better anlion the higher chance of catching ant)
        Rolette_index=RouletteWheelSelection_ALO(1./sorted_antlion_fitness);
        if Rolette_index==-1  
            Rolette_index=1;
        end
        
      % RA is the random walk around the selected antlion by rolette wheel
        RA=Random_walk_around_antlion(model.nVar,MaxIt,VarMin,VarMax, antlion(Rolette_index).Position,it);
        
        % RA is the random walk around the elite (best antlion so far)
        RE=Random_walk_around_antlion(model.nVar,MaxIt,VarMin,VarMax, BestSol.Position,it);
        
        ant(i).Position = (RA(it,:)+RE(it,:))/2; % Equation (2.13) in the paper   
        % Boundar checking (bring back the antlions of ants inside search
        % space if they go beyoud the boundaries
        ant(i).Position = max(ant(i).Position,VarMin);
        ant(i).Position = min(ant(i).Position,VarMax);
        % Evaluation
         [~, p] = sort(ant(i).Position);
         [ant(i).Cost, ant(i).Sol] = CostFunction(p);
        
        % Perform Mutation
        for k=1:nMutation
            newsol.Position = Mutate(antlion(i).Position);
            [~, p] = sort(newsol.Position);
            [newsol.Cost, newsol.Sol]=CostFunction(p);
            if newsol.Cost <= antlion(i).Cost
                antlion(i) = newsol;
            end
        end
    end
    
    for i=1:nPop
        antlion(i).Cost = sorted_antlion_fitness(i); % ??? Birebir orjinal kod olsun diye koyuldu...
    end
    % Merge
    double_population=[antlion; ant];  
    
    % Sort
    [~, SortOrder]=sort([double_population.Cost]);
    double_population=double_population(SortOrder);
    
    % Truncate
    antlion=double_population(1:nPop);
    
     % Update Personal Best
     if antlion(1).Cost<=BestSol.Cost
       BestSol=antlion(1);
     end
    % Keep the elite in the population
    antlion(1)=BestSol;
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
       
    % Show Iteration Information
     if (rem(it,refresh) == 0)
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
        figure(5);
        PlotSolution(BestSol.Sol, model);
        str = sprintf('Parallel Machine Scheduling with ALO : %.3f',BestSol.Cost');
        title(str);
        pause(0.01);
     end
  
end %for it=1:MaxIt...
