function [POD MacDen LMSresp lensfactor] = cm_findPigmentDensity(nullspd,  SPDs, Absorbance, method, dataset, unitDensity, lT, limitPigs)
% [POD MacDen LMSresp] = cm_findMinMacPOdensity(SPDdir, Absorbance, SPDs, method, limitPigs)
%
% This function calculate photopigment optical density and macular pigment
% density to minimize LMS responses.
%
% <Input>
%   SPDdir    ... spectral power distribution of null direction (or least
%   visible stimulus)
%   Absorbance ... photopigment absorbance.
%   SPDs       ... mean spectral power distibution
%   method     ... give limitations or not
%   dataset    ... foveal or peripheral data
%
% <Output>
%   POD        ... photopigment optical density to minimize LMS responses
%   MacDen     ... macular pigment density to minimize LMS responses
%   LMSreps    ... LMS responses in a case of POD and MacDen
%
% see also cm_pigmentCorrection.m
%
% C) HH Vista Lab, 2012
%%
% method2 : give any limitation for answer or not
if ~exist('method2','var') || isempty(method2), method2 = 'fmincon'; end

% fovea or peri
if ~exist('dataset','var') || isempty(dataset), dataset = 'fovea'; end

%% prep
lambdashift = 0;                % assume no peack shift

% conver mean spectrum power distibution matrix to a vector
backgroundSPDs = SPDs * ones(size(SPDs,2),1);

% set seeds
if strcmp(dataset,'fovea')
    seeds = [0.4 0.4 0.3 0.3 0.28 1];
elseif strcmp(dataset,'peri')    
    seeds = [0.3 0.3 0.2 0.3 0.05 1];
end

%%
switch method
    
    % no limitation, you may get negative numbers
    case 'fminsearch'
        % go
        [POD_MacDen] = fminsearch(@cm_findPigmentDensity_sub, seeds, 0, unitDensity, nullspd, Absorbance, lT, lambdashift, backgroundSPDs);
        
        % with limitations you've set up
    case 'fmincon'
        
        if ~exist('limitPigs','var') || isempty(limitPigs)
            
            if strcmp(dataset,'fovea')
                limitPigs = [0.01 0.5 0 1.2 0.5];
            elseif strcmp(dataset,'peri')
                limitPigs = [0.01 0.5 0 0.1 0.5];
            end
            
        end
        
        % POD and macular density limitation
        podlb = limitPigs(1);
        podub = limitPigs(2);
        maclb = limitPigs(3);
        macub = limitPigs(4);
        
        % set boundary and options
        numPOD = size(seeds,2)-1;
        lb = [podlb*ones(1,numPOD-1) maclb 1-limitPigs(5)];
        ub = [podub*ones(1,numPOD-1) macub 1+limitPigs(5)];
        
        options = optimset('Display','none','MaxFunEvals',10^5,'MaxIter',10^5,'TolFun',1e-15,'TolX',1e-15,'Algorithm','interior-point');
        % go
        [POD_MacDen] = fmincon(@cm_findPigmentDensity_sub, seeds, [], [], [], [], lb, ub, [], options,...
            unitDensity, nullspd, Absorbance, lT, lambdashift, backgroundSPDs);
end

% put it back and get LMS responses
[~, LMSresp] = cm_findPigmentDensity_sub(POD_MacDen, unitDensity, nullspd, Absorbance, lT, lambdashift, backgroundSPDs);

% organize output
[POD MacDen lensfactor] = outputSeparator(POD_MacDen);

end

%%
function [absLMSresp LMSresp] = cm_findPigmentDensity_sub(POD_MacDen, unitDensity, nullspd, Absorbance, lT, lambdashift, SPDs)

[POD MacDen lensfactor] = outputSeparator(POD_MacDen);

% %%%%% from macular.m in ISET-4.0 %%%%%%
% Here is the density, given the macular density passed in.
density = unitDensity * MacDen;
% Here is the fraction transmitted through the macular pigment
mT = 10.^(-density);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% variable lens transmittance function
if ~isempty(lensfactor)
    tmp = lT; clear lT
    lT = cm_LensTransmittanceF(lensfactor,tmp.dl1, tmp.dl2, tmp.met);
end

% whole eye transmittance (based on lens and macular transmittance)
wT = lT .* mT';

% estimate LMSI fucntions
LMSIfun = cm_variableLMSI_PODandLambda(Absorbance, POD, lambdashift, wT);

% percent response of LMSI from mean background
LMSresp = (LMSIfun' * nullspd) ./  (LMSIfun' * SPDs) * 100;

% distance from mean
absLMSresp = sqrt(sum(LMSresp(1:3) .^ 2));
% figure(999); plot(LMSIfun); hold on; plot(lT,'k'); drawnow ; hold off
end

%%
function [POD MacDen lensfactor] = outputSeparator(POD_MacDen)

POD        = POD_MacDen(1:end-2);
MacDen     = POD_MacDen(end-1);
lensfactor = POD_MacDen(end);

end