clc
close all
clear
hold on

name = 'takeoff_3';
% name = 'flyst_2';
% name = 'stop_3';
% name = 'landing_3';
% name = 'Fcage2';

second = 60;
freq = 256;
time = second * freq;

file = ['/Users/leokeelin/Documents/EEG/', name, '.txt'];
s = fopen(file, 'r');

% for x = 1:256*5
%     temp = fscanf(s,'%d', 10);
% end

for x = 1:time
    temp = fscanf(s,'%d', 10);
    y1(x) = temp(7);
    y2(x) = temp(10);
end

fclose(s);

mean1 = mean(y1);
mean2 = mean(y2);
y1 = y1 - mean1;
y2 = y2 - mean2;

figure(1);

subplot(4,1,1);
plot(1:time,y1);
xlabel('time (s)');
title('channel 1');
subplot(4,1,2);
plot(1:time,y2);
xlabel('time (s)');
title('channel 2');

[db, cb] = butter(4, [8/128, 50/128], 'bandpass');
y3 = filtfilt(db, cb, y1);
subplot(4,1,3);
plot(1:time,y3);
xlabel('time (s)');
title('channel 1');

y4 = filtfilt(db, cb, y2);
subplot(4,1,4);
plot(1:time,y4);
xlabel('time (s)');
title('channel 1');

figure(2);

Fs = 256;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = Fs * second;             % Length of signal
t = (0:L-1)*T;        % Time vector
f = Fs*(0:(L/2))/L;

Y1 = fft(y3);
P_temp1 = abs(Y1/L);
P1 = P_temp1(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

Y2 = fft(y4);
P_temp2 = abs(Y2/L);
P2 = P_temp2(1:L/2+1);
P2(2:end-1) = 2*P2(2:end-1);

subplot(2,1,1);
plot(f, P1);
xlabel('f (Hz)');
title([name, ' channel 1']);

subplot(2,1,2);
plot(f, P2);
xlabel('f (Hz)');
title([name, ' channel 2']);

i = 1;
for j = 2:length(f)-1
    if P1(j) > P1(j-1) && P1(j) > P1(j+1)
        max_ch1(i) = P1(j);
        max_id1(i) = f(j);
        i = i + 1;
    end
end

i = 1;
for j = 2:length(max_id1)-1
    if max_ch1(j) > max_ch1(j-1) && max_ch1(j) > max_ch1(j+1)
        maxx_ch1(i) = max_ch1(j);
        maxx_id1(i) = max_id1(j);
        i = i + 1;
    end
end

i = 1;
for j = 2:length(maxx_id1)-1
    if maxx_ch1(j) > maxx_ch1(j-1) && maxx_ch1(j) > maxx_ch1(j+1)
        maxxx_ch1(i) = maxx_ch1(j);
        maxxx_id1(i) = maxx_id1(j);
        i = i + 1;
    end
end

i = 1;
for j = 2:length(maxxx_id1)-1
    if maxxx_ch1(j) > maxxx_ch1(j-1) && maxxx_ch1(j) > maxxx_ch1(j+1)
        maxxxx_ch1(i) = maxxx_ch1(j);
        maxxxx_id1(i) = maxxx_id1(j);
        i = i + 1;
    end
end

figure
subplot(2,1,1);
plot(maxxx_id1, maxxx_ch1);

i = 1;
for j = 2:length(f)-1
    if P2(j) > P2(j-1) && P2(j) > P2(j+1)
        max_ch2(i) = P2(j);
        max_id2(i) = f(j);
        i = i + 1;
    end
end

i = 1;
for j = 2:length(max_id2)-1
    if max_ch2(j) > max_ch2(j-1) && max_ch2(j) > max_ch2(j+1)
        maxx_ch2(i) = max_ch2(j);
        maxx_id2(i) = max_id2(j);
        i = i + 1;
    end
end

i = 1;
for j = 2:length(maxx_id2)-1
    if maxx_ch2(j) > maxx_ch2(j-1) && maxx_ch2(j) > maxx_ch2(j+1)
        maxxx_ch2(i) = maxx_ch2(j);
        maxxx_id2(i) = maxx_id2(j);
        i = i + 1;
    end
end

i = 1;
for j = 2:length(maxxx_id2)-1
    if maxxx_ch2(j) > maxxx_ch2(j-1) && maxxx_ch2(j) > maxxx_ch2(j+1)
        maxxxx_ch2(i) = maxxx_ch2(j);
        maxxxx_id2(i) = maxxx_id2(j);
        i = i + 1;
    end
end

subplot(2,1,2);
plot(maxxxx_id2, maxxxx_ch2);

% f_save = ['/Users/leokeelin/Desktop/butter_2/', name, '_max.txt'];
% ss = fopen(f_save, 'w');
% 
% fprintf(ss, '%d', length(maxxx_ch1));
% fprintf(ss, '\n');
% fprintf(ss, '%f ', maxxx_ch1);
% fprintf(ss, '\n');
% fprintf(ss, '%f ', maxxx_id1);
% fprintf(ss, '\n');
% 
% fprintf(ss, '%d', length(maxxx_ch2));
% fprintf(ss, '\n');
% fprintf(ss, '%f ', maxxx_ch2);
% fprintf(ss, '\n');
% fprintf(ss, '%f ', maxxx_id2);
% fprintf(ss, '\n');
% 
% fclose(ss);

area1 = 0;
area2 = 0;
for j = 1:length(f)
    area1 = area1 + P1(j) / 60;
end
for j = 1:length(f)
    area2 = area2 + P2(j) / 60;
end

area1
area2
