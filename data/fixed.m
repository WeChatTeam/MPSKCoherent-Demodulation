
function [output] = fixed(a, b, c, x)
  %  a = 1; %�з���
  %  b = 1; %��������λ��
  %  c = 14; %С������λ��

  % x = 0.06075; %��Ҫ���㻯����

    yZhengshu = floor(abs(x));
    yXiaoshu = abs(x)-yZhengshu;
    yXiaoshu = floor(yXiaoshu/2^(-c));

    fixint = dec2bin(yZhengshu, b);
    fix = dec2bin(yXiaoshu, c);

    numBin = strcat(fixint, fix);
    for n=1:length(numBin)
        numBinDiff(n) = str2num(numBin(n));
    end

    if x >= 0
        output = strcat('0', numBin);
    else
        data = xor(numBinDiff,ones(1, length(numBin)));
        output = strcat('1', num2str(data));
    end
    output = dec2hex(bin2dec(output), ceil((a+b+c)/4));
    bin2dec(fix)/2^c;
    
end







