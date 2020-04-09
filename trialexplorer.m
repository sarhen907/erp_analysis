function trialexplorer(filename, path)

ERP = pop_loaderp( 'filename', filename, 'filepath',...
 path );
Bins = (1:length(ERP.ntrials.accepted))';
accepted = ERP.ntrials.accepted';
rejected = ERP.ntrials.rejected';
invalid = ERP.ntrials.invalid';

T = table(Bins, accepted, rejected, invalid);

txtname = sprintf('%s/%s.txt',filepath,filename);

writetable(T, txtname);


