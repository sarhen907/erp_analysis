function postica_SINactive()

%read_path  = '/Volumes/MusicProject/Choir_Study/Data/EEG/Raw EEG Data /SIN';
write_path = '/Volumes/MusicProject/Choir_Study/Data/EEG/final/eeglab/SINactivemorefiles';

% main program loop scanning for data files
% -----------------------------------------
%files=dir(read_path);
%errors = {'errors'};


%allsbjs = '/Volumes/MusicProject/Choir_Study/Data/EEG/final/eeglab/SIN_active_visit2';
allsbjs = '/Volumes/MusicProject/Choir_Study/Data/EEG/final/eeglab/SIN_active';


folders = dir(allsbjs);

folders_cell = struct2cell(folders);

file_locations = [];

for i = 4:2:length(folders)
    
    
    path = strcat(allsbjs, '/');
  % vhdrfilepath = strcat(path, fileadd, '_SIN_active.vhdr')
    
    file = folders(i).name;
    dataName = file(1:22);
    
    file

    %filepath = strcat(allsbjs, fileadd, '_SIN','.vhdr')
    
   
    
%      loadName=allfiles(n).name;
%     
%     dataName=loadName(1:end-5)

       
    % Step2: Import data.
    EEG = pop_loadset(folders(i).name, folders(i).folder)
    %    EEG.setname = dataName;
    
    EEG = pop_eegfiltnew(EEG, 1,20,1650,0,[],0);
% Save as "...fil"
   % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew',[dataName ' fil'],'gui','off');

% Load the changed file in the EEGLAB window and plot it
     
  %  [ALLEEG EEG CURRENTSET] = pop_newset( ALLEEG, EEG, CURRENTSET, 'setname', dataName );
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist',...
         [write_path '/' dataName 'event.txt']); % GUI: 30-Oct-2019 15:02:29
     
     
 %   [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew',[dataName ' fil elist'],'gui','off');
    
    EEG  = pop_binlister( EEG , 'BDF', '/Volumes/MusicProject/AllMatlabScripts/EEG/Choir Study/SIN_binlister.txt', 'IndexEL',  1, 'SendEL2',...
 'EEG', 'Voutput', 'EEG' );

%    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew',[dataName ' fil elist bins'],'gui','off');
    
    EEG = pop_epochbin( EEG , [-200.0  800.0],  [ -200 0]); % GUI: 04-Apr-2020 23:35:16
    
    EEG  = pop_artextval( EEG , 'Channel',  1:32, 'Flag',  1, 'Threshold', [ -150 150], 'Twindow', [ -200 796] ); %
    
    erpname = strcat(dataName, '.erp');
    
    %erpsetpath =  '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/SIN_active_visit2';
    erpsetpath =  '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/SIN_active';
    
    ERP = pop_averager(EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', dataName, 'filename', erpname, 'filepath', erpsetpath, 'Warning', 'on');

    
    
end

%  
%         
%         
%% Grand averages 

groupList = ["choir","control"];



%allerpsets = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/SIN_active_visit2';
allerpsets = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/SIN_active';

for k = 1:length(groupList)
    
    %make a list if you haven't yet. 
     folder = strcat(allerpsets , sprintf('/%s', groupList(k)));
     erpdir = dir(folder);
     mylist = [];
     excludelist = ['06CB_visit2_SIN_active.erp'];
     %listpath = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/SIN_active_visit2/';
     listpath = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/SIN_active/';
     listname = strcat(listpath, sprintf('%slist.txt', groupList(k)));
%     fid = fopen(listname, 'w');  
%     
%     for i = 1:length(erpdir)
%         if endsWith(erpdir(i).name,".erp") ==1 && ~any(strcmp(excludelist,erpdir(i).name))
%             fullname = strcat(erpdir(i).folder, "/", erpdir(i).name);
%             fprintf(fid, fullname);
%             fprintf(fid, '\n');
%         end
%     end
    
%     fclose(fid);

    %erpname = sprintf('SINactive_%s_visit2_grandaverage', groupList(k));
    erpname = sprintf('SINactive_%s_visit1_grandaverage', groupList(k));
    filename = strcat(erpname, '.erp');
   % filepath = '/Volumes/MusicProject/Choir_Study/Data/EEG/gradaverages/Visit2/SINactive/';
    filepath = '/Volumes/MusicProject/Choir_Study/Data/EEG/gradaverages/Visit1/SINactive/';
    txtname = strcat(filepath, sprintf('txtexports/SINactive_%s_weighted_average.txt', groupList(k)));
    semtxtname = strcat(filepath, sprintf('txtexports/SINactive_%s_SEM.txt', groupList(k)));

    ERP = pop_gaverager( listname , 'SEM', 'on', 'Weighted',...
     'on' );

    ERP = pop_savemyerp(ERP, 'erpname', erpname, 'filename', filename, 'filepath',...
     filepath, 'Warning', 'on');

    %baseline remove
    ERP = pop_blcerp( ERP , 'Baseline', [ -200 0], 'Saveas', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', erpname ,...
     'filename', filename, 'filepath', filepath, 'Warning', 'on');

    % switch to SEM
    ERP2 = make_SEM_set(ERP); 
    trialexplorer(ERP2.filename,ERP2.filepath)
    pop_export2text( ERP2, semtxtname,  1:2:7, 'electrodes', 'on',...
     'precision',  4, 'time', 'on', 'timeunit',  0.001, 'transpose', 'off' );

    %filter
    ERP = pop_filterp( ERP,  1:34 , 'Cutoff',  20, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );

    % export to text
    pop_export2text( ERP, txtname,  1:2:7, 'electrodes', 'on',...
     'precision',  4, 'time', 'on', 'timeunit',  0.001, 'transpose', 'off' );

    % trial explorer
    trialexplorer(ERP.filename,ERP.filepath)
end

fprintf("\ngreat job. you've finished post ICA processing for SINactive. now, go do your other tasks, and run ''get_eeg_stats.m''\n")
   
    
end




