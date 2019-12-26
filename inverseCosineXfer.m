function Y = inverseCosineXfer(X, sig)

k = 1:length(X); k = k';
l = 1:length(sig);
k_f = X;
sig_f = zeros(size(sig));
count = 0;
for n = l
    count = count + 1;
    cd = zeros(size(k_f));
    cd(1) = 1;

    sig_f(count,1) = sqrt(2/length(k_f)) * sum(k_f.* (1./ sqrt(1 + cd)).* (cos( (pi / (2 * length(k_f))) * (k - 1) * (2 * n - 1))));

end

Y = sig_f;

end