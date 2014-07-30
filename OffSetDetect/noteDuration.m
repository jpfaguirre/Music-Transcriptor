%%HACER TODO DE CERO
function [num8,tempo] = noteDuration(times,notes,fs)
durs = zeros(1,length(times)-1);
for n = 1:length(durs)
    durs(n)=times(n+1)-times(n);
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