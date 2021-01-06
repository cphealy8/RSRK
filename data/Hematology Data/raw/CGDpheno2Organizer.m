[num,txt,raw] = xlsread('CGDpheno2.xlsx');
colnames = raw(6,:);
id = num(:,1);
param = raw(7:end,6);
age = num(:,2);
val = num(:,5);

paramOps = unique(param);
ID = unique(id);

DAT = table(ID);

