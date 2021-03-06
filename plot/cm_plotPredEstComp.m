function [hs, he] = cm_plotPredEstComp(x, y, er, C, fovflag)
%  [hs, he] = cm_plotPredEstComp(x, y, er, C, fovflag)
%
% This function draws a scatter plot in Figure 6AB.
% 
% <Input>
%   x       ... measured thresholds
%   y       ... median of estimated thresholds
%   er      ... confidence interval of estimated thresholds
%   C       ... Color
%   fovflag ... Fovea or not
%
% <Output>
%   hs ... handles for scatter plots
%   he ... handles for errorbar (which indicates confidence interval)
%   
% see also s_PNAS_figure6A.m and s_PNAS_figure6B.m
%
%  HH (c) Vista lab Oct 2012. 
% 
%% prep
if ~exist('fovflag','var') || isempty(fovflag)
    fovflag = false;
end

if ~exist('C','var') || isempty(C)
    C = [0 0 1];
end

if iscell(x)
    nData = length(x);
else
    nData = 1;
end

lw = 2;
Symb = {'o','^','s'};
linS = {'--','-','-.'};

Ms = 6;

%% plot the points

for ii = 1:nData
    
    if nData > 1
        xp = x{ii}; yp = y{ii};
    else
        xp = x; yp = y;
    end
    
    if size(C,1) > 1
        Cp = C(ii,:);
    else
        Cp = C;
    end
    
    hs{ii} = plot(xp, yp,'Marker',Symb{ii},'MarkerSize',Ms,'Color',Cp,'MarkerFace',Cp);
    set(hs{ii},'LineStyle','none')
    hold on
end

if exist('sx','var') && exist('sy','var') && exist('sxend','var')
    plot([sx sxend],[sy sy],'Color',[0 0 0],'LineWidth',4,'LineStyle','-');
end

%% draw errorbar with errorbar2.m written by KNK

for ii = 1:nData
    
    if nData > 1
        xp = x{ii}; yp = y{ii}; erp = er{ii};
    else
        xp = x; yp = y; erp = er;
    end
    
    if size(C,1) > 1
        Cp = C(ii,:);
    else
        Cp = C;
    end
    
    he{ii} = errorbar2(xp,yp,erp(1,:),'v','Color',Cp,'LineWidth',lw,'LineStyle',linS{ii});
end

%% Let's make figure fancier

FS = 16;
xlabel('Measured threshold','FontSize',FS),ylabel('Predicted threshold','FontSize',FS);
axis square; grid on; set(gca,'FontSize',FS)

if fovflag
    Mnum = 0.5; minnum = 0.002;
    Ticks = [minnum:0.001:0.01 0.02:0.01:0.1 0.2:0.1:Mnum];
    Ticklabels = {'0.2','','','0.5','','','','','1','2','','','5','','','','','10','20','','','50','','','','','100'};
else
    
    Mnum = 0.5; minnum = 0.01;
    Ticks = [0.01 0.02:0.01:0.1 0.2:0.1:Mnum];
    Ticklabels = {'1','2','','','5','','','','','10','20','','','50','','','','','100'};
end

hold on
plot([minnum Mnum],[minnum Mnum],'k'); axis([minnum Mnum minnum Mnum]);
set(gca,'Xscale','log','Yscale','log')
set(gca,'Xtick',Ticks,'Xticklabel',Ticklabels,'XMinorGrid','off')
set(gca,'Ytick',Ticks,'Yticklabel',Ticklabels,'YMinorGrid','off')

