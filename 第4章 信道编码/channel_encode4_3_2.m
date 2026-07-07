%% 突发情况下卷积交织码、卷积码、汉明码和交织汉明编码
clear; close all;
cycl = 20;          % 可以多次运行取均值
SNR = 0:12;
msg = round(rand(1, 1e4));
BER0 = zeros(1, length(SNR));
BER1 = BER0;
BER2 = BER0;
BER3 = BER0;
%% ========== 网格参数 ==========
L = 3;
trellis = poly2trellis(L, [5, 7]);
code3 = convenc(msg, trellis);
modbit1 = pskmod(code3, 2);
%% ========== 汉明编码预设 ==========
code2 = encode(msg, 7, 4, 'hamming');      % (7,4) hamming encoding
modbit2 = pskmod(code2, 2);
%% ========== 交织编码 ==========
intrlvd = randintrlv(code2, 2113);
modbit3 = pskmod(intrlvd, 2);
%% ========== 交织卷积 ==========
intrlvd = randintrlv(code3, 2113);
modbit4 = pskmod(intrlvd, 2);
%% ========== 新加入突发干扰 ==========
N_Burst_ham = BurstNoise_2(100, 5, length(code2));
N_Burst_cov = BurstNoise_2(100, 5, length(code3));
for n = 1:cycl
    for k = 1:length(SNR)
        %% ========== 交织卷积 ==========
        y0 = awgn(modbit4, SNR(k), 'measured');
        y0 = N_Burst_cov + y0;
        demsg0 = pskdemod(y0, 2);
        recode0 = reshape(demsg0.', 1, []);
        deintrlvd = randdeintrlv(recode0, 2113);
        tblen1 = 5;
        decoded1 = vitdec(deintrlvd, trellis, tblen1, 'cont', 'hard');
        [num0, rat0] = biterr(double(decoded1(tblen1+1:end)), msg(1:end-tblen1));
        BER0(n, k) = rat0;
        %% ========== 编码部分 回溯长度为 5 ==========
        y1 = awgn(modbit1, SNR(k), 'measured');
        y1 = N_Burst_cov + y1;
        demsg1 = pskdemod(y1, 2);
        recode1 = reshape(demsg1.', 1, []);
        tblen1 = 5;
        decoded1 = vitdec(recode1, trellis, tblen1, 'cont', 'hard');
        [num1, rat1] = biterr(double(decoded1(tblen1+1:end)), msg(1:end-tblen1));
        BER1(n, k) = rat1;
        %% ========== 汉明码 ==========
        y3 = awgn(modbit2, SNR(k), 'measured');
        y3 = N_Burst_ham + y3;
        demmsg3 = pskdemod(y3, 2);
        recode3 = reshape(demmsg3, 1, []);
        decodedbit = decode(recode3, 7, 4, 'hamming');    % decode
        % error rate
        error3 = (decodedbit ~= msg);
        errorbits = sum(error3);
        BER2(n, k) = errorbits / length(msg);
        %% ========== 交织汉明编码 ==========
        y3 = awgn(modbit3, SNR(k), 'measured');
        y3 = N_Burst_ham + y3;
        demmsg3 = pskdemod(y3, 2);
        recode3 = reshape(demmsg3, 1, []);
        deintrlvd = randdeintrlv(recode3, 2113);
        decodedbit = decode(deintrlvd, 7, 4, 'hamming');    % decode
        % error rate
        error3 = (decodedbit ~= msg);
        errorbits = sum(error3);
        BER3(n, k) = errorbits / length(msg);
        
    end
end
BER0 = mean(BER0);
BER1 = mean(BER1);
BER2 = mean(BER2);
BER3 = mean(BER3);
semilogy(SNR, BER0, 'b-.o', SNR, BER1, 'r--s', SNR, BER2, 'k:v', ...
    SNR, BER3, 'g-*', 'linewidth', 2);
xlabel('SNR/dB');
ylabel('BER');
legend('卷积加交织','回溯5卷积编码','汉明码','交织汉明码');
grid on;



function noise = BurstNoise_2(amplitude, burst_len, total_len)
    % 随机100个位置，每个位置连续burst_len个出错
    noise = zeros(1, total_len);
    for i = 1:50
        start_idx = randi([1, total_len - burst_len + 1]);
        noise(start_idx : start_idx + burst_len - 1) = amplitude;
    end
end