# erp_analysis
scripts for erp analysis in eeglab/erplab

Created for usc b&M lab's choir study, for 3 different eeg tasks:

1. oddball
2. Syllable-in-noise active
3. Syllable-in-noise passive


Order of scripts: 
prior to running these:
1. Pre-ica processing 
2. ICA (runica.m, not included here)
3. Postica_oddball.m, postica_SINpassive.m, etc 
    a) These scripts will ALSO run trialexplorer.m
    b) For this to run (grandaverage section), need to make a txt file of files per group. 
4. choose timewindows, look at data, plot grand averages, etc etc.
5. Get_eeg_stats.m (make sure to edit relevant sections based on chosen windows, electrodes,etc.)
6. Eeg_oddball_stats.py , eeg_SINpassive_stats.py, etc. 
7. THEN, you can put stuff in R and run whatever stats you would like
