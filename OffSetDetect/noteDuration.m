%%HACER TODO DE CERO
%%
%{
Veo cuando empieza cada nota
Tengo un vector de notas y cuando arrancan
Me fijo en los onSet si siguen estando las notas del vector y si no estan
son nuevas
Calculo el tiempo asi
%}
function [duration] = noteDuration(times,notes,audio,fs)
    current_notes = [];
    notes_times = [];
    current_time = times(1);
    k = 1;
    for i=1:length(times)
        if ~isempty(current_notes)
            signal = audio(max(ceil(times(i)*fs)-4*4096,1):(max(ceil(times(i)*fs)-4*4096,1)+4096));
            spec = abs(fftshift(fft(signal)))/length(signal);
            spec = spec(round(length(spec)/2):end)/max(spec);
            spec = spec/max(spec);
            axis = fs/2*linspace(0,1,length(spec));
            length_current_notes = length(current_notes);
            %j = 1;
            current_notes = current_notes(current_notes~=0);
            notes_times = notes_times(notes_times~=0);
            for j=1:length(current_notes)
                if spec(ceil(current_notes(j)/fs*length(spec)))<0.4*max(spec) && times(i) > notes_times(j)
                    duration(k,1) = current_notes(j);
                    duration(k,2) = notes_times(j);
                    duration(k,3) = times(i) - notes_times(j);
                    current_notes(j) = 0;
                    notes_times(j) = 0;
                    %if j>1
                    %    current_notes = current_notes([1,(j-1)], [(j+1):end]);
                    %    notes_times = notes_times([1,(j-1)], [(j+1):end]);
                    %else
                    %    current_notes = current_notes([(j+1):end]);
                    %    notes_times = notes_times([(j+1):end]);
                    %end
                    %length_current_notes = length_current_notes-1;
                    k = k+1;
                else
                    j = j+1;
                end
            end
        end
        current_notes = [current_notes, notes(i)];
        notes_times = [notes_times, times(i)];
        current_time = times(i);
        

    end
end
%{
function [num8,tempo] = noteDuration(times,notes,fs)
durs = zeros(1,length(times)-1);
for n = 1:length(durs)
    durs(n)=times(n+1)-times(n);
end
for n = length(durs)-1:-1:1
    if durs(n)==0
        durs(n)=durs(n+1);
    end
end
dist=zeros(1,ceil(max(durs)/1000)*1000);
for n = 1:length(durs)
    dist(durs(n))=dist(durs(n))+1;
end
N = 60;
histdist=histc(durs,0:ceil(length(dist)/N):length(dist));
[val,loc]=max(histdist);
loc = (loc-.5)*length(dist)/N;
quarter=avex2(dist(ceil(loc*7/8):min(length(dist),floor(loc*9/8))),ceil(loc*7/8));
num8=round(2*durs/quarter);
tempo = 60*fs/quarter;
end

function x = avex2(f,start)
if (nargin < 2)
    start = 1;
end
x = sum(([1:length(f)]+start-1).*f)/sum(f);
end
%}