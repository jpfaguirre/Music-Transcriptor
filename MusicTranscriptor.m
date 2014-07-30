classdef MusicTranscriptor < dynamicprops

    
    properties  (SetObservable)
        audio;
        fs;
        musicSheet;
        onSets;
        probable;
        durations;
        instruments;
        MIDI;
        blackTime;
        scale;
        selectedInstrument;
        instrumentList;
        instrumentPattern;
        fundamental;
        Position;
        ColorNote;
        Type;
        instr_num;
    end
    
    properties 
        
        handles;
        
    end
    
    
    methods
        
        function self = MusicTranscriptor(self)    
            initialSettings(self);
            set(self.handles.load_btn, 'callback', @self.load_btn_callback);
            set(self.handles.transcript_btn, 'callback', @self.transcript_btn_callback);
            set(self.handles.export_btn, 'callback', @self.export_btn_callback);
            set(self.handles.instrument_btn, 'callback', @self.instrument_btn_callback);
        end
        
        function instrument_btn_callback(self, varargin)
            self.selectedInstrument = get(self.handles.instrument_list, 'Value');
        end
        
        function transcript_btn_callback(self, varargin)
            self.onSets = getOnsets(self.audio);
            self.instr_num=1;
            self.probable = pitchDetect(self.audio,self.onSets,self.instr_num,self.instrumentPattern(:,self.instr_num),self.fundamental(self.instr_num),self.fs);
            self.durations = noteDuration([ceil(self.probable(:,2)*self.fs/length(self.probable(:,2)));ceil(length(self.audio)/length(self.probable(:,2)))],self.probable(:,1),self.fs);
            [self.MIDI,self.blackTime,self.scale] = getMIDI(self.probable(:,2),length(self.audio)/self.fs,self.probable(:,1),self.durations);
            [self.ColorNote,self.Position,self.Type]=Transcript(self.MIDI,self.blackTime,self.scale);
            
            self.instruments = '';
            
            if find(self.probable(:,3)==1)
                self.instruments = char(self.instruments,'Guitarra');
            end
            if find(self.probable(:,3)==1)
                self.instruments = char(self.instruments,'Piano');
            end
            
            self.instruments=self.instruments(2:end,:);

            set(self.handles.instrument_list,'String',self.instruments);
            
            i = 0;
            for i = 1:length(self.instrumentList)
%                 if 
%                 end
            end
            self.selectedInstrument = i;
            cla(self.musicSheet.h)
            self.musicSheet.drawStaff(self.musicSheet.h);
            for j=1:length(self.Type)
                self.musicSheet.noteColour = self.ColorNote(j);
                self.musicSheet.noteType = self.Type(j);
                self.musicSheet.yPosition = self.Position(j);
                self.musicSheet.getSymbol();
            end
            disp('Done');
        end
        
        
        function load_btn_callback(self, varargin)
            [name,path]=uigetfile('*.wav','Select Wav file');
            if name
                set(self.handles.song_txt,'String',name(1:(end-4)));
                [self.audio, self.fs] = audioread([path,name]); %%analizar estereo
                self.audio = self.audio(:)';
                sum(self.audio);
            end
        end
        
        function export_btn_callback(self, varargin)
            [name,path]=uiputfile('*.mid','Save MIDI file');
            midi_new = matrix2midi(self.probable);
            writemidi(midi_new, [path name]);
        
        end
        
        
    end
end