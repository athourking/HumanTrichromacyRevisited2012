function RMSEs = cm_calcMeasurementError(modelSquareErrors, confIntv)
% [Ptiles Er]= cm_calcMeasurementError(modelSquareErrors)
%
% This function draws root mean of square error between estimated threshold
% by model and measured threshold to evaluate which model seems more
% likely. They are Right panel of Figure 6A and B.
%
% <Input>
%  modelSquareErrors ... square errors between model and measurement 
%  confIntv          ... confidence interval
%
% <Output>
%  RMSEs             ... roor of mean square error 
%
% see also cm_loadBst_ErrorCal.m and s_PNAS_figure6A.m
%
% HH (c) Vista lab Oct 2012. 
% 
%% prep
if ~exist('confIntv','var') || isempty(confIntv)
    confIntv = 80;
end

CI = (100 - confIntv) ./ 2;

nDsets = size(modelSquareErrors,2);
ptile  = [50 CI 100-CI];

%% calc root of mean square error between model and measurement

for inds = 1:nDsets
    
    clear nTrials RMSE tmp R
    
    nDir = size(modelSquareErrors{inds},2);
    
    for dirinds = 1:nDir
        nTrials(dirinds) = size(modelSquareErrors{inds}{dirinds},1);
    end
    
    % get 
    nMinTr = min(nTrials);
    
    for dirinds = 1:nDir
        R(:,dirinds) = randsample(nMinTr,nMinTr, false);
    end
    
    for dirinds = 1:nMinTr
        
        RaN = R(dirinds,:);
        
        for ij = 1:nDir
            tmp(ij) = modelSquareErrors{inds}{ij}(RaN(ij));
        end
        
        % root mean square error
        RMSE(dirinds) = sqrt(mean(tmp));
             
        clear tmp
    end
    
    % get median and confidnece interval RMSE in bootstrapping
    RMSEs(inds,:) = prctile(RMSE,ptile);
end


