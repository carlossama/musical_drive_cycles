function Y = discreteCosineXfer(x)
if size(x, 1) == 1
    x = x';
end
sig = x;
l = 1:length(sig);
n = l'; 

Y_k = zeros(length(sig),1);
for k = 1:length(Y_k)

    if k == 1
        cd = ones(size(sig));
    else
        cd = zeros(size(sig));
    end

    Y_k(k,1) = sqrt(2/length(sig)) * sum(sig.* (1./ sqrt(1 + cd)).* (cos( (pi / (2 * length(sig))) * (k - 1) * (2 * n - 1))));
end

Y = Y_k;
end
