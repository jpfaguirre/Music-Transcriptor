function [probable] = pitchDetect(in,onSet,instr_num,instruments,fundamental,fs)
        
    %Compara los posibles resultados
    k=1;
    for j=1:length(onSet)
        %Elegir ventana centrada en el onSet, y no de aca para adelante
        if (ceil(onSet(j))+4096)<length(in)
            signal = in(ceil(onSet(j)):(ceil(onSet(j))+4096));%tira error cuando se toca algo al final
        end
        
        spec = abs(fftshift(fft(signal)))/length(signal);
        spec = spec(round(length(spec)/2):end)/max(spec);
        [~, spec_max] = max(spec);
        spec_max = spec_max*fs/length(spec);
        axis = fs/2*linspace(0,1,length(spec));
        threshold = 0.5*max(spec);
        %%j==k miente mas que clarin
        while max(spec)>threshold
            clear possible possible_amplitud possible_location_index correlation
            possible_amplitud = findpeaks(spec,'MINPEAKHEIGHT',0.4*max(spec));
            possible_location_index= ismember(spec,possible_amplitud);
            possible = axis(possible_location_index);
            
            for i=1:length(possible)
                pattern = denormalize(instruments,spec,possible(i),fundamental,fs);
                [~, patt_max] = max(pattern);
                patt_max = patt_max*fs/length(pattern);

                corr = xcorr(pattern,spec,'coeff');
                correlation(i)= corr(length(pattern)); %menos cuentas
                new_corr(i) = max(corr);

            end
        
            %Poner umbral de correlacion
            %Poner que elija en funcion de la amplitud
            value_possible =  correlation + possible_amplitud;
            probable(k,1) = min(possible(value_possible==max(value_possible)));
            probable(k,2) = onSet(j)/fs;
            
            pattern = denormalize(instruments,spec,min(possible(correlation==max(correlation))),fundamental,fs);
            
            
            %%
            %Corregir esta linea y funca todo de diez
            %%Arreglar esto para que lo haga mas piola
            %No deberia hacer falta, mejorar la alineacion
            %pattern = align_pattern2(pattern,spec,probable(k,1),fundamental,fs); %alinear con interp1 'nearest' al espectro real
            %
            
            
            pattern = max(spec)*pattern/max(pattern);
            spec = spec - pattern;
            spec(spec<0)=0;
            k = k+1;
        end
    end
end

%REESCRIBIR: QUE BUSQUE LOS PICOS, ALINIE EL MAXIMO CON EL MAXIMO, Y DIVIDA
%EN VENTANAS POR PICOS PARA ALINEAR EL MAXIMO POR VENTANA :)
%IDEA: DETECTAR LOS PICOS Y HACE UNA TABLITA CON LAS VENTANAS EN CADA CASO
%Y ALINEAR LOS CORRESPONDIENTES BUSCANDO EL MAXIMO EN LAS VENTANAS
function [aligned_pattern] = align_pattern(pattern,spec,fs)
    axis = fs/2*linspace(0,1,length(pattern));
    
    pattern_peak = findpeaks(pattern,'MINPEAKHEIGHT',0.25*max(pattern),'MINPEAKDISTANCE',10);%MAL THRESHOLD
    pattern_peak_location = ind2sub(size(pattern),find(ismember(pattern,pattern_peak)));
    pattern = pattern/max(pattern)*max(spec);
    
    spec_peak = findpeaks(pattern,'MINPEAKHEIGHT',0.1*max(spec),'MINPEAKDISTANCE',10);%MAL THRESHOLD
    spec_peak_location = ind2sub(size(spec),find(ismember(spec,spec_peak)));
    
    out_pattern = zeros(size(spec));
    correction = 0;
    
    
end

function [out_pattern] = align_pattern2(pattern,spec,frequency,fundamental,fs)
    axis = fs/2*linspace(0,1,length(pattern));
    peak = findpeaks(pattern,'MINPEAKHEIGHT',0.1*max(pattern),'MINPEAKDISTANCE',10);%MAL THRESHOLD
    out_pattern = zeros(size(spec));
    correction = 0;
    peak_location = ind2sub(size(pattern),find(ismember(pattern,peak)));
    pattern = pattern/max(pattern)*max(spec);
    
    for i=1:length(peak)
        if i==1
            window_length = abs((peak_location(i)-peak_location(i+1))/2);
        else
            window_length = abs((peak_location(i)-peak_location(i-1))/2);
        end        
        peak_start = ceil(peak_location(i)-window_length);
        if peak_start<1
            peak_start=1;
        end
        peak_end = ceil(peak_location(i)+window_length);
        
        index_start = frequency/fundamental*peak_location(i)-window_length;
        if index_start<1
            correction = ceil(abs(index_start));
            index_start=1;
        end
        if ((peak_end-peak_start)+index_start-correction)>length(out_pattern)
            index_end=length(out_pattern);
            peak_end = peak_start + correction - ((peak_end-peak_start)+index_start-correction) + index_end ;
        else
            index_end = ((peak_end-peak_start)+index_start-correction);
        end
        
        spec_peaks = findpeaks(spec,'MINPEAKHEIGHT',0.1*max(spec),'MINPEAKDISTANCE',10);
        spec_peak_locations = ind2sub(size(spec),find(ismember(spec,spec_peaks)));
        
        correction_index = interp1(spec_peak_locations,spec_peak_locations,round(frequency/fundamental*peak_location(i)),'nearest','extrap');
        
        for j = peak_location(i):-1:peak_start
            out_pattern(correction_index-peak_location(i)+j)=out_pattern(correction_index-peak_location(i)+j)+pattern(j); 
        end
        
        for j = peak_location(i)+1:1:peak_end
            out_pattern(correction_index+j-peak_location(i))=out_pattern(correction_index+j-peak_location(i))+pattern(j);
        end
        
    end
end

%%ESTO ESTARIA FUNCIONANDO MAL
function [out_pattern] = denormalize(pattern,spec,frequency,fundamental,fs)
    axis = fs/2*linspace(0,1,length(pattern));
    peak = findpeaks(pattern,'MINPEAKHEIGHT',0.1*max(pattern),'MINPEAKDISTANCE',10);%MAL THRESHOLD
    out_pattern = zeros(size(spec));
    correction = 0;
    peak_location = ind2sub(size(pattern),find(ismember(pattern,peak)));
    pattern = pattern/max(pattern)*max(spec);
    harmonic_counter = 0;
    
    for i=1:length(peak)
        if length(peak)~=1
            if i==1
                window_length = abs((peak_location(i)-peak_location(i+1))/2);
            else
                window_length = abs((peak_location(i)-peak_location(i-1))/2);
            end
        else
            window_length = peak_location/4;
        end
        peak_start = ceil(peak_location(i)-window_length);
        if peak_start<1
            peak_start=1;
        end
        peak_end = ceil(peak_location(i)+window_length);
        
        index_start = frequency/fundamental*peak_location(i)-window_length;
        if index_start<1
            correction = ceil(abs(index_start));
            index_start=1;
        end
        if ((peak_end-peak_start)+index_start-correction)>length(out_pattern)
            index_end=length(out_pattern);
            peak_end = peak_start + correction - ((peak_end-peak_start)+index_start-correction) + index_end ;
        else
            index_end = ((peak_end-peak_start)+index_start-correction);
        end
        %out_pattern(floor(index_start:index_end))=out_pattern(floor(index_start:index_end))+pattern((peak_start+correction):peak_end)';%La
        %que funciona;
        %%Alinear peak con peak y que el resto se cague
        peak_in = findpeaks(spec,'MINPEAKHEIGHT',0.1*max(spec),'MINPEAKDISTANCE',ceil(frequency/fundamental/2*fs/2/length(spec)));%MAL THRESHOLD
        peak_in_location = ind2sub(size(spec),find(ismember(spec,peak_in)));
        if length(peak_in_location) > 1
            new_peak = interp1(peak_in_location,peak_in_location,frequency/fundamental*peak_location(i),'nearest','extrap');
        else
            new_peak = peak_in_location;
        end
        
        %Interpolar los ceros que quedan en el medio
        
%         for j = peak_location(i):-1:peak_start
%             position = round(frequency/fundamental*j);
%             out_pattern(position)=out_pattern(position)+pattern(j); 
%         end
%         for j = peak_location(i)+1:1:peak_end
%             position = round(frequency/fundamental*j);
%             %Ver sin extrap si agarra mejor y no condensa toda la infor en
%             %el ultimo (puede estar peteandola por eso
%             if position<=length(out_pattern) && position<=max(peak_in_location+5)
%                 out_pattern(position)=out_pattern(position)+pattern(j);
%             end
%         end
        if harmonic_counter<length(peak_in)
            for j = peak_location(i):-1:peak_start
                out_pattern(new_peak-peak_location(i)+j)=out_pattern(new_peak-peak_location(i)+j)+pattern(j); 
            end
            for j = peak_location(i)+1:1:peak_end
                %Ver sin extrap si agarra mejor y no condensa toda la infor en
                %el ultimo (puede estar peteandola por eso
                if (new_peak-peak_location(i)+j)<=length(out_pattern) && (new_peak-peak_location(i)+j)<=max(peak_in_location+5)
                    out_pattern((new_peak-peak_location(i)+j))=out_pattern((new_peak-peak_location(i)+j))+pattern(j);
                end
            end
            harmonic_counter = harmonic_counter + 1;
        end
    end
end


function [window] = get_window(data,frequency,fs)
    axis = fs/4*linspace(0,1,length(data));
    i = round(log(frequency/440)/log(2)*12);
    width = 440*(2.^(i/12)-2.^((i-1)/12));
    window = axis>(frequency-width/2) & axis<(frequency+width/2);
end