% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\code\model-free\batch\None_dur2\sav_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
