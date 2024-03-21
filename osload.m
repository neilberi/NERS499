%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%   ROUTINE FOR SHOWING- OSIRIS 4.0 DATA FILES BASED ON:                %
%   field - 'E1', 'charge-electrons' etc.                               %
%   field is CASE SENSITIVE!                                            %
%   basedir - base folder where information is contained                %
%   speciesname - only applies for charge and phasespaces               %
%   filenum - the number of the datafile to be opened
%   AGRT 2019                                                           %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X,Y,Z,data,var,time] = osload(basedir,field,speciesname,averaging, filenum)
% construct number string
numstr=int2str(filenum);

if ~strcmp(averaging,'')
  nameave = [field '-' averaging];
else
  nameave = field;
end
while (length(numstr)<6)
    numstr=['0' numstr];
end 

%  construct correct directory path and filename:
dir = [basedir '/MS/'];
switch field
    case {'e1','e2','e3','j1','j2','j3','b1','b2','b3','ene_emf'}
        dir = [dir 'FLD/' nameave '/'];
        filename = [nameave '-' numstr '.h5'];
        var = field;
    case {'charge'}
        dir = [dir 'DENSITY/' speciesname '/' nameave '/'];
        filename = [nameave '-' speciesname '-' numstr '.h5'];
        var = [field '-' speciesname]; 
    case {'gamma', 'p1x1', 'p1x2', 'p1x3', 'p2x1', 'p2x2', 'p2x3','p3x1','p3x2','p3x3','p2p1', 'p3p1','p3p2','p3p2p1','x2x1','x3x1','x3x2','x3x2x1','x1'}
        dir = [dir 'PHA/' field '/' speciesname '/'];
        filename = [field '-' speciesname '-' numstr '.h5'];
        var = [field '-' speciesname];
end
filename = [dir filename];
[X,Y,Z,data,time]=osopen(filename);

