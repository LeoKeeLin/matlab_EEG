clc
close all
clear

% name = 'takeoff_3';
% name = 'flyst_3';
% name = 'stop_3';
name = 'landing_3';
% name = 'Fcage2';

second = 60;
freq = 256;
time = second * freq;

file = ['/Users/leokeelin/Documents/EEG/', name, '.txt'];
s = fopen(file, 'r');

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

k = 1;

for i = 3*256:128:58*256
    ch1 = y1(i-2*256:i+256);
    ch2 = y2(i-2*256:i+256);

    [db, cb] = butter(4, [8/128, 50/128], 'bandpass');
    y3 = filtfilt(db, cb, ch1);
    y4 = filtfilt(db, cb, ch2);

    Fs = 256;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = Fs * 5;             % Length of signal
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
    
    area1(k) = 0;
    area2(k) = 0;
    for j = 1:length(f)
        if f(j) <= 8.5
            area1(k) = area1(k) + P1(j);
            area2(k) = area2(k) + P2(j);
        elseif f(j) <= 13
            area1(k) = area1(k) + P1(j) * 1.5;
            area2(k) = area2(k) + P2(j) * 1.5;
        elseif f(j) <= 20
            area1(k) = area1(k) + P1(j) * 1.3;
            area2(k) = area2(k) + P2(j) * 1.3;
        else
            area1(k) = area1(k) + P1(j) * 1.2;
            area2(k) = area2(k) + P2(j) * 1.2;
        end
    end
    k = k + 1;
    
    
end

subplot(2,1,1)
plot(1:length(area1), area1);
subplot(2,1,2)
plot(1:length(area2), area2);

mean(area2)
