%CRC编码和解码
poly = [1 1 1 0 1 0 1 0 1];
x = [1 1 1 1 1 1 1 1 1];
encode_crc = crc_encode(x,poly);
[crc_debit,error] = crc_decode(encode_crc,poly);
function encode_crc = crc_encode(msg,poly)
msg1 = [msg zeros(1,length(poly)-1)];
[~,r] = deconv(msg1,poly);
disp(r)
r = abs(r);
for i=1:length(r)
    a=r(i);
    if(mod(a,2)==0)
        r(i)=0;
    else
        r(i)=1;
    end
end
encode_crc = [msg, r(length(msg)+1:end)];
end

function [crc_debit,error] = crc_decode(x,poly)
N = length(poly);
[~,r] = deconv(x,poly);
r = mod(abs(r),2);
if r == zeros(1,length(x))
    error = 0;
else
    error = 1;
end
crc_debit = x(1:length(x)-N+1);
end