function test_bug1756

% TEST test_bug1756
% TEST assert(ft_voltype ft_prepare_headmodel

cd /home/common/matlab/fieldtrip/data/test/bug1756

% this contains three cumulative or overlapping BEM tissues
load seg3.mat
load grad
load elec

cfg = [];
cfg.tissue = 'scalp';
cfg.numvertices = 1000;
mesh1 = ft_prepare_mesh(cfg, seg3);

cfg = [];
cfg.tissue = {'scalp', 'skull', 'brain'};
cfg.numvertices = [300 600 900];
mesh3 = ft_prepare_mesh(cfg, seg3);

cfg = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EEG volume conduction models
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg.method ='singlesphere'       % analytical single sphere model
singlesphere_eeg = ft_prepare_headmodel(cfg, mesh1);

cfg.method ='concentricspheres'  % analytical concentric sphere model with up to 4 spheres
concentricspheres = ft_prepare_headmodel(cfg, mesh3);

% this one does not run on my (=roboos) Apple Desktop computer, hence I skip it for the moment
% cfg.method ='openmeeg'           % boundary element method, based on the OpenMEEG software
% openmeeg = ft_prepare_headmodel(cfg, mesh3);

cfg.method ='bemcp'              % boundary element method, based on the implementation from Christophe Phillips
bemcp = ft_prepare_headmodel(cfg, mesh3);

cfg.method ='dipoli'             % boundary element method, based on the implementation from Thom Oostendorp
dipoli = ft_prepare_headmodel(cfg, mesh3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MEG volume conduction models
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg.method ='singlesphere'       % analytical single sphere model
singlesphere_meg = ft_prepare_headmodel(cfg, mesh1);

cfg.method ='localspheres'       % local spheres model for MEG, one sphere per channel
cfg.grad = grad;
localspheres = ft_prepare_headmodel(cfg, mesh1);
cfg = rmfield(cfg, 'grad');

cfg.method ='singleshell'        % realisically shaped single shell approximation, based on the implementation from Guido Nolte
singleshell = ft_prepare_headmodel(cfg, mesh1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ensure assert(ft_voltype works for each of the volume conduction models
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert(ft_voltype(bemcp, 'bemcp'))
assert(ft_voltype(dipoli, 'dipoli'))
assert(ft_voltype(singleshell, 'singleshell'))
assert(ft_voltype(concentricspheres, 'concentricspheres'))
assert(ft_voltype(localspheres, 'localspheres'))
assert(ft_voltype(singlesphere_eeg, 'singlesphere'))
assert(ft_voltype(singlesphere_meg, 'singlesphere'))

assert(ft_voltype(bemcp, 'bem'))
assert(ft_voltype(dipoli, 'bem'))
assert(~ft_voltype(singleshell, 'bem'))

