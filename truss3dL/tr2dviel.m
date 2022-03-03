%**********************************************************************
%  elda = [ ety mnr A0 gf2 gf3  emo nuu nmo ];
%----------------------------------------------------------------------
%  mnr  = material number ->
%  mcl  = material class : first digit 
%  mty  = material type  : second digit
%----------------------------------------------------------------------
%  mcl  = 4  ->  viscoelastic material models
%  mty  = 1  ->  integration procedure for general relaxation function
%  mty  = 2  ->  integration procedure for multi-mode Maxwell model
%----------------------------------------------------------------------
%  nmo  = number of modes
%----------------------------------------------------------------------
%  The moduli and time constants for the various modes must be 
%  provided in the array 'mm'.
%**********************************************************************

  GeB = eldaB(e,6); GsB = eldaB(e,7);

  mcl4  = mcl4 + 1;                   % number of viscoelastic elements
  mcl42 = mcl4;
  nmo   = elda(g,8);                                  % number of modes

  Ge   = Gel; 
  Ged  = -Gn*Ge; 
  Gm   = Ged+1;  
  A    = Gm*Gm*A0;
  

if pr=='ie'                                   % integral equation model
%======================================================================

%----------------------------------------------------------------------
if     mty==1
%----------------------------------------------------------------------

HGe(mcl4,ic) = Ge; aa = 0;

for m=1:nmo	   
  Em  = mm(m,2*mcl42-1);
  Gtm = mm(m,2*mcl42);
  aa  = aa + Em*Gtm*exp(-ti/Gtm)*(exp(ts/Gtm)-1);
end;

AA(mcl4,ic) = E + aa/ts;
Gs          = AA(mcl4,ic) * HGe(mcl4,1);

for j=2:ic
  Gs = Gs + AA(mcl4,ic+1-j) * (HGe(mcl4,j) - HGe(mcl4,j-1));
end;

C  = AA(mcl4,1);

%----------------------------------------------------------------------
elseif mty==2
%----------------------------------------------------------------------
% This procedure works for generalized Maxwell models.

DGe = Ge - eldaB(e,6);

CC = 0; SS = 0;

for m=1:nmo
  Em  = mm(m,2*mcl42-1);
  Gtm = mm(m,2*mcl42);
  ee  = exp(-ts/Gtm);
  pm  = Gtm/ts*(1-ee);
  s1  = ee * HGsB(mcl4,m);
  s2  = Em*pm*DGe;
  SS  = SS + s1 + s2;
  CC  = CC + Em*pm;
  HGsC(mcl4,m) = s1 + s2;
end;

Gs = E*Ge + SS;
C  = E + CC;

%----------------------------------------------------------------------
end;
%======================================================================
elseif pr=='de'                           % differential equation model
%----------------------------------------------------------------------

A = mm(1,2);
B = E;
C = mm(1,2)*(mm(1,1)+E)/mm(1,1);

GDGe = Ge - GeB;
Gs = (1/(GDt+A)) * (A*GsB + GDt*B*Ge + C*GDGe);

%----------------------------------------------------------------------
end; % pr
%----------------------------------------------------------------------

CL = A/l0 * C;

%**********************************************************************
