function [methodTag tempFreqs dataset PODparams subtag] = cm_dataTagSwitcher(subinds, numMech, fovflag, corflag, coneflag)
% [methodTag tempFreqs dataset PODparams] = cm_dataTagSwitcher(subinds, numMech, fovflag, corflag, coneflag)
%
% This function replys parameters for model-fitting to threshld data.
%
% 
% <Input>
%   subinds   ... subject index
%   numMech   ... number of mechanisms
%   fovflag   ... foveal data or not (periphery) logical
%   corflag   ... correction flag with pigment density
%   coneflag  ... cone flag which decides number of column
%
% <Output>
%   methodTag ... decide a model for fitting procedure 
%   tempFreqs ... temporal frequency of data set
%   dataset   ... character which indicates a type of dataset  
%   PODparams ... photopigment optical densities, macular and lens pigmemt densities 
%   subtag    ... subject name tag
% 
%
% Example
%   subinds = 1; numMech = 3;
%   fovflag = true; corflag = true; coneflag = true;
%   [methodTag tempFreqs dataset PODparams] = cm_dataTagSwitcher(subinds, numMech, fovflag, corflag, coneflag)
%
% see also cmMechamismfitResultsOutput.m cm_prepDataforMechanismfit.m and
%          s_cmMechamismfit.m (script) 
%
% % HH (c) Vista lab Oct 2012. 
%
%%

if ~exist('numMech','var') || isempty(numMech)
    numMech = []; 
end

if ~exist('coneflag','var') || isempty(coneflag)
    coneflag = []; 
end

%% define corrected pigment density
% those paticular pigment densities were estimated based on foveal data
%
if corflag
    switch subinds
        
        % S1's parameters are also used for S3 because S3 foveal data
        % doesn't exist and the thresholds data of S1 and S3 were similar
        % in periphery. 
        
        case {1,3} 
            POD = [0.4964 0.2250 0.1480 0.3239 0.7467 0.6910];
        
        case 2
            POD = [0.4841 0.2796 0.2072 0.3549 0.7637 0.5216];
    
    end
    
    PODparams.cor = true;

else
    % standard obserber's parameter
    POD = [0.5 0.5 0.4 0.5 1 0.28];
    PODparams.cor = false;

end

if coneflag
   columnNum = 3;
   dataset = 'purei';
else
   columnNum = 4;
   dataset = 'all';
end

if fovflag    
    PODparams.pods  = POD(1:4);
    PODparams.lens  = POD(5);
    PODparams.mac   = POD(6);   
    tempFreqs       = [1 30];
    nametag         = 'f';
    
else    
    PODparams.pods  = POD(1:4) ./ [0.5 0.5 0.4 0.5] .* [0.38 0.38 0.3 0.5];
    PODparams.lens  = POD(5);
    PODparams.mac   = 0;   
    tempFreqs       = [1 20 40];    
    nametag         = 'p';
end

methodTag = sprintf('%dx%dx%d',numMech,columnNum,length(tempFreqs));
subtag    = sprintf('s%d%s'   ,subinds, nametag);

% peak shift of lambda max in photopigment function (1x4 vector or scalar) 
PODparams.shift = 0;

end
