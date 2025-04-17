clear; close all; clc;

% 音声ファイルの読み込み
voiceData = 'parukia.wav';
[inputSignal, fs] = audioread(voiceData);
% sound(inputSignal, fs);

% 
windowLength = 4096;
shiftLength = windowLength / 2;
signalLength = size(inputSignal, 1);
complementedInputSignal = padarray(inputSignal, windowLength / 2, 0, "pre");
complementedInputSignal = padarray(complementedInputSignal, windowLength - 1, 0, "post");
timeFrames = ceil((2 * signalLength - windowLength) / (2 * shiftLength)) + 1;
separatedSignals = zeros(windowLength, timeFrames);

% 
for i = 1 : timeFrames
    for j = 1 : windowLength
        separatedSignals(j, i) = complementedInputSignal((i - 1) * windowLength + j);
    end
end

