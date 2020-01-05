clc;
clear all;
close all;
% Read file
[original_sound,fs] = audioread('test.wav');
original_sound = original_sound(3501:end-3500,1);
time = (0:length(original_sound)-1)/fs;
original_sound = original_sound';
sound(original_sound, fs);
% h(t)
% ------------------------------Ideal Delay------------------------------%
h1 = zeros(1,20000);
h1(1,10000) = 1;
Delay = mfunction(original_sound, h1);
audiowrite('delay.wav',Delay,fs);
% -----------------------------Moving Average-----------------------------%
h2 = 1/9*ones(1,9);
Moving_average = mfunction(original_sound, h2);
audiowrite('mov.wav',Moving_average,fs);
%sound(Moving_average, fs);
% ------------------------------Accumulator------------------------------%
h3 = ones(1,10);
Accumulator = mfunction(original_sound, h3);
%temp = Accumulator(1:length(Accumulator)/2);
%Accumulator(1:length(original_sound)/2) = Accumulator(length(original_sound)/2+1:length(original_sound));
%Accumulator(length(original_sound)/2+1:length(original_sound)) = temp;
sound(Accumulator, fs);
audiowrite('acc.wav',Accumulator,fs);

h6 = zeros(1,length(original_sound));
for i = 1:length(original_sound)
    h6(i) = i;  
end  
Accumulator_1 = mfunction(original_sound, h6);
%sound(Accumulator_1, fs);
% ---------------------------Forward Difference---------------------------%
h4 = [1 -1];
Forward = mfunction(original_sound, h4);
%sound(Forward, fs);
audiowrite('forward.wav',Forward,fs);
% --------------------------Backward Difference--------------------------%
h5 = [0 1 -1];
Backward = mfunction(original_sound, h5);
audiowrite('back.wav',Backward,fs);
%sound(Backward, fs);
% ------------------------------Time Domain------------------------------%
figure;
subplot(6,1,1);plot(time,original_sound);axis([0,1.4,-1,1]);
title("Time Domain of original sound");xlabel("Time(Sec)");ylabel("Amp");
subplot(6,1,2);plot((0:length(Delay)-1)/fs,Delay);axis([0,1.4,-1,1]);
title("Time Domain of Ideal Delay");xlabel("Time(Sec)");ylabel("Amp");
subplot(6,1,3);plot((0:length(Moving_average)-1)/fs,Moving_average);axis([0,1.4,-1,1]);
title("Time Domain of Moving Average");xlabel("Time(Sec)");ylabel("Amp");
subplot(6,1,4);plot((0:length(Accumulator)-1)/fs,Accumulator);%axis([0,1.4,-1,1]);
title("Time Domain of Accumulator");xlabel("Time(Sec)");ylabel("Amp");
subplot(6,1,5);plot((0:length(Forward)-1)/fs,Forward);%axis([0,1.4,-1,1]);
title("Time Domain of Forward Difference");xlabel("Time(Sec)");ylabel("Amp");
subplot(6,1,6);plot((0:length(Backward)-1)/fs,Backward);%axis([0,1.4,-1,1]);
title("Time Domain of Backward Difference");xlabel("Time(Sec)");ylabel("Amp");
% --------------------------------Compare--------------------------------%
figure;
subplot(2,1,1);plot(time,original_sound);axis([1,1.1,-1,1]);
title("Time Domain of original sound");xlabel("Time(Sec)");ylabel("Amp");
subplot(2,1,2);plot((0:length(Moving_average)-1)/fs,Moving_average);axis([1,1.1,-1,1]);
title("Time Domain of Moving Average");xlabel("Time(Sec)");ylabel("Amp");

figure;
subplot(2,1,1);plot((0:length(Forward)-1)/fs,Forward);axis([1.15,1.2,-1,1  ]);
title("Time Domain of Forward Difference");xlabel("Time(Sec)");ylabel("Amp");
subplot(2,1,2);plot((0:length(Backward)-1)/fs,Backward);axis([1.15,1.2,-1,1]);
title("Time Domain of Backward Difference");xlabel("Time(Sec)");ylabel("Amp");
% --------------------------------Specgram--------------------------------%
figure;
subplot(6,1,1);spectrogram(original_sound,1024,1000,[],fs,'yaxis');
title('Origin Frequency Domain');
subplot(6,1,2);spectrogram(Delay,1024,1000,[],fs,'yaxis');
title('Ideal Delay Frequency Domain');
subplot(6,1,3);spectrogram(Moving_average,1024,1000,[],fs,'yaxis');
title('Moving Average Frequency Domain');
subplot(6,1,4);spectrogram(Accumulator,1024,1000,[],fs,'yaxis');
title('Accumulator Frequency Domain');
subplot(6,1,5);spectrogram(Forward,1024,1000,[],fs,'yaxis');
title('Forward Difference Frequency Domain');
subplot(6,1,6);spectrogram(Backward,1024,1000,[],fs,'yaxis');
title('Backward Difference Frequency Domain');

% ---------------------------Frequency Response---------------------------%

len=fs;
w=linspace(0,fs,len);

H1=fft(h1,len);
H2=fft(h2,len);
H3=fft(h3,len);
H4=fft(h4,len);
H5=fft(h5,len); % h做FFT後得到H



H1A=abs(H1);    H1P=angle(H1);
H2A=abs(H2);    H2P=angle(H2);
H3A=abs(H3);    H3P=angle(H3);
H4A=abs(H4);    H4P=angle(H4);
H5A=abs(H5);    H5P=angle(H5); % 取絕對值為振福 取angle為弧度


H1A=10*log10(H1A);  H1P=H1P*180/pi;
H2A=10*log10(H2A);  H2P=H2P*180/pi;
H3A=10*log10(H3A);  H3P=H3P*180/pi;
H4A=10*log10(H4A);  H4P=H4P*180/pi;
H5A=10*log10(H5A);  H5P=H5P*180/pi; % 轉成dB和角度

figure;
subplot(2,5,1);plot(w,H1A);axis([0,fs/2,-1,1]);
xlabel("Hz");ylabel("dB");title('H1 振幅頻譜');grid on;
subplot(2,5,6);plot(w,H1P);axis([0,100,-300,200]);
xlabel("Hz");ylabel("Degrees");title('H1 相位頻譜');grid on;

subplot(2,5,2);plot(w,H2A);axis([0,fs/2,-inf,inf]);
xlabel("Hz");ylabel("dB");title('H2 振幅頻譜');grid on;
subplot(2,5,7);plot(w,H2P);axis([0,fs/2,-inf,inf]);
xlabel("Hz");ylabel("Degrees");title('H2 相位頻譜');grid on;

subplot(2,5,3);plot(w,H3A);axis([-500,fs/2,-inf,45]);
xlabel("Hz");ylabel("dB");title('H3 振幅頻譜');grid on;
subplot(2,5,8);plot(w,H3P);axis([0,fs/2,-0.5,0.5]);
xlabel("Hz");ylabel("Degrees");title('H3 相位頻譜');grid on;

subplot(2,5,4);plot(w,H4A);axis([0,fs/2,-inf,inf]);
xlabel("Hz");ylabel("dB");title('H4 振幅頻譜');grid on;
subplot(2,5,9);plot(w,H4P);axis([0,fs/2,-inf,inf]);
xlabel("Hz");ylabel("Degrees");title('H4 相位頻譜');grid on;

subplot(2,5,5);plot(w,H5A);axis([0,fs/2,-inf,inf]);
xlabel("Hz");ylabel("dB");title('H5 振幅頻譜');grid on;
subplot(2,5,10);plot(w,H5P);axis([0,fs/2,-inf,inf]);
xlabel("Hz");ylabel("Degrees");title('H5 相位頻譜');grid on;