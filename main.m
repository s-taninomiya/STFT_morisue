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
separatedSignals = zeros(windowLength, timeFrames);
windowedSignals = zeros(windowLength, timeFrames);
transformedSignals = zeros(windowLength, timeFrames);

% ハン窓の作成
hannWindowAxis = (1:windowLength).';
hannWindow = 0.5 - 0.5 * cos(2 * pi * hannWindowAxis / windowLength);

% 行列に信号を列単位(ベクトル)で代入し，ハン窓を掛ける
for i = 1 : timeFrames
    separatedSignals(:, i) = complementedInputSignal((i - 1) * shiftLength + 1: (i - 1) * shiftLength + windowLength, 1);
    windowedSignals(:, i) = separatedSignals(:, i) .* hannWindow;
    % ハン窓を掛けた後に各列をフーリエ変換をする
    transformedSignals(:, i) = fft(windowedSignals(:, i));
end

poweredSignals = power(abs(transformedSignals), 2);




