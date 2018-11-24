%T1file = '/home/eckhard/Documents/MATLAB/toolboxes/NeMo-master/mymfiles/spm8/templates/T1.nii';
%[pathstr,name,ext] = fileparts(T1file);
parfor i = 1:n
    subject = subjects(i).name;
    sprintf('Processing file %s (%d/%d)\n',subject,i,n)
    DamageFileName = [lesiondir filesep subject filesep subject '_cropped.nii'];
    StrSave = [outdir filesep visit filesep num2str(atlassize) filesep subject];
    if ~exist(StrSave,'dir'); mkdir(StrSave); end
    %copyfile(T1file, StrSave)
    
    %Coreg2MNI = struct('StructImageType','t1','ImageFileName',[StrSave filesep name ext]);
    Coreg2MNI = struct('StructImageType',{},'ImageFileName',{});
    CalcSpace = 'MNI';
    NumWorkers = 1;
    dispMask = true;
    coregOnly = false;
    
    if ~exist(StrSave,'dir'); mkdir(StrSave); end
    
    computechacosubject(DamageFileName,Coreg2MNI,CalcSpace,atlassize,StrSave,NumWorkers,dispMask,coregOnly, main_dir)
    
end


function computechacosubject(DamageFileName,Coreg2MNI,CalcSpace,atlassize,StrSave,NumWorkers,dispMask,coregOnly,main_dir)
    startup_varsonly
    ChaCoCalc(DamageFileName,Coreg2MNI,CalcSpace,atlassize,StrSave,NumWorkers,dispMask,coregOnly,main_dir)
end