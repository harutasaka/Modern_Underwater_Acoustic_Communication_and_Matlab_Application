%% 消除校验矩阵H中的4环（girth-4 removal）
clear all; clc; close all

% 初始校验矩阵 H (5行12列)
H = [1 1 1 1 0 1 1 0 0 0;...
     0 0 1 1 1 1 1 1 0 0;...
     0 1 0 1 0 1 0 1 1 1;...
     1 0 1 0 1 0 0 1 1 1;...
     1 1 0 0 1 0 1 0 1 1];

H0 = H;  % 保存原始矩阵用于对比
row = size(H, 1);  % H的行数 = 5

% 计算 H'*H，用于检测4环
% gt(i,j) 表示第i行和第j行在多少列上同时为1
% gt(i,j) >= 2 意味着存在4环
gt = H' * H;

% 先将对角线置0（对角线元素代表每行自身的1的个数，不是4环）
for i = 1:row
    gt(i, i) = 0;
end

figure(1), subplot(121)
pcolor(gt);  % 检验是否有带4出现（即非对角线元素>=2）
xlabel('矩阵的列数'); ylabel('矩阵的行数'); title('(a)');

d = find(gt == 2);  % 找到值为2的位置（存在4环）

if (d ~= 0)
    % 去掉带4（消除4环）
    for i = 1:row
        for j = (i + 1):row
            sp = and(H(i, :), H(j, :));  % 两行同时为1的位置
            csp = find(sp);               % 这些位置的列索引
            cl = length(csp);             % 共同1的个数
            if cl > 1
                % 如果两行共同1的个数>1，则存在4环，需要消除
                if length(find(H(i, :))) < length(find(H(j, :)))
                    % 选择1较少的行，保留1个共同1，其余置0
                    for cp = 1:cl - 1
                        H(j, csp(cp)) = 0;
                    end
                else
                    % 否则选择当前行i
                    for cp = 1:cl - 1
                        H(i, csp(cp)) = 0;
                    end
                end
            end
        end
    end
end

subplot(122)
pcolor(H' * H); colorbar; title('(b)');
xlabel('矩阵的列数');

figure(2)
subplot(121)
imshow(~H0, 'InitialMagnification', 'fit')
xlabel('校验矩阵的列数'); ylabel('校验矩阵的行数');
title('(a)');

subplot(122)
imshow(~H, 'InitialMagnification', 'fit')
xlabel('校验矩阵的列数'); title('(b)');
