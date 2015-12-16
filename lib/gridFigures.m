function gridFigures(screen_position, fig_vector, varargin)
% 
% GRIDFIGURES   set a vector of figures in a grid on the screen
% 
% GRIDFIGURES(SCREEN_POSITION, FIG_VECTOR) set the outerposition of the figures in FIG_VECTOR in
%   a non-overlapping grid on the screen with dimensions in SCREEN_POSITION.
% 
%   - SCREEN_POSITION: four-element vector correspondent to the screen 
%       dimensions: [left, bottom, width (total), height (total)]
%        
%   - FIG_VECTOR: vector of the handles to the figure objects.
% 
% GRIDFIGURES(..., NUMFIL, NUMCOL) - set the figures into a
%     NUMFIL-by-NUMCOL grid.
% 
% 
% EXAMPLE: Six figures are ploted into a 2x3 grid. Ingnoring a band of 50
%    pixels on the botom of the screen.
% 
%     numFigures = 6;
%     fig_list = NaN .* ones(1, numFigures);
%     x = 1:0.1:2*pi;
%     for i=1:numFigures
%         fig_list(i) = figure;
%         plot(x, sin(i*x));
%     end
% 
%     screen_position    = get(0, 'ScreenSize');
%     screen_position(2) = 50; 
% 
%     gridFigures(screen_position, fig_list, 2,3)
% 
% 
% EXAMPLE: Six figures are ploted into a unkown grid. Ingnoring a band of 50
%    pixels on the botom of the screen.
% 
%     numFigures = 7;
%     fig_list = NaN .* ones(1, numFigures);
%     x = 1:0.1:2*pi;
%     for i=1:numFigures
%         fig_list(i) = figure;
%         plot(x, sin(i*x));
%     end
% 
%     screen_position    = get(0, 'ScreenSize');
%     screen_position(2) = 50; 
% 
%     gridFigures(screen_position, fig_list)
% 
% 
% tags: figure, grid, position, outerposition
% 
% 
% author: Mar Callau-Zori
% PhD student - Universidad Politecnica de Madrid
% 
% version: 1.1, December 2011
% 

    % input parameters
    if nargin>2
        numFil = varargin{1};
        numCol = varargin{2};
        
        if ~isnumeric(numFil) || ~isnumeric(numCol) ...
                || numFil * numCol < length(fig_vector)
            error('gridFigures:argChk', 'Wrong input arguments');
        end
    else
        [numFil, numCol] = compute_NumFig_numClo(length(fig_vector));
    end

    width_fig  = (screen_position(3)-screen_position(1)) ./ numCol;
    height_fig = (screen_position(4)-screen_position(2)) ./ numFil;
    
    y_pos = screen_position(4)-height_fig;
    count = 0;
    for i=1:numFil
        x_pos = screen_position(1); 
        for j=1:numCol
            count = count+1;
            fig_pos = [x_pos, y_pos, width_fig, height_fig];
            fig_units = get(fig_vector(count), 'Units');
            set(fig_vector(count), 'Units', 'pixels');
            set(fig_vector(count), 'outerposition', fig_pos);
            set(fig_vector(count), 'Units', fig_units);
            getframe(fig_vector(count));
            x_pos = x_pos + width_fig;
            
            if count == length(fig_vector)
                break;
            end
            
        end    
        y_pos = y_pos - height_fig;
        
        if count == length(fig_vector)
            break;
        end
            
    end

end

function [numFil, numCol] = compute_NumFig_numClo(numTotal)

    sqrt_total = sqrt(numTotal);
    numFil = floor(sqrt_total);
    numCol = ceil(sqrt_total);
    
    if numFil * numCol < numTotal
        numCol = numCol+1;
    end

end
