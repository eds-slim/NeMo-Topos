asz=86;
load(sprintf('./ChaCo%d.mat',asz))

%% remove a1004
subjects = subjects(1:end-1)

%%

subjID=cellfun(@(s)(str2num(s(1:4))),{subjects.name})';
Region = (1:numel(CD.labels))';

CD.mean = CD.mean(1:end-1,:);
ChaCO_mean = reshape(CD.mean,[prod(size(CD.mean)),1])

CD.sd = CD.sd(1:end-1,:);
ChaCO_std = reshape(CD.sd,[prod(size(CD.sd)),1])

filename=sprintf('ChaCoNew%d.txt', asz);
fid=fopen(filename,'w');
fprintf(fid,'subjID,Region,ChaCo_mean,ChaCo_std\n');
fclose(fid);

M=[repmat(subjID,[numel(CD.labels),1]),...
    kron(Region,ones([numel(subjID),1])),...
    ChaCO_mean, ChaCO_std];

dlmwrite(filename,M,'-append')