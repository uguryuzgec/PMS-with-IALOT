%
% Project Title: Parallel Machine Scheduling using Particle Swarm Optimization
% Publisher: Yarpiz (www.yarpiz.com)
% by Yuzgec

%% Initialization

empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Sol=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Sol=[];

particle=repmat(empty_particle,nPop,1);

GlobalBest.Cost=inf;

for i=1:nPop
    
    % Initialize Position
%     particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
     particle(i).Position=general_pop(i).Position;

    
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    [~, p] = sort(particle(i).Position);
    [particle(i).Cost, particle(i).Sol]=CostFunction(p);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Sol=particle(i).Sol;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost
        GlobalBest=particle(i).Best;
    end
    
end

BestCost=zeros(MaxIt,1);

%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        [~, p] = sort(particle(i).Position);
        [particle(i).Cost, particle(i).Sol] = CostFunction(p);
        
        % Perform Mutation
        for j=1:nParticleMutation
            NewParticle = particle(i);
            NewParticle.Position = Mutate(particle(i).Position);
            [~, p] = sort(NewParticle.Position);
            [NewParticle.Cost, NewParticle.Sol] = CostFunction(p);
            if NewParticle.Cost <= particle(i).Cost
                particle(i) = NewParticle;
            end
        end
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Sol=particle(i).Sol;
            
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                GlobalBest=particle(i).Best;
            end
            
        end
        
    end %  for i=1:nPop...
    
    % Perform Mutation on Global Best
    for i=1:nGlobalBestMutation
        NewParticle = GlobalBest;
        NewParticle.Position = Mutate(GlobalBest.Position);
        [~, p] = sort(NewParticle.Position);
        [NewParticle.Cost, NewParticle.Sol] = CostFunction(p);
        if NewParticle.Cost <= GlobalBest.Cost
            GlobalBest = NewParticle;
        end
    end
        
    BestCost(it)=GlobalBest.Cost;
    
    if (rem(it,refresh) == 0)
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
        figure(3);
        PlotSolution(GlobalBest.Sol, model);
        str = sprintf('Parallel Machine Scheduling with PSO : %.3f',GlobalBest.Cost');
        title(str);
        pause(0.01);
    end
    w=w*wdamp;
       
end % for it=1:MaxIt...

BestSol = GlobalBest;
