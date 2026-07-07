%多项式相乘
p1 = [1 1 0 1];
p2 = [1 1 1 0 1];
p3 = gfconv(p1,p2);
disp(p3)
%多项式除法
p1 = [1 1 0 1];
p2 = [1 0 0 0 0 0 0 1];
[q,r] = gfdeconv(p2,p1);
disp(q)
disp(r)
%检验多项式是否为本原多项式
p = [1 1 1 1 1 1 1];
ck = gfprimck(p);
disp(ck)
%生成本原多项式
m = 4;
p = primpoly(m,'all');%输出本原多项式的十进制表示和该次数的第几个本原多项式
%生成默认本原多项式
for m = 3:5
    gfpretty(gfprimdf(m,3))
end