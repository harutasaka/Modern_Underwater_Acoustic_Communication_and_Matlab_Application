clear all;
clc;
x = [1 0 0 1 0];
y1 = mod(conv(x,[1 1 0]),2);
y2 = mod(conv(x,[1 0 1]),2); 
y3 = mod(conv(x,[1 1 1]),2);
Y = [y1;y2;y3];

trellis = poly2trellis(3,[6 5 7]);
disp(trellis)
%commcnv_plotnextstates(trellis.nextStates);较新版本无法使用
numStates = trellis.numStates;         % 获取状态数 (4)
numInputs = trellis.numInputSymbols;   % 获取输入符号数 (2)

% 构建起点状态（0到3）和终点状态（由 nextStates 决定）
s = repmat((0:numStates-1)', 1, numInputs);
t = trellis.nextStates;

% 创建有向图结构 (MATLAB 中状态索引从 1 开始，所以需要 +1)
G = digraph(s+1, t+1);

% 开始绘图
figure('Color', 'w');
p = plot(G, 'NodeLabel', cellstr(strcat('State ', num2str((0:numStates-1)'))), ...
    'Layout', 'layered', 'Direction', 'right', ...
    'MarkerSize', 8, 'LineWidth', 1.5, 'ArrowSize', 12);

grid on;
title('卷积编码器状态转移图 (Trellis State Transitions)');
xlabel('状态演进方向 ->');