clear all;
clc;
%hamming encode/decode
n = 15;
k = 11;
data = randi([0 1],k,1);
encData = encode(data,n,k,'hamming');
encData(4) = ~encData(4);
decData = decode(encData,n,k,'hamming/binary');
numerr = biterr(data,decData);
disp(numerr);
%线性分组码
n = 7;
k = 3;
data = randi([0 1],k,1);
parmat = cyclgen(n,cyclpoly(n,k));
genmat = gen2par(parmat);
encData = encode(data,n,k,'linear/binary',genmat);
encData(3) = ~encData(3);
decData = decode(encData,n,k,'linear/binary',genmat);
numerr = biterr(data,decData);
disp(numerr);
%卷积码
trellis_a = poly2trellis([5 4],[23 35 0;0 5 13]);
K = log2(trellis_a.numInputSymbols);
N = log2(trellis_a.numOutputSymbols);
numReg = log2(trellis_a.numStates);
numSymPerFrame = 5;
data = randi([0 1],K*numSymPerFrame,1);
[code_a,fstate_a] = convenc(data,trellis_a);
%解码
tb = 2;
decode = vitdec(code_a,trellis_a,2,'trunc','hard');
disp(isequal(data,decode))

%利用维特比算法对打孔信号进行解码
trellis = polytrellis(7,[171 133]);
puncpat = [1;1;0;1;1;0];
tbdepth = 96;
opmode = 'trunc';
dectype = 'hard';
K = log2(trellis.numInputSymbols);
N = log2(trellis.numOutputSymbols);
msg = ones(100*length(puncpat),1);
puncturedcode = convenc(msg,trellis,puncpat);
codein = puncturedcode;
decodeout = vitdec(codein,trellis,tbdepth,opmode,dectype,puncpat);
disp(isequal(msg,decodeout))
