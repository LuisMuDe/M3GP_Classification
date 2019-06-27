function antsim(vars,simspeed)
%ANTSIM    Simulates the behaviour of the best GPLAB artificial ant.
%   ANTSIM(VARS) evaluates the best ant stored in the given variable.
%   Also simulates the ant's behaviour.
%
%   ANTSIM(VARS,SIMSPEED) runs the ant simulation at a given speed
%   (SIMSPEED indicates the pause between simulation steps, so the higher
%   the number, the slower the simulation runs). If SIMSPEED is negative,
%   the simulation waits for the user to press a button before displaying
%   the next step. SIMSPEED is optional.
%
%   Legend:
%      blue dots: food pellets
%      white dots: eaten food pellets
%      red triangle: ant
%      pinkish squares: visited positions
%      cyanish squares: looked positions
%
%   Input arguments:
%      VARS - the variable with all the information of the run (struct)
%      SIMSPEED - pause between time steps, wait for user if <0 (double, optional)
%
%   Created (2006) by Matthew Clifton and Sara Silva
%   (matthew_clifton@hotmail.com, sara@dei.uc.pt)
%   Copyright (C) 2003-2007 Sara Silva (sara@dei.uc.pt)
%   This file is part of the GPLAB Toolbox

global sim
global path


% Show info on best ant
% =========================================================================

% Best individual:
best=vars.state.bestsofar;
% Max pellets:
maxpellets=vars.data.result;

% Results summary:
fprintf('\nBest individual:\n\n');
fprintf('\tPopulation size:             %d\n',vars.state.popsize);
fprintf('\tMaximum generations:         %d\n',vars.state.maxgen);
fprintf('\tBest occurred in generation: %d\n',cell2mat(vars.state.bestsofarhistory(size(vars.state.bestsofarhistory,1))));
fprintf('\tBest individual found:       %s\n',best.str)
fprintf('\tFitness:                     %d/%d\n',best.fitness,maxpellets);
fprintf('\tDepth:                       %d\n',best.level);
fprintf('\tNodes:                       %d\n',best.nodes);


% Simulate ant's behaviour
% =========================================================================

s=input('\nWould you like to simulate the ant''s behaviour? (y/n): ','s');

if s=='y'

    if ~exist('simspeed')
        simspeed=0.1;
    end
        
    fprintf('\nRunning Artificial Ant Simulation...');

    % Evaluate while storing the ant path
    sim=1;
    path=[];
    antfitness(best,vars.params,vars.data,vars.state.terminals,vars.state.varsvals);

    % Get run info
    trail=vars.data.example;
    maxtime=max(path.ntime);

    % New figure
    scrsz=get(0,'ScreenSize');
    hfigure=figure('Position',[1 40 scrsz(3) scrsz(4)*0.85]);
    set(hfigure,'name','Artificial Ant Demo');

    % Format plot area
    trailsize=size(trail,1);
    axis('square','ij',[1 trailsize+1 1 trailsize+1]);
    xtick=1:trailsize+1;
    ytick=1:trailsize+1;
    set(gca,'xtick',xtick);
    set(gca,'ytick',ytick);
    set(gca,'XTickLabel',{});
    set(gca,'YTickLabel',{});
    set(gca,'Box','On');
    set(gca,'GridLineStyle','-');
    grid on;

    hold on
    
    % Initialize three arrays with info to draw on the plot
    beenthere=zeros(trailsize,trailsize);
    eatenthere=zeros(trailsize,trailsize);
    seenthere=zeros(trailsize,trailsize);
    
    for ntime=0:maxtime

        cla % necessary to avoid some MATLAB graphical bug (???)
    
        % Current position, direction, and pellets eaten:
        x=path.x(ntime+1);
        y=path.y(ntime+1);
        direction=path.direction(ntime+1);
        npellets=path.npellets(ntime+1);
        looked=path.looked(ntime+1);
        
        % Set ant shape and color
        switch direction
            case 'u'
                antshape='r^';
            case 'r'
                antshape='r>';
            case 'd'
                antshape='rv';
            case 'l'
                antshape='r<';
        end
        
        title(['[Time step: ' int2str(ntime) '/' int2str(maxtime) ']' '    [npellets: ' int2str(npellets) '/' int2str(maxpellets) ']']);
        
        % Update the three arrays
        beenthere(x,y)=1;
        if trail(x,y)
            eatenthere(x,y)=1;
        end
        if looked
            [xlooked,ylooked]=antnewpos(x,y,direction,trail);
            seenthere(xlooked,ylooked)=1;
        end
        
        % Draw in each position
        for i=1:trailsize
        for j=1:trailsize
            
            % Show "been there" and "seen there"
            if beenthere(i,j)
                fill([j j+1 j+1 j],[i i i+1 i+1],[0.8 0.7 0.7]);
            elseif seenthere(i,j)
                fill([j j+1 j+1 j],[i i i+1 i+1],[0.85 0.85 0.9]);
            end
            
            % Show food trail, eaten or not
            if trail(i,j)
                if eatenthere(i,j)
                    plot(j+0.5,i+0.5,'w.')
                else
                    plot(j+0.5,i+0.5,'b.')
                end
            end

        end
        end
    
        % Draw ant
        plot(y+0.5,x+0.5,antshape,'LineWidth',2.75,'MarkerSize',7);
        
        drawnow
        
        if simspeed<0
            pause
        else
            pause(simspeed)
        end
            
    end % for ntime=0:maxtime

    hold off

    sim=0; % or "clear global"... as long as 'sim' does not return 'true'
    fprintf(' Done!\n\n');

end
