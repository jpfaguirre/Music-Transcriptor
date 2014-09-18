function initialSettings(self)

           % Initializa la GUI
           addpath(genpath(pwd));
           
           hfig = hgload('MusicMan.fig'); % load 'GUIDE generated' Figure.
           self.handles = guihandles(hfig); % get figure handles.
           movegui(hfig,'center')   % sets Figure position.
           
           self.musicSheet = SheetMusic(hfig,self.handles.music_sheet_axis);
           self.instrumentList = char('Guitarra', 'Piano', 'Flauta'); 
           set(self.handles.instrument_list,'String',self.instrumentList);
           self.instr_num=1;
           
           template = load('guitar2.mat');
           self.instrumentPattern(:,1) = template.instrument;
           self.fundamental(1) = template.fundamental;
           
           template = load('piano3.mat');
           self.instrumentPattern(:,2) = template.instrument;
           self.fundamental(2) = template.fundamental;
           
           template = load('flute.mat');
           self.instrumentPattern(:,3) = template.instrument;
           self.fundamental(3) = template.fundamental;
           
           self.NumImagen=1;
           self.ActImagen=1;

end  