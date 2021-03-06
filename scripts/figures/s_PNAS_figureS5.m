% s_PNAS_figureS5s.m
%
% 'Human Color Sensitivity: Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure Caption:
% Trichromacy and Tetrachromacy fits to peripheral measurements in S3. The
% gray-shaded curves are Trichromacy fits and the solid black lines are
% Tetrachromacy fits to pulse data from S3. Very few of the measured 150
% data points lie in these six planes, and hence the data points appear to
% be sparse. The model fits to S3's data are similar to the fits for S2's
% data (Figure 4B).
% 
% HH (c) Vista lab Oct 2012. 
%
%% Figure S5
%
%  This takes a few minutes to compute.
%
%  Returns the visibility matrix for the mechanisms estimated in Figure S5
%  using the threshold data set.

subinds  = 3;   % Which subject
fovflag  = 0;   % In the fovea or not
corflag  = 1;   % Correct the model for pigment density
coneflag = 0;   % Allow a 4th, non-cone, photopigment contribution.
nSeeds   = 1000;  % Number of seeds for 1st fitting

% sub 3 PERI mech3x4 w corr % figure 4A reproducible
numMech  = 3;   % How many mechanisms (3 or 4)
[Vis5_3s params5_3s] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

% sub 3 PERI mech4x4 w corr % figure 4A reproducible 
numMech  = 4; % How many mechanisms (3 or 4)
[Vis5_4s params5_4s] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

%% draw ellipses
% Figure S5
f = figure('Position',[0 0 1000 630]);
elxy = cm_mechanismfit_draw2D(Vis5_3s,params5_3s,[0 0 0],1); close(f)
f = figure('Position',[0 0 1000 630]);
params5_4s.subtag = 's1p4a';
cm_mechanismfit_draw2D(Vis5_4s,params5_4s,[0 0 0],1,elxy);

params5_4s.subtag = 's3p';
%% fits Trichromacy model to non-corrected axis data for another analysis 

corflag  = 0;   % Correct the model for pigment density
numMech  = 3;   % How many mechanisms (3 or 4)

[Vis5_3sn params5_3sn] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);
% f = figure('Position',[0 0 1000 630]);
% params5_3sn.subtag = 's1p4a';
% cm_mechanismfit_draw2D(Vis5_3sn, params5_3sn,[0 0 0],1);

%%
clear data
data.params3  = params5_3s;  data.vismtx3  = Vis5_3s;
data.params4  = params5_4s;  data.vismtx4  = Vis5_4s;
data.params3n = params5_3sn; data.vismtx3n = Vis5_3sn;
set(gcf,'UserData',data);

%% save
% cm_figureSavePNAS(f,'S5')