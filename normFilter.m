function Y = normFilter(X, limit, correlation)

    if correlation > 0.99999
        warning(['using correlation of 0.99999'])
        correlation = 0.99999;
    end
    

    [XX,ind] = sort(abs(X),'descend');
    i = 1;
    while norm(X(ind(1:i)))/norm(X) < correlation
       i = i + 1;
    end
    if i > limit
        i = limit;
    end
    
    needed = i;
    
    X(ind(needed+1:end)) = 0;
    
%     if needed < 10
%     disp(X(ind(1:needed)))
%     else
%         disp(needed)
%     end
   
    Y = X;
    
end