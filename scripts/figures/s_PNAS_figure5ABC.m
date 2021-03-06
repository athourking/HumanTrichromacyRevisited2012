% s_PNAS_figure5ABC and S6
%
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure caption:
% Figure 5. Peripheral measurements deviate from the classic trichromatic
% theory. (A) Spectral power distributions of invisible stimuli in the
% periphery estimated by the 3-mechanism quadratic model. Thickness of the
% line indicates the 80% confidence interval as in Figure 3A. (B) Estimated
% S1 cone responses to the peripheral invisible stimuli at 10% modulation
% in 3D LMS space. Assuming the standard color observer, the estimated
% invisible stimuli evoked large LMS responses. Similarly, assuming
% individual lens and optical density pigment densities based on the foveal
% experiments (“reduced pigment”) and no macular pigment. The estimated
% invisible stimuli also evoked robust LMS responses.  Even if pigment
% densities are adjusted freely to include biologically implausible density
% levels, the invisible stimuli were absorbed by LMS cones at a high enough
% level to evoke light detection (not shown). Histograms on each cone axis
% show a distribution of cone responses to the invisible stimuli according
% to each of the three pigment models. LMS cone responses in S2 and S3 are
% shown in Figure S6. (C) Distributions of estimated LMS responses to the
% peripheral invisible stimuli in three subjects. Histograms show distances
% from the origin to estimated responses to the stimulus in 3D LMS space.
% In all three subjects, pigment reduction does not reduce the estimated
% LMS response to zero.                          
%
% Figure S6
% Estimated cone absorptions for the Trichromacy fit in the periphery for
% S2 and S3. Estimated cone absorptions to the stimuli predicted to be
% invisible in the periphery according to the best fitting three-pigment
% model (10 % modulation) for S2 (panel A) and S3 (panel B). Using
% Stockman’s pigment density (gray circles), the estimated invisible
% stimuli evoked significant levels of cone absorptions. These absorptions
% don’t cluster like S1 (Figure 5B, main text). Correcting pigment
% densities based on the foveal experiments (black outline circles) did not
% reduce the estimated cone absorptions. Even if pigment densities are
% allowed to be biologically implausible, cone absorptions are still
% predicted to be high enough to evoke a detectable response (not shown).
%       
% HH (c) Vista lab Oct 2012. 
%
%% load bootstrapped results for figure 5ABC and 6 
figname    = '5abc'; % figure name for analysis
btsparams  = cm_ConditionPrepforBootstrapipngSGE(figname);
tempInd    = 1; % analyze pulse data

% Estimated invisible stimulus by Trichoromacy Model
% and LMS responses to the stimulus at 10 % modulation
[InvDirTrimodlPeri LMSrespStimPeri]= cm_InvDirTriBstRes(btsparams,tempInd);
%% Figure 5A
subInds  = 1; % show S1
ConfInt  = 80;    % Confidenc interval - 80% 
fovflag  = btsparams.Fov; % foveal flag, which should be false

% plot invisible stimmulus spectral power distribution
f5A = cm_plotEstInvisibleSPD(InvDirTrimodlPeri, subInds, ConfInt, fovflag);

%% save
cm_figureSavePNAS(f5A,'5A')

%% Figure 5B
f5B = figure('Position',[0 0 800 800]);
EdgeColor  = [.8 .8 .8; .15 .15 .15];
MarkerFace = [.8 .8 .8;   1   1   1];

% plots before correction
subind = 1;
drawAxis = false;
cm_plotLMSabsorption(LMSrespStimPeri{subind}(:,:,1),EdgeColor(1,:), MarkerFace(1,:), drawAxis);

% plots after correction
drawAxis   = true;
h = cm_plotLMSabsorption(LMSrespStimPeri{subind}(:,:,2),EdgeColor(2,:), MarkerFace(2,:), drawAxis);

%% save
cm_figureSavePNAS(f5B,'5B')

%% histgrams

% sort for histgrams
for subinds = btsparams.Sub    
    LMSbefore{subinds} = LMSrespStimPeri{subinds}(:,:,1);
    LMSAfter{subinds}  = LMSrespStimPeri{subinds}(:,:,2);
end

subind = 1;
f5bInlet = figure('Position',[0 0 1300 200]);
cm_histXYZ(LMSbefore, LMSAfter, subind);
%% save
cm_figureSavePNAS(f5bInlet,'5Binlet')

%% Figure 5C
% draw

f5C = figure('Position',[0 0 1400 300]);

% before correction
FaceB = ones(1,3) * 0.8; EdgeB = 'none';
cm_histLMSrespFromOrigin(LMSbefore, FaceB, EdgeB);
% after correction
FaceA = 'none';  EdgeA = ones(1,3) * 0.2;
cm_histLMSrespFromOrigin(LMSAfter, FaceA, EdgeA);

%% save
cm_figureSavePNAS(f5C,'5C')

%% S6AB
% draw
fS6 = figure('Position',[0 0 1400 700]);

subplot(1,2,1)

% S2
subind = 2;
drawAxis = false;
cm_plotLMSabsorption(LMSrespStimPeri{subind}(:,:,1),EdgeColor(1,:), MarkerFace(1,:), drawAxis);
drawAxis   = true;
cm_plotLMSabsorption(LMSrespStimPeri{subind}(:,:,2),EdgeColor(2,:), 'none', drawAxis);

subplot(1,2,2)

% S3
subind = 3;
drawAxis = false;
cm_plotLMSabsorption(LMSrespStimPeri{subind}(:,:,1),EdgeColor(1,:), MarkerFace(1,:), drawAxis);
drawAxis   = true;
cm_plotLMSabsorption(LMSrespStimPeri{subind}(:,:,2),EdgeColor(2,:), 'none', drawAxis);
%% save
cm_figureSavePNAS(fS6,'S6')

%%%%%%%%%%%%%
%% Trial %%%%
% to mininize LMS responses to estimated invisible stimuli in periphery
%%%%%%%%%%%%%
%
% Note you can reduce LMS responses to estimated invisible stimulus by
% Trichormacy model, but parameters are biologically inplausible and hit
% boundary; for example, in S1 L-cone POD = 0.5, M-cone POD = 0.5,
% S-cone POD = 0.01, Macular = 0 (which is good), Lens = 0.5. Even in this
% conditino, LMS responses are still enough large to detect.
% 
% If the model fits without any limitation, which means allow biologically
% inplausbile parameters, LMS responses to stimuli reduce to zero.
% However, some of parameters will be negative.
%
%%
% same as a script for FigureS2 
limitPigs = [0.01 0.5 0 0.1 0.5];
limitflag = true; % you can also try to put false 
saveflag  = 1;             % output will be saved
foveaflag = btsparams.Fov; % false, I think

% it takes really long time.
[pod,mds,lfs,lmsR] = cm_pigmentCorrection(InvDirTrimodlPeri, foveaflag, limitflag, limitPigs, saveflag);


% LMS responses to 1 percent stimulus, so need to multiply by stimulus amp

stimAmp = 10; % stimulus amplitude is 10 percent modulation 
for ii=1:length(lmsR); LMSrespAfter{ii} = lmsR{ii} * stimAmp; end

%% plot the results
subind = 1;

figure
drawAxis   = false;
cm_plotLMSabsorption(LMSrespStimPeri{subind}(:,:,1),EdgeColor(1,:), MarkerFace(1,:), drawAxis);
drawAxis   = true;
cm_plotLMSabsorption(LMSrespAfter{subind},EdgeColor(2,:), MarkerFace(2,:), drawAxis);
