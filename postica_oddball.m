function postica_oddball()

groupList = ["choir","control"];



%read_path  = '/Volumes/MusicProject/Choir_Study/Data/EEG/Raw EEG Data /SIN';

write_path = '/Volumes/MusicProject/Choir_Study/Data/EEG/final/eeglab/oddballmorefiles';

%write_path = '/Users/Sarah/Desktop/morefiles';


% main program loop scanning for data files
% -----------------------------------------
%files=dir(read_path);
%errors = {'errors'};


allsbjs = '/Volumes/MusicProject/Choir_Study/Data/EEG/final/eeglab/oddball';
%allsbjs = '/Volumes/MusicProject/Choir_Study/Data/EEG/final/eeglab/oddball_visit2';
%allsbjs =   '/Users/Sarah/Desktop/final';


folders = dir(allsbjs);

folders_cell = struct2cell(folders);

file_locations = [];

%for i = 5:2:length(folders)
for i = 5:2:length(folders)
    
    
    path = strcat(allsbjs, '/');
  % vhdrfilepath = strcat(path, fileadd, '_SIN_active.vhdr')
    
    file = folders(i).name;
    dataName = file(1:19);
    
    file

    %filepath = strcat(allsbjs, fileadd, '_SIN','.vhdr')
    
   
    
%      loadName=allfiles(n).name;
%     
%     dataName=loadName(1:end-5)

       
    % Step2: Import data.
    EEG = pop_loadset(folders(i).name, folders(i).folder);
    %    EEG.setname = dataName;
    
    EEG = pop_eegfiltnew(EEG, 1,20,1650,0,[],0);
% Save as "...fil"
   % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew',[dataName ' fil'],'gui','off');

% Load the changed file in the EEGLAB window and plot it
     
  %  [ALLEEG EEG CURRENTSET] = pop_newset( ALLEEG, EEG, CURRENTSET, 'setname', dataName );
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist',...
         [write_path '/' dataName 'event.txt']); % GUI: 30-Oct-2019 15:02:29
     
     
 %   [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew',[dataName ' fil elist'],'gui','off');
    
    EEG  = pop_binlister( EEG , 'BDF', '/Volumes/MusicProject/AllMatlabScripts/EEG/Choir Study/Oddball_binlister.txt', 'IndexEL',  1, 'SendEL2',...
 'EEG', 'Voutput', 'EEG' );

%    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew',[dataName ' fil elist bins'],'gui','off');
    
    EEG = pop_epochbin( EEG , [-200.0  1000.0],  [ -200 0]); % GUI: 04-Apr-2020 23:35:16
    
     EEG  = pop_artextval( EEG , 'Channel',  1:32, 'Flag',  1, 'Threshold', [ -150 150], 'Twindow', [ -200 996] ); %
     
     erpname = strcat(dataName, '.erp');
     
     
     
     erpsetpath =  '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/oddball';
     %erpsetpath =  '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/oddball_visit2';
     %  erpsetpath = '/Users/Sarah/Desktop/erpset';
     
     ERP = pop_averager(EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
     ERP = pop_savemyerp(ERP, 'erpname',...
         dataName, 'filename', erpname, 'filepath', erpsetpath, 'Warning', 'on');
 
     
     
    
    
end


%% Grand averages 

%varNames = {'time?Fp1?Fz?F3?F7?FT9?FC5?FC1?C3?T7?TP9?CP5?CP1?Pz?P3?P7?O1?Oz?O2?P4?P8?TP10?CP6?CP2?Cz?C4?T8?FT10?FC6?FC2?F4?F8?Fp2?VEOG?HEOG?'};

allerpsets = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/oddball';
%allerpsets = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/oddball_visit2';
groupList = ["choir","control"];

for k = 1:length(groupList)
    
    %make a list if you haven't yet. 
     folder = strcat(allerpsets , sprintf('/%s', groupList(k)));
     erpdir = dir(folder);
     mylist = [];
     excludelist = ['03CS_visit2_oddball.erp'];
     %listpath = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/oddball_visit2/';
     listpath = '/Volumes/MusicProject/Choir_Study/Data/EEG/erp_sets/oddball/';
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

   
    erpname = sprintf('oddball_%s_visit1_grandaverage', groupList(k));
    %erpname = sprintf('oddball_%s_visit2_grandaverage', groupList(k));
    filename = strcat(erpname, '.erp');
    filepath = '/Volumes/MusicProject/Choir_Study/Data/EEG/gradaverages/Visit1/oddball/';
    %filepath = '/Volumes/MusicProject/Choir_Study/Data/EEG/gradaverages/Visit2/oddball/';
    txtname = strcat(filepath, sprintf('txtexports/oddball_%s_weighted_average.txt', groupList(k)));
    semtxtname = strcat(filepath, sprintf('txtexports/oddball_%s_SEM.txt', groupList(k)));

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
    pop_export2text( ERP2, semtxtname,  1:2:5, 'electrodes', 'on',...
     'precision',  4, 'time', 'on', 'timeunit',  0.001, 'transpose', 'off');

    %filter
    ERP = pop_filterp( ERP,  1:34 , 'Cutoff',  20, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );

    % export to text
    pop_export2text( ERP, txtname,  1:2:5, 'electrodes', 'on',...
     'precision',  4, 'time', 'on', 'timeunit',  0.001, 'transpose', 'off' );

    % trial explorer
    trialexplorer(ERP.filename,ERP.filepath)
end

fprintf("\ngreat job. you've finished post ICA processing for oddball. now, go do your other tasks, and run ''get_eeg_stats.m''\n")

end