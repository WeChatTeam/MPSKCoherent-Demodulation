% close all
% clear all
% clc

% I = imag(basebandIQ);
% Q = real(basebandIQ);

% id = fopen('I_signal.txt', 'w');
% for n=1:length(basebandIQ)
%     fprintf(id, '%s\n', fixed(I(n)));
%     if(n == length(basebandIQ)/2);
%         a='halfI'
%     end
% end
% id = fopen('Q_signal.txt', 'w');
% for n=1:length(basebandIQ)
%     fprintf(id, '%s\n', fixed(Q(n)));
%     if(n == length(basebandIQ)/2);
%         a='halfQ'
%     end
% end
% 
% id1 = fopen('I_IFO.txt', 'w');
% id2 = fopen('Q_IFO.txt', 'w');
% for n=1:length(interpolatedFilterOutputDataI)
%     fprintf(id1, '%s\n', fixed(interpolatedFilterOutputDataI(n)));
%     fprintf(id2, '%s\n', fixed(interpolatedFilterOutputDataQ(n)));
% end
id1 = fopen('uk.txt', 'w');
id2 = fopen('mk.txt', 'w');
for n=1:length(interpolatedFilterOutputDataI)
    fprintf(id1, '%s\n', fixed(uk(n)));
    fprintf(id2, '%s\n', fixed(mk(n)));
end
id1 = fopen('EDO.txt', 'w');
for n=1:length(errDetecerOutputData)
    fprintf(id1, '%s\n', fixed(errDetecerOutputData(n)));
end
id1 = fopen('SLFO.txt', 'w');
for n=1:length(symbolLoopFilterTempOutputData)
    fprintf(id1, '%s\n', fixed(symbolLoopFilterTempOutputData(n)));
end

fileID1 = fopen('I_out_signal.txt', 'r');
fileID2 = fopen('Q_out_signal.txt', 'r');
x = fscanf(fileID1, '%d');
fclose(fileID1);

scatterplot(complex(Q,I));
