% s_PNAS_figureS2
%
% 'Human Color Sensitivity: Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
% 
% Figure Caption;
% Estimated pigment densities for foveal data that align the invisible
% stimulus with the cone-silent direction. Pigment densities for the
% Stockman’s standard observer were estimated by bootstrapping methods. In
% S1 (thick outline) and S2 (filled with color), the pigment density
% distributions are within a plausible biological range. (A) L-, M- and
% S-cone photopigment optical densities. (B) Macular and lens pigment
% density estimates.      
% In the fovea, photopigment optical densities of L-, M-, S-cone in the
% standard observer are 0.5, 0.5 and 0.4, respectively, with significant
% differences across individual subjects. In our conditions, the mean
% background is bluish and very intense. The estimates for our experimental
% conditions suggest that the S-cone photopigment is reduced, consistent
% with the measurement conditions.     
% We estimated the macular pigment density based on the function reported
% by Sharpe and Stockman (2). The macular pigment densities in S1 are
% higher than standard observers’ (0.28). However, the macular pigment
% density is known to vary greatly across individuals. Moreover, the
% estimates for the standard observer are derived from experiments at 2 deg
% eccentricity, whereas our foveal experiments were centered at 0 deg
% eccentricity (extending to 1 deg). Since macular pigment density falls
% off sharply with eccentricity, it is not surprising that the estimates
% for our observers are higher than that for the standard observer (1)
% Additional results from a separate color matching experiment (Figure S3)
% confirmed that the macular pigment density for this subject was higher
% than 0.28.            
% We modeled Stockman’s lens pigment density(1) into two functions as
% suggested by Xu, Pokorny and Smith(3). The first function is fixed and
% the scale factor on the second function varies with a typical value of 1.
% Estimates from S1 are slightly lower than typical and estimates from S2
% match the typical.      
%
% HH (c) Vista lab Oct 2012. 
%
%%
figname          = '3'; % Analysis for figure S2 uses figure 3 data 
btsparams        = cm_ConditionPrepforBootstrapipngSGE(figname);
InvDirTrimodlfov = cm_InvDirTriBstRes(btsparams);

%% do pigment correction
limitPigs = [0.01 0.5 0 1.2 0.5];
limitflag = true;
saveflag  = 1;             
foveaflag = btsparams.Fov; % it's fovea, should be true

% This fitting procedure takes really long time.
% The data will be save in a folder defined by a m-function,
% cm_defaultPathforSaveSGEresults.m
[pod,mds,lfs,lmsR] = ...
    cm_pigmentCorrection(InvDirTrimodlfov, foveaflag, limitflag, limitPigs, saveflag);

%% draw
f2S = cm_histPigments(pod,mds,lfs, limitPigs);

