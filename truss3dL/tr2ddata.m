%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% INPUT 'tr2d.m'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Clear the Matlab environment and some files.
%
% close all; clear all;
% delete('loadincr.m'); delete('savedata.m');
%
%%%% 'loadincr.m' is called by 'tr2d.m' to define the incremental load.
%%%% It can be made separately with an editor, but is more easier
%%%% generated from within the input file, usinf 'fprintf()'.
%%%% It can also be generated with the function 'mloin.m'.
%%%%
%%%% 'savedata.m' is called by 'tr2d.m' to save data for postprocessing.
%%%% This file is also generated in the input file or with the function
%%%% 'msada.m'.
%%%%
%%%% For 'tr2dL.m' these files are not needed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initial nodal point coordinates.
%
% crd0 = [ x1 y1; x2 y2; ... ];
%  
%%%% x1  = x-coordinate node 1
%%%% y1  = y-coordinate node 1
%
%%%% Location array : topology of element division.
%
% lok  = [ elty elgr node1 node2 ; ... ]; one row for each element
%
%%%% elty  = element type
%%%% elgr  = element group
%%%% node1 = global node number of element node 1
%%%% node2 = global node number of element node 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initial element data.
%%%% For each element group, a row in the array 'elda' must appear.
%
% elda = [ ety mnr A0 gf2 gf3  parameters ; ... ];
%
%%%% ety  = element type
%%%% mnr  = material number
%%%%      = 1# :  elastic material                         % tr2delas.m
%%%%      = 2# :  elastomeric material                     % tr2delam.m
%%%%      = 3# :  elastoplastic material                   % tr2delpl.m
%%%%      = 4# :  linear viscoelastic material             % tr2dviel.m
%%%%      = 5# :  viscoplastic material (Perzyna)          % tr2dperz.m
%%%%      = 6# :  nonlinear viscoelastic material (EPG)    % tr2dleon.m
%%%%      = 7# :  elastoviscous material (creep)           % tr2delvi.m
%%%% A0   = initial cross-sectional area
%%%% gf2  = geometry parameter; not used 
%%%% gf3  = geometry parameter; not used 
%%%%
%%%% Parameters are different for every material. See end of this file.
%
%%%% Parameters for Multi-Mode Maxwell model for viscoelasticity.
%%%% Parameters are provided in rows for each mode.
%
% mm = [ Em Gtm; ... ];
% 
%%%% Em  = modulus
%%%% Gtm = time constant
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%% Definition of local coordinate system in nodes (angle wrt 1-axis).
% 
% tr = [ node angle; ... ]
%
%%%% Prescribed nodal (incremental( displacement.
%
% pp = [ node dof value ; ... ];
%
%%%% Prescribed nodal (incremental( force.
%
% pf = [ node dof value ; ... ];
%
%%%% Information for links between degrees of freedom.
%
% pl  = [ node dof ; ... ];           linked degrees of freedom 
% pr  = [ node dof ; ... ];           retained degrees of freedom 
% lim = [ ... ... ; ... ... ; .. ];   link matrix
% lif = [ ... ];                      link factors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% For the nonlinear program 'tr2d.m' some control parameters must
%%%% be provided.
%
% nic = number of increments                  default = 1
% ts  = incremental time step                 default = 0
% mit = maximum iterations per increment      default = 10
% ccr = convergence criterion                 default = 0.01
% cnm = convergence norm                      default = 1
% nl  = nonlinear switch (see tr2d.m)         default = 0
% slw = allow cutbacks                        default = 1
%
%%%% These parameters may also be stored in the array 'cntr'.
%%%% cntr = [nic ts mit ccr];
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% LOAD HISTORY
%
%%%% The m-file 'loadincr.m' can be written here.
%%%% It may be provided elsewhere.
%%%% When it is missing, a default file is written in 'tr2dchkinp.m'.
%
% loin = fopen('loadincr.m','w');
% fprintf(loin,'peC = incremental displacement; \n');
% fprintf(loin,'feC = total load; \n');
% fclose(loin);
%
%%%% The function file 'mloin.m' can be used to generate a 
%%%% function 'Sft' of the time 'St', which can be used to 
%%%% make 'peC' and 'feC'.
%%%% See this function file for more information. 
% 
%  [St,Sft,nic,tinc,tend] = mloin(0,10,100,0,'saw',[20 0 0 0.1]); plot(St,Sft);grid on;
%  [St,Sft,nic,tinc,tend] = mloin(0,10,100,0,'blk',[2 1 -1 0 0]); plot(St,Sft);grid on;
%  [St,Sft,nic,tinc,tend] = mloin(0,10,100,0,'jmp',[0 1 4 2]); plot(St,Sft);grid on;
%  [St,Sft,nic,tinc,tend] = mloin(0,10,100,0,'pol',[0 0 2 10 3 10 10 0]); plot(St,Sft);grid on;
%  [St,Sft,nic,tinc,tend] = mloin(0,10,100,0,'sin(2*t)'); plot(St,Sft);grid on;
%  [St,Sft,nic,tinc,tend] = mloin(0,10,100,0,'sin(2*t)',[0 2]); plot(St,Sft);grid on;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SAVING RESULTS
%
%%%% The m-file 'savedata.m' can be written here. 
%%%% It may be provided elsewhere.
%%%% When it is missing, a default file is written in 'tr2dchkinp.m'.
%
% matf = './mat/defmat' % defmat.mat are incremental results for movies
% sada = fopen('savedata.m','w');
% fprintf(sada,'Sti(ic+1) = ti;          \n');
% fprintf(sada,'Sfx(ic+1) = Mfi(2,1);    \n');
% fprintf(sada,'SGs(ic+1) = eldaC(1,16); \n');
% S1 = 'crd';
% fprintf(sada,'save(savefile,S1); \n');
% fclose(sada);
%
%%%% The function file 'msada.m' can be used to generate 'savedata.m'.
%%%% See this function file for more information.
%
% delete savedata.m
%
% msada('s','crd','s','MTp');     % saves 'crd' and 'MTp' to mat/.
% msada('dsp',[3 1; 4 1]);        % displacements dof 1 in node 3 and 4
% msada('rfc',[3 1; 4 1]);        % reaction forces dof 1 in node 3 and 4
% msada('sts',[1],'stn',[1]);     % stress and strain in ip 1
% msada('eld',[2 6]);             % element 2, parameter 6
% msada('ipd',[2 1 20; 2 1 22]);  % element 2, ip 1, parameter 22
%
% type savedata
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% CHECK INPUT, INITIALIZE DATABASE AND VALUES
%
%%%% The command file 'tr2dchckinp.m' checks the input, provides
%%%% default values and calculates pramaters.
%
% nndof = 2;                % number of nodal degrees of freedom 
% nnod  = size(crd0,1);     % number of nodes
% ndof  = nnod*nndof;       % number of system degrees of freedom
% ne    = size(lok,1);      % number of elements
% nenod = size(lok,2)-2;    % number of element nodes 
% nedof = nndof*nenod;      % number of element degrees of freedom
% negr  = size(elda,1);     % number of element groups
% neip  = 1;                % number of element integration points
%
%%%% The command file 'fbiblcase.m' reorganizes boundary conditions
%%%% and link relations from the input data.
%
% lc#   = loadcase : maximum 5+1 loadcases at this moment
% npdof = number of prescribed nodal point variables   = size(pp,1)
% nudof = number of unknown degrees of freedom         = ndof-npdof
% npfor = number of prescribed nodal flow variables    = size(pf,1)
% ntr   = number of nodal transformations              = size(tr,1)
% npl   = number of linked degrees of freedom          = size(pl,1)
% npr   = number of retained degrees of freedom        = size(pr,1)
%
% ppc   = column with prescribed displacement components (dof's)
% ppv   = column with prescribed degrees of freedom values
% pfc   = column with prescribed load components
% pfv   = column with prescribed load component values
% plc   = column with linked displacement components (dof's)
% prc   = column with retained displacement components (dof's)
% pe0   = array with prescribed initial displacement components
% fe0   = array with prescribed initial force components
%
%%%% The command file 'tr2dinidat.m' generates the data base arrays.
%
% elda0 = zeros(ne*neip,40);               % initial data
% eldaB = zeros(ne*neip,40);               % begin (end) increment data
% eldaC = zeros(ne*neip,40);               % current data
%
%%%% In a loop over all the elements, parameter data are extracted
%%%% and/or calculated from the input data. 
%%%% In section OUTPUT, the location of the data is explained.
%
%%%% The command file 'tr2dinizer.m' initialized arrays
%%%% Nodal data
%
% pe    = column with prescribed incremental nodal disp. components
% Dp    = column with iterative nodal displacement components
% Ip    = column with incremental nodal displacement components
% Tp    = column with total nodal displacement components
% fe    = column with external (applied) nodal force components
% fi    = column with internal (resulting) nodal force components
% rs    = column with residual nodal forces = fe - fi
% peC   = array with prescribed actual displacement components
% feC   = array with prescribed actual force components
%
%%%% Element data
%
% AA    = array with parameters for visco-elastic material
% HGe   = array with incremental strains for visco-elastic material
% HGsB  = array with incremental stress for visco-elastic material
% HGSC  = array with incremental stress for visco-elastic material
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PROGRAM PARAMETERS
%
% ic    = increment counter
% ti    = total time
% it    = iteration step counter
% slow  = cutback parameter
% nrm   = convergence norm
%
% ec    = array with element nodal coordinates
% em    = element stiffness matrix = CL * ML + CN * MN
%         CL = coefficient : material stiffness
%         ML = geometry matrix 
%         CN = coefficient : geometric stiffness
%         MN = geoetry matrix
% ef    = element internal load column
% sm    = assembled global stiffness matrix
% fi    = assembled global internal load column
%
% sol   = column with solved degrees of freedom
% p     = column withh all degrees of freedom 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% OUTPUT : NODAL DATA
%
% Dp    = column with iterative nodal disp. components    : global c.s.
% DpT   = column with iterative nodal disp. components    : local c.s.
% Ip    = column with incremental nodal disp. components  : global c.s.
% IpT   = column with incremental nodal disp. components  : local c.s.
% Tp    = column with total nodal displacement components : global c.s.
% TpT   = column with total nodal displacement components : local c.s.
% crd   = current nodal coordinates
%
%%%% The command file 'fbibcol2mat1.m' reshapes the columns with
%%%% component values into matrices with nodal values.
%
% Mp    = iterative nodal displacements
% MDp   = iterative nodal displacements     
% MIp   = incremental nodal displacements
% MTp   = total nodal displacements
% Mfe   = external nodal forces
% Mfi   = internal nodal forces
% Mrs   = residual nodal forces
%
%%%% When local nodal coordinate systems are defined, the local dof's
%%%% are found in: MTpT. MfiT and MrsT.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% OUTPUT : ELEMENT DATA
%
%%%% Element data : for each element on a row in the array 'eldaB'
%%%% For various materials the data in a column are different.
%%%% Initial values are stored in 'elda0' and current (not converged)
%%%% values are stored in 'eldaC'.
%
% eldaB(e, 1:10)    = [s  c    l     A    CL   Ge   Gs     E  mcl mty ];
% eldaB(e,11:20)    = [Gl Gm   Gel   Geln Gegl Gs   P      N  0   0   ];
% eldaB(e,31:40)    = [CN CI   CV    0    0    Gf0  Gd     C  0   0   ];
% mcl :
% 1: eldaB(e,21:30) = [0  0    0     0    0    0    0      0  0   0   ];
% 2: eldaB(e,21:30) = [0  0    0     0    0    0    0      0  0   0   ];
% 3: eldaB(e,21:30) = [Ge Gep  Gepe  Gs   Gsv  Gss  Gb     0  0   0   ];
% 4: eldaB(e,21:30) = [0  0    0     0    0    0    0      0  0   0   ];
% 5: eldaB(e,21:30) = [Ge Gevp BGevp Gs   Gsy  Gee  Gll    C  0   0   ];
% 6: eldaB(e,21:30) = [Ge Gee  Gev   BGev D    Gh   sigDGe 0  0   0   ];
% 7: eldaB(e,21:30) = [Ge Gee  Gev   Gs   0    0    0      0  0   0   ];
%
%%%% Parameters are explained in the appropriate material m-files.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% MATERIAL PARAMETERS
%
%%%% elastic
%
% elda = [ ety mnr A0 gf2 gf3  emo nuu ];
% mcl  = 1  ->  elastic material models
% mty  = 1  ->  Cauchy stress - linear strain
% mty  = 2  ->  Cauchy stress - logarithmic strain
% mty  = 3  ->  Cauchy stress - Green-Lagrange strain
% mty  = 4  ->  2nd Piola-Kirchhoff - Green-Lagrange strain
% emo  = parameter relating axial stress to axial strain
% nuu  = Poisson's ratio
%
%%%% elastomeric
%
% elda = [ety mnr A0 gf2 gf3  0 0 C10 C01 C11 ];
% mcl  = 2  ->  elastomeric material models
% mty  = 1  ->  Neo-Hookean
% mty  = 2  ->  Mooney-Rivlin
% Cij  = Mooney parameters 
%
%%%% elastoplastic
%
% elda = [ ety mnr A0 gf2 gf3  emo nuu Gsv H K ee ];
% mcl  = 3  ->  elastoplastic material model
% mty  = 1  ->  linear hardening
% mty  = 2  ->  exponential hardening
% emo  = Young's modulus
% nuu  = Poisson's ratio
% Gsv  = initial yield stress
% H    = hardening parameter for isotropic hardening
% K    = hardening parameter for kinematic hardening
% ee   = exponent for exponential hardening
% Hardening laws have to be specified with 'hm'
% hm   = 'li'  ->   linear
% hm   = 'lu'  ->   Ludwik
% hm   = 'ml'  ->   modified Ludwik
% hm   = 'sw'  ->   Swift
% hm   = 'pr'  ->   Prager
% hm   = 'b1'  ->   Betten1
% hm   = 'b2'  ->   Betten2
% hm   = 'vc'  ->   Voce
%
%%%% linear viscoelastic
%
% elda = [ ety mnr A0 gf2 gf3  emo nuu nmo ];
% mcl  = 4  ->  viscoelastic material models
% mty  = 1  ->  integration procedure for general relaxation function
% mty  = 2  ->  integration procedure for multi-mode Maxwell model
% nmo  = number of modes
% The moduli and time constants for the various modes must be 
% provided in the array 'mm'.
%
%%%% viscoplastic (Perzyna)
%
% elda = [ ety mnr A0 gf2 gf3  emo nuu Gg N Gsy0 H a b c d ];
% mcl  = 5  ->  viscoplastic material model (Perzyna)
% emo  = Young's modulus
% nuu  = Poisson's ratio
% Gg   = material parameter
% N    = material parameter
% Gsy0 = initial yield stress
% H    = hardening parameter
% a-d  = hardening parameters
% Hardening laws have to be specified with 'hm'
% hm   = 'li'  ->  linear
% hm   = 'so'  ->  softening
% hm   = 'lu'  ->  Ludwik
% hm   = 'pr'  ->  Prager
%
%%%% nonlinear viscoelastic (EPG)
%
% elda = [ ety mnr A0 gf2 gf3  emo nuu T Gh0 H h Dinf AA0 GDH Gmm Gt0 ];
% mcl  = 6  ->  viscoelastic material model (Leonov)
% emo  = Young's modulus
% nuu  = Poisson's ratio
% T    = absolute temperature
% Gh0  = material parameter
% H    = material parameter
% h    = material parameter
% Dinf = material parameter
% AA0  = material paramater
% GDH  = material parameter
% Gmm  = material parameter
% Gt0  = material parameter
%
%%%% elastoviscous (creep)
%
% elda = [ ety mnr A0 gf2 gf3  emo nuu p1 p2 p3 p4 p5 p6 p7 p8 ];
% mcl  = 7  ->  elastoviscous material model (creep)
% mty  = 1  ->  Norton
% mty  = 2  ->  Dorn
% mty  = 3  ->  Andrade
% mty  = 6  ->  Wiese 2-term model
% more models are implemented for the explicit integration scheme
% emo  = Young's modulus
% nuu  = Poisson's ratio
% p1-8 = material parameters
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PLOTTING
%
%%%% A plot of the mesh is made with 'plotmesh.m'.
%
% plotmesh(<option>,lok,crd0,crd,eldaC,<varnum>);  
%
% option    = column with options
% option(1) = magfac = magnification factor for displacements
% option(2) = inimsh = initial mesh (1)
% option(3) = nodpnt = nodal point numbers (1)
% option(4) = elmnrs = element numbers (1)
% option(5) = intpnt = 
% option(6) = isodir = 
% option(7) = matdir = material directions (not for truss)
% option(8) = pssdir = principal stress directions (not for truss)
% option(9) = inpval = integration point values (1) : varnum
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
