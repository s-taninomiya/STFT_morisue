clear; close all; clc;

% 音声ファイルの読み込み
voiceData = 'parukia.wav';
[inputSignal, fs] = audioread(voiceData);
% sound(inputSignal, fs);

% 窓長・シフト長を定義
windowLength = 4096;
shiftLength = windowLength / 2;

% ゼロパディング
complementedInputSignal = padarray(inputSignal, windowLength / 2, 0, "pre");
complementedInputSignal = padarray(complementedInputSignal, shiftLength - 1, 0, "post");

% フレーム数の算出
signalLength = size(inputSignal, 1);
timeFrames = ceil((2 * signalLength - windowLength) / (2 * shiftLength)) + 1;

% 信号を入れる行列を定義
separatedSignals = zeros(windowLength, timeFrames);
windowedSignals = zeros(windowLength, timeFrames);
transformedSignals = zeros(windowLength, timeFrames);

% 行列に信号を順番に代入し，ハン窓を掛ける
for i = 1 : timeFrames
    for j = 1 : windowLength
        separatedSignals(j, i) = complementedInputSignal((i - 1) * shiftLength + j);
        hannWindow = 0.5 - 0.5 * cos(2 * pi * j / windowLength);
        windowedSignals(j, i) = separatedSignals(j, i) * hannWindow;
    end
end

% ハン窓を掛けた信号の行列をフーリエ変換する
transformedSignals = fft(windowedSignals);


