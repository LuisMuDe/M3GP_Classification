function [cntrd,covM] = classCentroid(wholetree,data,totalClasses)

[rows,columns] = size(data);
classSorted = sortrows(data,columns);
Y = classSorted(:,columns);
unqClasses = unique(Y);
global globalDim;

Z = zeros(rows,globalDim);

for t = 1:globalDim
	if globalDim==1
		Trn = tree2str(wholetree);    
	else
		Trn = tree2str(wholetree.kids{t});
	end 
	for i=columns-1:-1:1
        Trn=strrep(Trn,strcat('X',num2str(i)),strcat('classSorted(:,',num2str(i),')'));		
    end
    try
        Z(:,t)=eval(Trn);		
    catch 
        % because of the "nesting 32" error of matlab
		if globalDim==1
			Z(:,t)=str2num(evaluate_tree(wholetree,classSorted));			
		else
			Z(:,t)=str2num(evaluate_tree(wholetree.kids{t},classSorted));
		end  
	end
    if length(Z(:,t))<rows
       Z(:,t)=Z(:,t)*ones(rows,1);
    end
end  

frqClasses = histc(Y, unqClasses);
cntrd = zeros(totalClasses,globalDim);
covM = zeros(globalDim,globalDim,totalClasses);
offset = 1;

for i = 1:totalClasses
    cntrd(i,:) = mean(Z(offset:offset-1+frqClasses(i),:));
    covM(:,:,i) = cov(Z(offset:offset-1+frqClasses(i),:));	
    offset = offset + frqClasses(i);
end
