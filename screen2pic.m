function screen2pic(filename)

% Saves figures in form of your choise. 


% Comment out to select how you would like to save figures. 

% Save files along designated path. Supports standard image formats and
% .fig

%   Sets image dimensions consistent with the figure's screen dimensions.
%
%   SCREEN2JPEG('filename') saves the current figure to the
%   picture file of your choice with name "filename".
%
%    Sean P. McCarthy
%    Copyright (c) 1984-98 by MathWorks, Inc. All Rights Reserved

if nargin < 1
     error('Not enough input arguments!')
end


%       Save as Figure
% set(gcf,'units','normalized','outerposition',[0 0 1 1])
% savefig(filename);
    

%       Save as Image
type = '-dpng';

set(gcf,'units','normalized','outerposition',[0 0 1 1])

oldscreenunits = get(gcf,'Units');

oldpaperunits = get(gcf,'PaperUnits');

oldpaperpos = get(gcf,'PaperPosition');

set(gcf,'Units','pixels');

scrpos = get(gcf,'Position');

newpos = scrpos/100;

set(gcf,'PaperUnits','inches', 'PaperPosition',newpos)

print(type, filename, '-r300');

set(gcf,'Units',oldscreenunits, 'PaperUnits',oldpaperunits,...
     'PaperPosition',oldpaperpos)

