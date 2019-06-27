function indBest = PrunningTheBestRandom(indBest,data,params)
%%The best individual of the population is going to be prune 
%to eliminate dimension that are not helping the classification

%% The pruning process
X=data.example;
Y=data.result; 
load('train_terminals.mat'); 

ind = indBest;

%If the tree is just one dimension pruning is not necessary 
if (length(ind.tree.kids) ~= 1)
        Dimensions = length(ind.tree.kids);
        IndPruning = ind;
        %Random list of branches to prune
        BranchToTest = randperm(Dimensions);
    for branch = 1 : Dimensions
        if (length(ind.tree.kids) ~= 1)
        clear Z covMM unqClasses totalClasses frqClasses distMatrix meanOfClassCluster; 
            globalDim = Dimensions-1;
            samples = length(X);

            %unqClasses = unique(Y(1:samples));
            unqClasses = (1:params.ProblemClasses)';
            %totalClasses = length(unqClasses);
            totalClasses = params.ProblemClasses;
            frqClasses = histc(Y(1:samples), unqClasses);
            Z = zeros(samples,globalDim);
            %Generates the new Z, taking out one dimension
            for t = 1:globalDim
                %If the branch is the one on the random list selected for
                %this turn it will be ignore
                if t~= BranchToTest(branch)
                            Trn = tree2str(ind.tree.kids{t});
                    %LMD Z improvement for a faster gplab        
                    %     for i=params.numvars:-1:1
                    %         Trn=strrep(Trn,strcat('X',num2str(i)),strcat('X(:,',num2str(i),')'));
                    %     end

                        try
                            Z(:,t)=eval(Trn);		
                        catch 
                                % because of the "nesting 32" error of matlab
                                % drawtree(ind.tree);
                                % drawtree(ind.tree.kids{t});
                                Z(:,t)=str2num(evaluate_tree(ind.tree.kids{t},X));
                                 error('LMD: something is wrong with the fitness function')
                        end
                        if length(Z(:,t))<samples
                           Z(:,t)=Z(:,t)*ones(samples,1);
                        end
                end
            end    
            %Testing does not require pruning
%             if  ban == 1  %testing 
% 
%               error('LMD: something is wrong with the fitness function: Testing does not require pruning')
%                     %%% [MD] Mahalanobis Distance
%                 distMatrix = zeros(samples,totalClasses);
%                 offset = 1;
% 
%                 for i = 1:totalClasses
%                     covM = ind.covM(:,:,i);
%                     [~,pd] = chol(covM);
%                     meanOfClassCluster(i,:) = ind.meanOfClassCluster(i,:);
%                     if (pd)  || (rcond(covM) < 1e-10) % check if the symmetric covariance matrix is "positive semidefinite" OR  "nearly singular"
%                         distMatrix(:,i) = mypdist(Z,meanOfClassCluster(i,:))';
%                     else
%                         distMatrix(:,i) = mypdist(Z,meanOfClassCluster(i,:),'mahalanobis',covM)';           
%                     end
%                     offset = offset + frqClasses(i);
%                 end
%                 %%% Mahalanobis Distance


%             else    %or else is training 
                %%% [MD] Mahalanobis Distance
                distMatrix = zeros(samples,totalClasses);
                offset = 1;

                for i = 1:totalClasses
                    covM = cov(Z(offset:offset-1+frqClasses(i),:));
                    covMM(:,:,i) = covM;
                    [~,pd] = chol(covM);
                    meanOfClassCluster(i,:) = mean(Z(offset:offset-1+frqClasses(i),:));
                    if (pd)  || (rcond(covM) < 1e-10) % check if the symmetric covariance matrix is "positive semidefinite" OR  "nearly singular"
                        distMatrix(:,i) = mypdist(Z,meanOfClassCluster(i,:))';
                    else
                        distMatrix(:,i) = mypdist(Z,meanOfClassCluster(i,:),'mahalanobis',covM)';           
                    end
                    offset = offset + frqClasses(i);
                end
                %%% Mahalanobis Distance
                IndPruning.Z= Z;
                IndPruning.covM  = covMM;
                IndPruning.meanOfClassCluster = meanOfClassCluster;
%             end

            %%% [PA] Percentage Accuracy as the maximizing objective function
            [~,predctdClass] = min(distMatrix,[],2);
            allAccuracy = length(find(predctdClass==Y(1:samples)))*100/samples; 
            IndPruning.fitness = allAccuracy;

            if IndPruning.fitness >= ind.fitness
                    %The tree that will receive the good dimensions 
                    nind.tree=maketreeMutlvlup(2,{'rand' 0},[0],0,'1',0,1,(Dimensions-1));
                    
                    %eliminates the extra dimension that is not helping the fitness
                        n1=1;
                        for n = 1: (Dimensions-1) % copy the old dimensions to the new tree with one dimension down
                            %If the branch is the one to be remove, do
                            %nothing and just by pass the branch.
                            if (BranchToTest(branch)==n)
                                n1=n1+1;
                            end
                            x1=nind.tree.kids{n}.nodeid; 
                            x2=ind.tree.kids{n1}.nodeid; 
                            [nind.tree,ind.tree]=swapnodes(nind.tree,ind.tree,x1,x2);
                            n1=n1+1;
                        end
                        %The new tree with one dimension less is assign to the individual
                        ind.tree = nind.tree;
                        ind.Z =	IndPruning.Z;
                        ind.covM = IndPruning.covM ;
                        ind.meanOfClassCluster = IndPruning.meanOfClassCluster;
                        ind.str=tree2str(ind.tree);
                        ind.nodes=ind.tree.nodes;
                        ind.fitness = IndPruning.fitness;
                        branch = 1 ;
                        Dimensions = length(ind.tree.kids);
            end
        end
            %clear Z covMM unqClasses totalClasses frqClasses distMatrix meanOfClassCluster; 

    end

end

if (length(indBest.tree.kids) > length(ind.tree.kids) )
    ind.Pruned = 'True';
end
indBest=ind;

