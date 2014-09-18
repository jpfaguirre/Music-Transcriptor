classdef MusicTranscriptor < dynamicprops

    
    properties  (SetObservable)
        hfig;
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
        NumImagen;
        ActImagen;
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
            set(self.handles.AnteriorButton, 'callback', @self.AnteriorButton_Callback);
            set(self.handles.PosteriorButton, 'callback', @self.PosteriorButton_Callback);
        end
        
        
        function AnteriorButton_Callback(self, varargin)
            if((self.NumImagen>1)&&(self.ActImagen>1))
                self.ActImagen=self.ActImagen-1;
                imagen=imread(['Pentagrama\Pentagrama' num2str(self.ActImagen) '.png']);
                axis equal;
                imshow(imagen);
                axis equal;
                imshow(imagen);
                axes(self.handles.music_sheet_axis);
                plot([150 1185],[75 75],'k');
                plot([150 1185],[97 97],'k');
                plot([150 1185],[364 364],'k');
            end
            
        end
        
        function PosteriorButton_Callback(self, varargin)
            if((self.NumImagen>1)&&(self.ActImagen<self.NumImagen))
                self.ActImagen=self.ActImagen+1;
                imagen=imread(['Pentagrama\Pentagrama' num2str(self.ActImagen) '.png']);
                axis equal;
                imshow(imagen);
                axis equal;
                imshow(imagen);
                plot([150 1185],[75 75],'k');
                plot([150 1185],[97 97],'k');
                plot([150 1185],[364 364],'k');
            end
        end
        
        function instrument_btn_callback(self, varargin)
            self.selectedInstrument = get(self.handles.instrument_list, 'Value');
        end
        
        function transcript_btn_callback(self, varargin)
            self.NumImagen=1;
            self.ActImagen=1;
            %%REINICIALIZAR LA PARTE GRAFICA DEL PENTAGRAMA
            self.musicSheet.xPosition=0.28;       %empiezo de nuevo                  
            cla(self.handles.music_sheet_axis,'reset')
            self.musicSheet = SheetMusic(self.hfig,self.handles.music_sheet_axis);
            
            self.onSets = getOnsets(self.audio);
            self.instr_num=get(self.handles.instrument_list, 'Value');
            self.probable = pitchDetect(self.audio,self.onSets,self.instr_num,self.instrumentPattern(:,self.instr_num),self.fundamental(self.instr_num),self.fs);
            self.durations = noteDuration(self.probable(:,2), self.probable(:,1),self.audio,self.fs);
            [self.MIDI,self.blackTime,self.scale] = getMIDI(self.durations(:,2),length(self.audio)/self.fs,self.durations(:,1),self.durations(:,3));
            self.MIDI = [[0 0 self.durations(1,2)]; self.MIDI];
            [self.ColorNote,self.Position,self.Type]=Transcript(self.MIDI,self.blackTime,self.scale);
            %{
            self.instruments = '';
            
            if find(self.probable(:,3)==1)
                self.instruments = char(self.instruments,'Guitarra');
            end
            if find(self.probable(:,3)==1)
                self.instruments = char(self.instruments,'Piano');
            end
            
            self.instruments=self.instruments(2:end,:);

            set(self.handles.instrument_list,'String',self.instruments);
            %}
            i = 0;
            for i = 1:length(self.instrumentList)
%                 if 
%                 end
            end
            
            self.selectedInstrument = i;
            cla(self.musicSheet.h)
            self.musicSheet.drawStaff(self.musicSheet.h);
            cd('Pentagrama');
            
            for j=1:length(self.Type)
                self.musicSheet.maxX=2; %lo pongo aca porque sino no lo redefine
                self.musicSheet.noteColour = self.ColorNote(j);
                self.musicSheet.noteType = self.Type(j);
                self.musicSheet.yPosition = self.Position(j);
                
                if( j~=1 && self.MIDI(j,2)==self.MIDI(j-1,2))
                   self.musicSheet.xPosition = self.musicSheet.xPosition - (self.musicSheet.xSize + 0.025);
                end
                
                if(self.musicSheet.xPosition>self.musicSheet.maxX )
                    pentapic=figure('Position',[10000000000 255*10000000000 255*10000000000 255*10000000000]);
                    s = copyobj(self.handles.music_sheet_axis,pentapic);
                    print(pentapic,'-dpng','pentagrama.png');
                    imagen=imread('pentagrama.png');
                    imwrite(imagen([400:800],[20:1200],[1:3]),['Pentagrama',num2str(self.NumImagen),'.png'],'png');
                    close(pentapic);
                    self.NumImagen=self.NumImagen+1;
                    self.ActImagen=self.NumImagen;
                    
                    cla(self.handles.music_sheet_axis,'reset')
                    self.musicSheet = SheetMusic(self.hfig,self.handles.music_sheet_axis);
                    self.musicSheet.xPosition=0.28;       %empiezo de nuevo                  
                    self.musicSheet.noteColour = self.ColorNote(j);
                    self.musicSheet.noteType = self.Type(j);
                    self.musicSheet.yPosition = self.Position(j);                   
                end  
                
                self.musicSheet.getSymbol();
                
            end
            
            disp('Done');
            pentapic=figure('Position',[10000000000 255*10000000000 255*10000000000 255*10000000000]);
            s = copyobj(self.handles.music_sheet_axis,pentapic);
            print(pentapic,'-dpng','pentagrama.png');
            imagen=imread('pentagrama.png');
            imwrite(imagen([400:800],[20:1200],[1:3]),['Pentagrama',num2str(self.NumImagen),'.png'],'png');
            close(pentapic);
            myfinalpic=[];
            hojanum=1;
            for j=1:self.NumImagen
                imagen=imread(['Pentagrama',num2str(j),'.png']);
                myfinalpic=[myfinalpic;imagen];
                if((~mod(j,4))||(j==self.NumImagen))
                    imwrite(myfinalpic,['Hoja',num2str(hojanum),'.png'],'png');
                    myfinalpic=[];
                    hojanum=hojanum+1;
                end  
            end
                       
            cd('..');
            
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