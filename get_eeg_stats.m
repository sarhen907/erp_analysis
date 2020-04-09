function get_eeg_stats()

% this function will export stats for choir study tasks 
% user must make sure that paths, windows, electrodes are correct

tasklist = ["oddball", "sinactive","sinpassive"];
grouplist = ["choir", "control"];
measures = ["lat","amp"];


for j = 1:length(tasklist)
    basebase = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/';
    
    if tasklist(j) == "oddball"
        pathbase = strcat(basebase,'oddball_visit2/');
        binlist = [1;3;5];
        complist = ["P3"];


    elseif tasklist(j) == "sinactive"
        pathbase = strcat(basebase, 'SIN_active_visit2/');
        binlist = [1;3;5;7];
        complist = ["P1", "N1", "P2"];


    elseif tasklist(j) == "sinpassive"
        pathbase = strcat(basebase, 'SIN_passive_visit2/');
        binlist = [1:4];
        complist = ["P1", "N1", "P2"];
    end
    
    for i = 1:length(grouplist)
        if grouplist(i) == "choir"
            path = strcat(pathbase, 'choir/choirlist.txt');
        elseif  grouplist(i) == "control"
            path = strcat(pathbase, 'control/controllist.txt');
        end
        
        for k = 1:length(binlist)
            
            if tasklist(j) == "oddball"
             
                electrodes = [  8 12:14 19 23:25];
                binlist = [1;3;5];

            elseif tasklist(j) == "sinactive"
               
                binlist = [1;3;5;7];
                electrodes = [ 2 3 7 8 12 23:25 29 30];

            elseif tasklist(j) == "sinpassive"
                pathbase = strcat(basebase, 'SIN_passive_visit2/');
                binlist = [1:4];
                electrodes = [ 2 3 7 8 12 23:25 29 30];
    
            end
            
            
            for m = 1:length(measures)
                    
                if measures(m) == "lat"
                    measurecommand = 'peaklatbl';
                elseif measures(m) == "amp"
                    measurecommand = 'meanbl';
                end 
                
                for n = 1:length(complist)
                    
                    outfile = sprintf('%s_visit2_%s_%s_bin%d_%s.txt', grouplist(i), tasklist(j), complist(n), binlist(k),measures(m));
                    
                    if tasklist(j) == "oddball"
                        
                        window = [ 280 645];
              
                    elseif tasklist(j) == "sinactive"
                        
                        if binlist(k) == 1
                            if complist(n) == "P1"
                                window = [];
                            elseif complist(n) == "N1"
                                window = [];
                            elseif complist(n) == "P2"
                                window = [];
                            end
                        elseif binlist(k) == 3
                            if complist(n) == "P1"
                                window = [];
                            elseif complist(n) == "N1"
                                window = [];
                            elseif complist(n) == "P2"
                                window = [];
                            end
                        elseif binlist(k) == 5
                            if complist(n) == "P1"
                                window = [];
                            elseif complist(n) == "N1"
                                window = [];
                            elseif complist(n) == "P2"
                                window = [];
                            end
                        elseif binlist(k) == 7
                            if complist(n) == "P1"
                                window = [];
                            elseif complist(n) == "N1"
                                window = [];
                            elseif complist(n) == "P2"
                                window = [];
                            end
                        end
                   
                    elseif tasklist(j) == "sinpassive"
                       
                        if binlist(k) == 1
                            if complist(n) == "P1"
                                window = [];
                            elseif complist(n) == "N1"
                                window = [];
                            elseif complist(n) == "P2"
                                window = [];
                            end
                        elseif binlist(k) == 2
                            if complist(n) == "P1"
                                window = [];
                            elseif complist(n) == "N1"
                                window = [];
                            elseif complist(n) == "P2"
                                window = [];
                            end
                        elseif binlist(k) == 3
                           if complist(n) == "P1"
                                window = [];
                            elseif complist(n) == "N1"
                                window = [];
                            elseif complist(n) == "P2"
                                window = [];
                            end
                        elseif binlist(k) == 4
                            if complist(n) == "P1"
                                window = [];
                            elseif complist(n) == "N1"
                                window = [];
                            elseif complist(n) == "P2"
                                window = [];
                            end
                        end
                        
                    end

                    ALLERP = pop_geterpvalues( path, window,  binlist(k),...
                 electrodes , 'Baseline', 'pre', 'FileFormat', 'long', 'Filename', outfile, 'Fracreplace',...
                 'NaN', 'InterpFactor',  1, 'Measure', measurecommand, 'PeakOnset',  1, 'Resolution',  3 )
                end
            end
        end 

     end
end

