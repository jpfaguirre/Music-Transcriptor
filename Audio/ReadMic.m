har = dsp.AudioRecorder;
hmfw = dsp.AudioFileWriter('myspeech.wav','FileFormat','WAV');

disp('Speak into microphone now');

tic;
while toc < 10,
     step(hmfw, step(har));
end

release(har);
release(hmfw);
disp('Recording complete'); 