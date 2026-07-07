%% Mackay-Neal规则LDPC码校验矩阵构造(非规则)
rH = 9;          % H的行数
n = 12;          % H的列数
bc = 3;          % 每列中1的个数
for i = 1:n
    ones_col(:, i) = randperm(rH)';
end
r = reshape(ones_col(1:bc, :), n*bc, 1);
temp = repmat([1:n], bc, 1);
c = reshape(temp, n*bc, 1);
H = full(sparse(r, c, 1, rH, n));  % Creates sparse matrix H
for i = 1:rH
    cr = randperm(n);
    if length(find(r == i)) == 0
        H(i, cr(1)) = 1;  % adds two 1s if row has no 1
        H(i, cr(2)) = 1;
    elseif length(find(r == i)) == 1
        H(i, cr(1)) = 1;  % adds one 1 if row has only one 1
    end
end
figure(1)
imshow(~H, 'InitialMagnification', 'fit');
xlabel('校验矩阵的列数'); ylabel('校验矩阵的行数');
