
%atlassize = 116;

outdir = fileparts(which('computechaco.m'));
basedir = '/mnt/data/ToposNemo';
lesiondir = [basedir filesep num2str(atlassize)];

cd(outdir)
% location of tractogram data
startup_varsonly
%main_dir = [start_dir filesep '..' filesep 'Tractograms' filesep];
main_dir = '/mnt/data/Tractograms/';
nTract = numel(dir([main_dir 'FiberTracts116_MNI_BIN' filesep 'e*']));

subjects = dir(lesiondir);
subjects = subjects(3:end);
n = length(subjects);


computechaco
analysechaco
plotchaco