function [MIDI,blackTime,scale] = getMIDI(onsets,end_time,freqs,duration)
    normal_C = [32.7032 65.4064 130.813 261.626 523.251 1046.50 2093.00 4186.01]; 
    
    blackTime = mode(duration);
    
    scale = interp1(normal_C,normal_C,mean(freqs),'nearest');
    
    
    MIDI = [69+round(12*log(freqs(:)/440)/log(2))  onsets(:)  duration(:)];
    
    M(:,1) = ones(1,length(onsets));         % all in track 1
    M(:,2) = ones(1,length(onsets));         % all in channel 1
    M(:,3) = MIDI(:,1);      % note numbers: one ocatave starting at middle C (60)
    M(:,4) = 100*ones(1,length(onsets));  % lets have volume ramp up 80->120
    M(:,5) = onsets(:);  % note on:  notes start every .5 seconds
    M(:,6) = M(:,5) + duration(:);   % note off: each note has duration .5 seconds
    
    
    midi_new = matrix2midi(M);
    writemidi(midi_new, 'testout.mid');
    
end