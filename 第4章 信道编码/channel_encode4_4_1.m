%% Gallager规则LDPC码校验矩阵构造
n = 12;          % 码字长度(H的列数)
bc = 3;          % 每列中1的个数(每个编码比特包含的校验等式数)
br = 4;          % 每行中1的个数(每个校验等式包含的编码比特数)
rH = (n * bc) / br;  % H的行数(校验等式的个数)
H = zeros(rH, n);
j = 1; jj = br;
for i = 1:n/br   % H的每个子集中1元素的分配
    H(i, j:jj) = 1;
    j = j + br;
    jj = (i * br) + br;
end
for i = 1:bc-1
    for ii = 1:n
        colind = (round(rand(1) * (n-1))) + 1;
        rCol = H(1:n/br, colind);
        H(i*(n/br)+1 : i*(n/br)+1+(n/br)-1, ii) = rCol;
    end
end
figure
imshow(~H, 'InitialMagnification', 'fit')
xlabel('校验矩阵的列数'); ylabel('校验矩阵的行数');
