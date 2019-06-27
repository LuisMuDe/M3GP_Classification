function ret=evalutate_tree(tree,X)
%EVALUATE_TREE    Alternative to using 'eval' in 'regfitness' in GPLAB.
%   EVALUATE_TREE(TREE,X) evaluates a GPLAB tree when the "nesting 32"
%   error is issued by the 'eval' function in the 'regfitness.m' function.
%   It returns the same as 'eval' would. This is only needed in the most
%   recent MATLAB releases.
%
%   See also REGFITNESS
%
%   Created (2007) by Marco Medori (marco.medori@poste.it) and Bruno Morelli
%   This file is part of the GPLAB Toolbox

    [tmp ll]=size(X);
    op=tree.op;
    if isempty(tree.kids)
        for i=1:ll
            op=strrep(op,strcat('X',num2str(i)),strcat('X(:,',num2str(i),')'));
        end       
        ret=op;
        return    
    end
    op=strcat(tree.op,'(');
    ll=length(tree.kids);
    for i=1:ll
        argument=evaluate_tree(tree.kids{1,i},X);
        op=strcat(op,argument);
        if i<ll
            op=strcat(op,',');
        end
    end
    op=strcat(op,')');

    try
       ret=mat2str(eval(op));
         %drawtree(tree);
    catch 
         drawtree(tree);
        % X
         error('LMD: something is wrong on eval')
    end

    
return