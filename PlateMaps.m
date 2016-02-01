%% Map yo Plates
% generates exploratory figures from tecan plate data. accepts data post
% processing by max growth rate script (as csv)
%
%
% ~~~~~~~~

%% Initialize Directory
dirMain = 'C:/Users/Catherine/Documents/IAME/IAME_Code';
addpath(genpath(dirMain))

% set directory of files
folder = 'toAnalyze';
dirData = strcat('C:/Users/Catherine/Documents/IAME/IAME_Code/data/',folder);
cd(dirData)

plates = ls;
plates(1:2,:) = [];                 % file names of plates
nPlates = length(plates(:,2));      % number of plates

clear('dirMain','dirData')

%% Conditions and Well Indicies
% cell of conditions (complete)
C1 = {'Plasmid_';'Control_'};
C2 = {'L-ara';'D-ara';'NoSugar'};
C = fullfact([length(C1),length(C2)]);
for i = 1:length(C(:,1))
    conds(i) = strcat(C1(C(i,1)), C2(C(i,2)));
end
conds = conds';

% well index
W1 = {'A','B','C','D','E','F','G','H'};
W2 = 1:12;
W = fullfact([length(W1),length(W2)]);
%W = repmat(W,nPlates,1);
for i = 1:length(W(:,1))
    welldex(i) = strcat(W1(W(i,1)),int2str(W2(W(i,2))));
end
welldex = welldex';

clear('i','C1','C2','C','W1','W2')

%% Get Data from Files and Store
for i = 1:nPlates
    disp(plates(i,:))
    data = importFile(plates(i,:));
    GR(:,i) = data(:,2);
    OD(:,i) = data(:,5);
end

% remove boarders
GR(W(:,1)==1,:)=[];
OD(W(:,1)==1,:)=[];
W(W(:,1)==1,:)=[];
GR(W(:,1)==8,:)=[];
OD(W(:,1)==8,:)=[];
W(W(:,1)==8,:)=[];
clear('data','i')
disp('data loaded!')

%% Generate Matricies of Data Split by Condition
% based on knowledge of plate (boo.)

% populate sugar free data
PN_GR = [];
PN_OD = [];
CN_GR = [];
CN_OD = [];

for i = 1:3
    PN_GR(:,(2*i-1):2*i,1) = [GR(W(:,2)==6,i) GR(W(:,2)==11,i)];
    PN_OD(:,(2*i-1):2*i,1) = [OD(W(:,2)==6,i) OD(W(:,2)==11,i)];
    PN_GR(:,(2*i-1):2*i,2) = [GR(W(:,2)==6,i+6) GR(W(:,2)==11,i+6)];
    PN_OD(:,(2*i-1):2*i,2) = [OD(W(:,2)==6,i+6) OD(W(:,2)==11,i+6)];
    CN_GR(:,(2*i-1):2*i,1) = [GR(W(:,2)==6,i+3) GR(W(:,2)==11,i+3)];
    CN_OD(:,(2*i-1):2*i,1) = [OD(W(:,2)==6,i+3) OD(W(:,2)==11,i+3)];
    CN_GR(:,(2*i-1):2*i,2) = [GR(W(:,2)==6,i+9) GR(W(:,2)==11,i+9)];
    CN_OD(:,(2*i-1):2*i,2) = [OD(W(:,2)==6,i+9) OD(W(:,2)==11,i+9)];
end

% populate L and D data
PL_GR = [];
PL_OD = [];
CL_GR = [];
CL_OD = [];
PD_GR = [];
PD_OD = [];
CD_GR = [];
CD_OD = [];

for i = 1:3
    for r = [2,7;3,8;4,9;5,10]'
        PL_GR(:,(2*i-1):2*i,r(1)==2:5) = [GR(W(:,2)==r(1),i) GR(W(:,2)==r(2),i)];
        PL_OD(:,(2*i-1):2*i,r(1)==2:5) = [OD(W(:,2)==r(1),i) OD(W(:,2)==r(2),i)];
        CL_GR(:,(2*i-1):2*i,r(1)==2:5) = [GR(W(:,2)==r(1),i+3) GR(W(:,2)==r(2),i+3)];
        CL_OD(:,(2*i-1):2*i,r(1)==2:5) = [OD(W(:,2)==r(1),i+3) OD(W(:,2)==r(2),i+3)];
        PD_GR(:,(2*i-1):2*i,r(1)==2:5) = [GR(W(:,2)==r(1),i+6) GR(W(:,2)==r(2),i+6)];
        PD_OD(:,(2*i-1):2*i,r(1)==2:5) = [OD(W(:,2)==r(1),i+6) OD(W(:,2)==r(2),i+6)];
        CD_GR(:,(2*i-1):2*i,r(1)==2:5) = [GR(W(:,2)==r(1),i+9) GR(W(:,2)==r(2),i+9)];
        CD_OD(:,(2*i-1):2*i,r(1)==2:5) = [OD(W(:,2)==r(1),i+9) OD(W(:,2)==r(2),i+9)];
    end
end


%% Plot yo Shit
names = {'PN','CN','PL','CL','PD','CD'};
for name = names
    figure()
    subplot(1,2,1)
    eval(char(strcat('imagesc(nanmean(',name,'_GR,3))')))
    title(strcat(name,' GR'))
    subplot(1,2,2)
    eval(char(strcat('imagesc(nanmean(',name,'_OD,3))')))
    title(strcat(name,' OD'))
end