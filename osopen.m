
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%   ROUTINE FOR OPENING OSIRIS 4.0 DATA FILES                           %
%   OPENS HDF5 FORMAT FILES AND RETURNS DATA + AXES                     %
%   AGRT 2019                                                           %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[X,Y,Z,data,time] = osopen(filename)


% GET HDF5 INFO
fileinfo = hdf5info(filename);
level1 = fileinfo.GroupHierarchy;

% NUMBER OF DIFFERENT FIELDS
% These are based on the OSIRIS data sets
ngroups=1;
ndatasets=1;
nattributes=10;

%Expand next level
level2_groups=level1.Groups; % These are the axes
level2_datasets=level1.Datasets; % This is the data 
level2_attributes=level1.Attributes.Name; %These are the labels

time=level1.Attributes(7).Value;



% GET ATTRIBUTES
    
%% SET UP AXES
dims =  size(level2_groups(1).Datasets,2);

for dim=1:dims
axesdataset=level2_groups(1).Datasets(dim).Name;
if (dim==1)
    axes_x= hdf5read(filename,axesdataset);
else
    axes_x= [ axes_x hdf5read(filename,axesdataset)] ;
end

end
%dims = 1;
%axesdataset=level2_groups(1).Datasets.Name;


axes_x= hdf5read(filename,axesdataset);

%% NOW GET DATA

dataset = level2_datasets.Name;
data = hdf5read(filename,dataset);

% Now set up correct axes to return
% Now set up correct axes to return
if dims==1
    % Construct correct 1D axes
    X=linspace(axes_x(1,1),axes_x(2,1),size(data,1));
    Y=[];
    Z=[];
    data=data';
elseif dims==2
    % Construct correct 2D axes
    x=linspace(axes_x(1,1),axes_x(2,1),size(data,1));
    y=linspace(axes_x(1,2),axes_x(2,2),size(data,2));
    z=[];
    [X,Y]=meshgrid(x,y);
    Z=z;
    data=data';
elseif dims==3
    % Construct correct 3D axes
    x=linspace(axes_x(1,1),axes_x(2,1),size(data,1));
    y=linspace(axes_x(1,2),axes_x(2,2),size(data,2));
    z=linspace(axes_x(1,3),axes_x(2,3),size(data,3));
    [X,Y,Z]=meshgrid(x,y,z);
    
    % Data has funny orientation - this rotates and corrects
    data = permute(data,[3 1 2]);
    data = flipdim(data,2);
end

