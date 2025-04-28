clear; close all; clc;

% 音声ファイルの読み込み
voiceData = 'parukia.wav';
[inputSignal, fs] = audioread(voiceData);

% 窓長・シフト長を定義
windowLength = 4096;
shiftLength = windowLength / 2;

S = calcSTFT(inputSignal, fs, windowLength, shiftLength);