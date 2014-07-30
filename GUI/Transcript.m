function [ColorNote,Position,Type]=Transcript(MIDI,blackTime,scale)

    sostenidos=[22 25 27 30 32 34 37 39 42 44 46 49 51 58 61 63 66 68 70 73 75 78];
    speed = [1/32 3/64 1/16 3/32 1/8 3/16 1/4 3/8 1/2 3/4 1 1.5 2 3 4 6 8 12 16 24];
    
    note=1;
    ColorNote = zeros(size(MIDI(:,1)));
    Position = zeros(size(MIDI(:,1)));
    Type = zeros(size(MIDI(:,1)));
    Continue = zeros(size(MIDI(:,1)));
    
    for i=1:length(MIDI(:,1))
        
        if(i==1 || i==length(MIDI(:,1)))
            tiempo=MIDI(i,2);
        else
            tiempo=MIDI(i+1,2)-(MIDI(i,2)+MIDI(i,3));
        end
        
        if i<length(MIDI(:,1)) && tiempo>=blackTime*(1/32)
            ColorNote(note) = interp1(speed,speed,tiempo,'nearest');
            Position(note)=7;
            Type(note)=2;
            Continue(note)=0;
        else
            duration= MIDI(i,3);

            ColorNote(note) = interp1(speed,speed,duration/blackTime,'nearest');

            if (i~=length(MIDI(:,1)))&&((MIDI(i,2)+MIDI(i,3))>(MIDI(i+1,2)))
                Continue(note)=1;
            else
                Continue(note)=0;
            end

            if(isempty(sostenidos(sostenidos==MIDI(i,1))))
                Type(note)=0;
            else
                Type(note)=1;
            end

            %Position(note)=MIDI(i,1)-length(sostenidos(sostenidos<=MIDI(i,1)))+1+length(sostenidos(sostenidos<=60))-60;
            Position(note)=MIDI(i,1)-length(sostenidos(sostenidos<=MIDI(i,1)))-60+14;
        end

        note=note+1;    
    end    
end
