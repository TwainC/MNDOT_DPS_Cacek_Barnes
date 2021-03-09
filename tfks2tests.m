%% Examine t, f, and ks tests

section = 3;

for i = 1:length(swerveFilePaths)
    dat = zoneDielectric(swerveFilePaths(i),1,2,4);
    s171 = dat(:,dat(4,:)==171);
    s173 = dat(:,dat(4,:)==173);
    s181 = dat(:,dat(4,:)==181);
    
    len(i) = length(s171);
    NA(i) = length(s171(3,s171(5,:)==section));
    NB(i) = length(s173(3,s173(5,:)==section));
    NC(i) = length(s173(3,s173(5,:)==section));
    
    diffMeanAB(i) = mean(s171(3,s171(5,:)==section))-mean(s173(3,s173(5,:)==section));
    diffMeanBC(i) = mean(s173(3,s173(5,:)==section))-mean(s181(3,s181(5,:)==section));
    diffMeanAC(i) = mean(s171(3,s171(5,:)==section))-mean(s181(3,s181(5,:)==section));
    
    diffVarAB(i) = diffMeanAB(i)/sqrt(var(s171(3,s171(5,:)==section))+var(s173(3,s173(5,:)==section)));
    diffVarBC(i) = diffMeanBC(i)/sqrt(var(s173(3,s173(5,:)==section))+var(s181(3,s181(5,:)==section)));
    diffVarAC(i) = diffMeanAC(i)/sqrt(var(s171(3,s171(5,:)==section))+var(s181(3,s181(5,:)==section)));
    
    [AB(1,i),ABp(1,i)] = ttest2(s171(3,s171(5,:)==section),s173(3,s173(5,:)==section));
    [AB(2,i),ABp(2,i)] = vartest2(s171(3,s171(5,:)==section),s173(3,s173(5,:)==section));
    [AB(3,i),ABp(3,i)] = kstest2(s171(3,s171(5,:)==section),s173(3,s173(5,:)==section));
    
    [BC(1,i),BCp(1,i)] = ttest2(s173(3,s173(5,:)==section),s181(3,s181(5,:)==section));
    [BC(2,i),BCp(2,i)] = vartest2(s173(3,s173(5,:)==section),s181(3,s181(5,:)==section));
    [BC(3,i),BCp(3,i)] = kstest2(s173(3,s173(5,:)==section),s181(3,s181(5,:)==section));
    
    [AC(1,i),ACp(1,i)] = ttest2(s171(3,s171(5,:)==section),s181(3,s181(5,:)==section));
    [AC(2,i),ACp(2,i)] = vartest2(s171(3,s171(5,:)==section),s181(3,s181(5,:)==section));
    [AC(3,i),ACp(3,i)] = kstest2(s171(3,s171(5,:)==section),s181(3,s181(5,:)==section));

end

%1 = rejects null hypothesis (not same mean/var/dist)
%0 = fails to reject null hypothesis (same mean/var/dist)
byComp = table(AB(1,:)',AB(2,:)',AB(3,:)',BC(1,:)',BC(2,:)',BC(3,:)',AC(1,:)',AC(2,:)',AC(3,:)');
byComp.Properties.VariableNames = {'AB t-test','AB f-test','AB ks-test','BC t-test','BC f-test','BC ks-test','AC t-test','AC f-test','AC ks-test'};

byTest = table(AB(1,:)',BC(1,:)',AC(1,:)',AB(2,:)',BC(2,:)',AC(2,:)',AB(3,:)',BC(3,:)',AC(3,:)');
byTest.Properties.VariableNames = {'AB t-test','BC t-test','AC t-test','AB f-test','BC f-test','AC f-test','AB ks-test','BC ks-test','AC ks-test'};

pByComp = table(round(ABp(1,:),3)',round(ABp(2,:),3)',round(ABp(3,:),3)',round(BCp(1,:),3)',round(BCp(2,:),3)',round(BCp(3,:),3)',round(ACp(1,:),3)',round(ACp(2,:),3)',round(ACp(3,:),3)');
pByComp.Properties.VariableNames = {'AB t-test','AB f-test','AB ks-test','BC t-test','BC f-test','BC ks-test','AC t-test','AC f-test','AC ks-test'};

pByTest = table(round(ABp(1,:),3)',round(BCp(1,:),3)',round(ACp(1,:),3)',round(ABp(2,:),3)',round(BCp(2,:),3)',round(ACp(2,:),3)',round(ABp(3,:),3)',round(BCp(3,:),3)',round(ACp(3,:),3)');
pByTest.Properties.VariableNames = {'AB t-test','BC t-test','AC t-test','AB f-test','BC f-test','AC f-test','AB ks-test','BC ks-test','AC ks-test'};

N = table(NA',NB',NC');
N.Properties.VariableNames = {'Sensor A','Sensor B', 'Sensor C'};

diffMean = table(diffMeanAB',diffMeanBC',diffMeanAC');
diffMean.Properties.VariableNames = {'AB','BC','AC'};

diffVar = table(diffVarAB',diffVarBC',diffVarAC');
diffVar.Properties.VariableNames = {'AB','BC','AC'};

tAB = sum(AB(1,:));
fAB = sum(AB(2,:));
ksAB = sum(AB(3,:));

tBC = sum(BC(1,:));
fBC = sum(BC(2,:));
ksBC = sum(BC(3,:));

tAC = sum(AC(1,:));
fAC = sum(AC(2,:));
ksAC = sum(AC(3,:));

iAB = sum(AB,1);
iBC = sum(BC,1);
iAC = sum(AC,1);

t = tAB + tBC + tAC;
f = fAB + fBC + fAC;
ks = ksAB + ksBC + ksAC;

ecdf(s171(3,s171(5,:)==3));
hold on;
ecdf(s173(3,s173(5,:)==3));
ecdf(s181(3,s181(5,:)==3));
legend('171','173','181');