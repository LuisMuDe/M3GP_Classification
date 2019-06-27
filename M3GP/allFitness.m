function [ind state] = allFitness(ind,params,data,state,varsvals,ban)
X=data.example;
Y=data.result;
%drawtree(ind.tree);

%LMD z method to run faster fitness evaluation 
if ban == 1
   load('test_terminals.mat'); 
else
    load('train_terminals.mat'); 
end


globalDim = length(ind.tree.kids);
samples = length(X);

%unqClasses = unique(Y(1:samples));
unqClasses = (1:params.ProblemClasses)';


%If the data set does not have all classes the classification for the
%missing class is lost 
%totalClasses = length(unqClasses);
totalClasses = params.ProblemClasses;
frqClasses = histc(Y(1:samples), unqClasses);
Z = zeros(samples,globalDim);

for t = 1:globalDim
		Trn = tree2str(ind.tree.kids{t});
%LMD Z improvement for a faster gplab        
%     for i=params.numvars:-1:1
%         Trn=strrep(Trn,strcat('X',num2str(i)),strcat('X(:,',num2str(i),')'));
%     end

    try
        Z(:,t)=eval(Trn);		
    catch 
            % because of the "nesting 32" error of matlab
 			Z(:,t)=str2num(evaluate_tree(ind.tree.kids{t},X));
            % error('LMD: something is wrong with the fitness function')
    end
    if length(Z(:,t))<samples
       Z(:,t)=Z(:,t)*ones(samples,1);
    end
end    


if  ban == 1  %testing 
        %%% [MD] Mahalanobis Distance
    distMatrix = zeros(samples,totalClasses);
    offset = 1;

    for i = 1:totalClasses
        covM = ind.covM(:,:,i);
        [~,pd] = chol(covM);
        meanOfClassCluster(i,:) = ind.meanOfClassCluster(i,:);
        if (pd)  || (rcond(covM) < 1e-10) % check if the symmetric covariance matrix is "positive semidefinite" OR  "nearly singular"
            distMatrix(:,i) = mypdist(Z,meanOfClassCluster(i,:))';
        else
            distMatrix(:,i) = mypdist(Z,meanOfClassCluster(i,:),'mahalanobis',covM)';           
        end
        offset = offset + frqClasses(i);
    end
    %%% Mahalanobis Distance
    
    
else    %or else is training 
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
    ind.Z= Z;
    ind.covM = covMM;
    ind.meanOfClassCluster = meanOfClassCluster;
end

%%% [PA] Percentage Accuracy as the maximizing objective function
[~,predctdClass] = min(distMatrix,[],2);
allAccuracy = length(find(predctdClass==Y(1:samples)))*100/samples; 
ind.fitness = allAccuracy;

