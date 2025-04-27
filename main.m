clear; close all; clc;

% 音声ファイルの読み込み
voiceData = 'parukia.wav';
[inputSignal, fs] = audioread(voiceData);
% sound(inputSignal, fs);

% 窓長・シフト長を定義
windowLength = 4096;
shiftLength = windowLength / 2;

% 信号にゼロパディング
complementedInputSignal = padarray(inputSignal, windowLength / 2, 0, "pre");
complementedInputSignal = padarray(complementedInputSignal, shiftLength - 1, 0, "post");

% フレーム数の算出
signalLength = size(inputSignal, 1);
timeFrames = ceil((2 * signalLength - windowLength) / (2 * shiftLength)) + 1;

% 信号を入れる行列を定義
transformedSignals = zeros(windowLength, timeFrames);

% ハン窓の作成
hannWindowAxis = (1:windowLength).';
hannWindow = 0.5 - 0.5 * cos(2 * pi * hannWindowAxis / windowLength);

% 信号を列単位(ベクトル)でハン窓を掛ける
for i = 1 : timeFrames
    separatedSignals = complementedInputSignal((i - 1) * shiftLength + 1: (i - 1) * shiftLength + windowLength, 1);
    windowedSignals = separatedSignals .* hannWindow;
    % ハン窓を掛けた後に各列をフーリエ変換して行列に挿入する
    transformedSignals(:, i) = fft(windowedSignals);
end

% フーリエ変換後の信号を利得に変換
poweredSignals = power(abs(transformedSignals), 2);
signalsGain = 10 * log10(poweredSignals);

%time = size(complementedInputSignal, 1) / fs;
%imagesc(time, fs, signalsGain);
%xlabel("Time [s]");
%ylabel("Frequency [Hz]");
%c = colorbar;
%c.Label.String = ("Gain [dB]");

