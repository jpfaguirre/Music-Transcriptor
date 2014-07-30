function [MIDI,blackTime,scale] = getMIDI(onsets,end_time,freqs,duration)
    normal_C = [32.7032 65.4064 130.813 261.626 523.251 1046.50 2093.00 4186.01]; 
    
    blackTime = mode(duration);
    
    scale = interp1(normal_C,normal_C,mean(freqs),'nearest');
    
    
    MIDI = [69+round(12*log(freqs(:)/440)/log(2))  onsets(:)  duration(:)];
    
end