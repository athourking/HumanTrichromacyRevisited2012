function LMSrespToSPDs = cm_EstLMSresponse(StimDirs, sub, fv, backgroundSPD, wls)
% LMSrespToSPDs = cm_EstLMSresponse(StimDirs, sub, fv, backgroundSPD, wls)
%
% This function estimates LMS responses to the stimulus direction in the
% particular data set, which is psychophysics meaurement in PNAS paper
% (hopefully will be accepted). In Figure 3BC and 5BC, this code will be
% used.
%
% <Input>
%   StimDir         ... Stimulus direction in 4D standard observer space
%   sub             ... which subject
%   fv              ... fovea or not
%   backgroundSPD   ... spectral power distibution of background
%   wls             ... wavelength 
%
% <Output>
%   LMSrespToSPDs   ... LMS responses to the stimulus 
%
% see also s_PNAS_figure3ABC.m and s_PNAS_figure5ABC.m
%
% HH (c) Vista lab Oct 2012. 
%
%% prep

% if some variables don't exist, default variables will be put
if ~exist('wls','var') || isempty(wls)
    wls    = cm_getDefaultWls;
end

if ~exist('backgroundSPD','var') || isempty(backgroundSPD)
    ledspd = cm_getledSPD(wls);
    backgroundSPD  = ledspd * ones(6,1);
end

% load spectral power distribution of pigment-isolated stimuli
tmp = load('psychdataforPNAS');
if fv
    isolateSPD = tmp.FOVstimSPD ;
else
    isolateSPD = tmp.PERIstimSPD;
end
clear tmp;

%% estimate LMS response to the stimulus

% Stimulus amplitude in the paper is 10 percent modulation
StimAmp = 10;

% Stimulus spectral power distribution
StimSPD =  isolateSPD * StimDirs * StimAmp;

% Here, the function estimates LMS responses to invisible stimuli by
% Trichomacy model 
% 1) standard observers cone function 
% 2) cone function with reduced photopigment (biologically plausible)
%
%% fovea 
%  only 1) will be calculated 

if fv
    
    % foveal LMS standard observer
    [~, LMSstandard]    = ct_loadStandardObserverData;
    
    % Standard obserever LMS respones to the stimulus
    LMSrespToSPDs = cm_LMSresponse(LMSstandard, StimSPD, backgroundSPD);
    
    
%% periphery    
%  both of 1) and 2) will be calculated 

elseif ~fv
    
    % peripheral LMS standard observer
    LMSstandard    = ct_loadStandardObserverData;
    
    % Standard obserever LMS respones to the stimulus
    LMSrespToSPDs = cm_LMSresponse(LMSstandard, StimSPD, backgroundSPD);
    
    % calc individual LMS function
    absorbanceSpectra = cm_loadLMSabsorbance(fv);
        
    % pick up estimated photopigment densities based on foveal experiment
    correctionflag = 1;
    [~, ~, ~, tmp] = cm_dataTagSwitcher(sub, [], fv, correctionflag);    
    PODs       = tmp.pods;
    macfactor  = tmp.mac;
    lensfactor = tmp.lens;
       
    % lens transmittance function
    lT = cm_LensTransmittance(lensfactor, wls,'stockman2');
    
    % macular transmittance function
    mT = macular(macfactor, wls);
    
    % whole eye transmittance function
    eT = lT .* mT.transmittance';
    
    % assume no peak shift
    Lambdashift = 0;
    
    % individual LMS function 
    iLMS = cm_variableLMSI_PODandLambda(absorbanceSpectra, PODs(1:3), Lambdashift, eT);
    
    % individual LMS respones to the stimulus
    LMSrespToSPDs(:,:,2) = cm_LMSresponse(iLMS, StimSPD, backgroundSPD);
        
end

end

