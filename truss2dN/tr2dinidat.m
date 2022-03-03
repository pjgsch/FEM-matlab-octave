%**********************************************************************

function [elda0,eldaB,eldaC,mcl4] = ...
          tr2dinidat(ne,elgr,elda,neip,GDt,lok,crd0,mm);

elda0 = zeros(ne*neip,40);                 % initial data
eldaB = zeros(ne*neip,40);                 % begin (end) increment data
eldaC = zeros(ne*neip,40);                 % current data

mcl3  = 0;       % number of elements with elastoplastic material model
mcl4  = 0;       % number of elements with viscoelastic material model
mcl9  = 0;       % number of elements with SMA material model

for e=1:ne

% Initial geometry parameters of the element are calculated.
% l0   : initial length
% Gl0  : initial stretch ratio
% s0   : initial sine
% c0   : initial cosine

  k1   = lok(e,3); k2 = lok(e,4);
  x10  = crd0(k1,1); y10 = crd0(k1,2); x20 = crd0(k2,1); y20 = crd0(k2,2);
  l0   = sqrt((x20-x10)*(x20-x10)+(y20-y10)*(y20-y10));
  Gl0  = 1;
  s0   = (y20-y10)/l0;
  c0   = (x20-x10)/l0;

  g = elgr(e);                                          % element group 

  mnr  = elda(g,2);      A0   = elda(g,3);      
  E    = elda(g,6);      Gn   = elda(g,7);
  mcl  = floor(mnr/10);  mty  = rem(mnr,10);
  
  C = E;

  if mcl==2                                               % elastomeric
    C = 6*elda(g,8) + 6*elda(g,9);
  end;

  if mcl==3                                             % elastoplastic
    mcl3 = mcl3 + 1; Gsv0 = elda(g,8); 
    if ~exist('hp1'), hp1 = 0; end;
    if ~exist('hp2'), hp2 = 0; end;
    if ~exist('hp3'), hp3 = 0; end;
    if ~exist('hp4'), hp4 = 0; end;
    if ~exist('hp5'), hp5 = 0; end;
  else
    Gsv0 = 0; 
  end;

  if mcl==4                                       % linear viscoelastic
    mcl4 = mcl4 + 1; C = E + sum(mm(:,1)); 
  end;

  if mcl==5                                      % viscoplastic Perzyna
    Gsy0 = elda(g,10); Gsv0 = Gsy0; 
    if ~exist('hp1'), hp1 = 0; end;
    if ~exist('hp2'), hp2 = 0; end;
    if ~exist('hp3'), hp3 = 0; end;
    if ~exist('hp4'), hp4 = 0; end;
    if ~exist('hp5'), hp5 = 0; end;
  end;

  if mcl==6
    Gh0 = elda(g,9);
    sigDGe0 = 1;
  else
    Gh0 = 0; 
  end;

  if mcl==9                                               % SMA NiTiNol
    mcl9 = mcl9 + 1; 
    xi0 = elda(g,8); mf0 = elda(g,9); TT0 = elda(g,10); 
  else
    xi0 = 0; mf0 = 0; TT0 = 0;
  end;

  if mcl==10                                            % cohesive zone
    Gf0 = elda(g,6);
    Gd  = elda(g,7);
    C   = (Gf0/Gd)*(1/Gd) * l0;
  else
    Gf0 = 0; Gd = 0; 
  end;

% CL0  : initial stiffness

  CL0  = A0/l0 * C; 
  Ge   = 0;
  Gs   = 0;

% Data are stored in the data arrays

  elda0(e, 1:10)  = [s0 c0  l0  A0 CL0  0    Gn  E mcl mty ];
  elda0(e,11:20)  = [1  1   0   0  0    0    0   0 0   0   ];       
  elda0(e,21:30)  = [0  xi0 mf0 0  Gsv0 Gh0  1   E TT0 0   ];
  elda0(e,31:40)  = [0  0   0   0  0    Gf0  Gd  C 0   0   ];
end;

eldaC = elda0;
eldaB = eldaC;

%**********************************************************************
