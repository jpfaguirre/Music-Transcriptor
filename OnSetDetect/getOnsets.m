%%TENER DOS VALORES: ONSET DE CANCION QUE SEA EL MINIMO ANTERIOR Y ONSET
%%PARA PITCH QUE SEA EL MAXIMO QUE AGARRO AHORA
function onSet = getOnsets(in)
	%%DESPUES ANALIZAR PARA ENCONTRAR EL MEJOR FILTRO FIR Y ENTENDER QUE
	%%HACE
    flow = 1;
    peak_low = 0.2;
    i=1;
    
    DownsampleFactor = 15;
    
    hlowpass1 = dsp.FIRFilter('Numerator', firpm(20, [0 0.03 0.1 1], [1 1 0 0]));
    time = sqrt(filter((hlowpass1.Numerator),1, downsample(2*in.*in, DownsampleFactor)));
    time = sqrt(filter((hlowpass1.Numerator),1, downsample(2*time.*time, DownsampleFactor)));
    time = time/max(time);
    while flow<length(time)
        %NO PONER THRESHOLD Y DESPUES BUSCAR UN DELTA DE ALTURA ENTRE
        %MAXIMO Y MINIMO Y ALGO CON LA DISTANCIA NO SE PENSA
        %QUILOMBO CON EL THRESHOLD
        threshold = max(peak_low,0.2);
        for p=flow:length(time)-1
            if time(p)>time(p+1) && time(p)>threshold
                fpeak = p;
                break
            end
        end
        
        if isempty(fpeak)
            break
        end
        
        peak_height = time(fpeak);
        
        for p=fpeak:length(time)
            if time(p) < 0.5*time(fpeak)
                flow = p;
                break
            end
        end
        if fpeak > flow
            flow = length(time);
        end
        
        peak_low = time(flow);
        [~,onSet(i)] = max(time(fpeak:flow));
        onSet(i) = onSet(i) + fpeak;
        

        if i~=1 && onSet(i) == onSet(i-1)
            break
        end
        i = i+1;
    end
    onSet(end) = [];
    onSet = onSet / length(time) * length(in);
end