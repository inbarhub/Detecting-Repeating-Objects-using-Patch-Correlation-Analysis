function [w,tmp] = loopUI(params,valPositive,valNegative)
    X = [params.data(:,valPositive)';params.data(:,valNegative)'];
    Y = [ones(size(params.data(:,valPositive)',1),1); -1.*ones(size(params.data(:,valNegative)',1),1)];
    box = 100;
    SVMModel = fitcsvm(X,Y,'boxConstraint',box);
    [label,score] = predict(SVMModel,params.data');
    a = SVMModel.Alpha.*Y(SVMModel.IsSupportVector);
    w = (a'*X(SVMModel.IsSupportVector,:));
    tmp = w*params.data+SVMModel.Bias;
    tmp = tmp+1;
    valPositive_1 = find(tmp>=1);
    valNegative_1 = find(tmp<=1);
end