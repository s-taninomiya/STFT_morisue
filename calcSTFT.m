function spectrogram = calcSTFT(inputSignal, fs, windowLength, shiftLength)
% STFTを行う関数を定義
%-----------------------------description----------------------------------
% calcSTFT : using Short-Time Fourier Transform, calculate spectrogram
%
% [Input]
% inputSignal : time-domain signal (signalLength x 1)
% fs : input signal sampling frequency [Hz] (scalar)
% windowLength : window length used in STFT (scalar)
% shiftLength : shift length used in STFT (scalar)
% windowType : select window function type (string)
% specVisible : select whether to display the spectrogram (logical)
% paddingMethod : select zero-padding method (string)
%
% [Output]
% spectrogram : complex-value spectrogram (windowLength x timeFrames)
%--------------------------------------------------------------------------

% 信号にゼロパディング
preZeroPad = zeros(windowLength / 2, 1);
postZeroPad = zeros(shiftLength - 1, 1);
compInputSignal = [preZeroPad; inputSignal; postZeroPad];
% complementedInputSignal = padarray(inputSignal, windowLength / 2, 0, "pre");
% complementedInputSignal = padarray(complementedInputSignal, shiftLength - 1, 0, "post");

% フレーム数の算出
signalLength = size(inputSignal, 1);
timeFrames = ceil((2 * signalLength - windowLength) / (2 * shiftLength)) + 1;

% 信号を入れる行列を定義
tmp = zeros(windowLength, timeFrames);

% ハン窓の作成
hannWindowAxis = (1:windowLength).';
hannWindow = 0.5 - 0.5 * cos(2 * pi * hannWindowAxis / windowLength);

% 信号を列単位(ベクトル)でハン窓を掛ける
for i = 1 : timeFrames
    separatedSignal = compInputSignal((i - 1) * shiftLength + 1: (i - 1) * shiftLength + windowLength, 1);
    tmp(:, i) = separatedSignal .* hannWindow;
    
end

% フーリエ変換を行う
spectrogram = fft(tmp);

% スペクトログラムを表示
dispSpectrogram(spectrogram, signalLength, fs);
end

%% Local function
%--------------------------------------------------------------------------

% スペクトログラムを表示する関数を定義
function dispSpectrogram(transformedSignals, signalLength, fs)
% フーリエ変換後の信号を利得に変換
poweredSignals = abs(transformedSignals) .^ 2;
signalsGain = 20 * log10(poweredSignals);

% x軸(時間軸)の計算
signalTime = signalLength / fs;

% スペクトログラムの表示
imagesc([0, signalTime], [0, fs], signalsGain);
axis xy;
ylim([0, fs / 2]);
xlabel("Time [s]");
ylabel("Frequency [Hz]");
c = colorbar;
c.Label.String = ("Gain [dB]");

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%