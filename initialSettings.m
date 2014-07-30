function initialSettings(self)

           % Initializa la GUI
           addpath(genpath(pwd));
           
           hfig = hgload('MusicMan.fig'); % load 'GUIDE generated' Figure.
           self.handles = guihandles(hfig); % get figure handles.
           movegui(hfig,'center')   % sets Figure position.
           
           self.musicSheet = SheetMusic(hfig,self.handles.music_sheet_axis);
           self.instrumentList = char('Guitarra', 'Piano'); 
           
           
           template = load('piano3.mat');
           self.instrumentPattern(:,1) = template.instrument;
           self.fundamental(1) = template.fundamental;
end  