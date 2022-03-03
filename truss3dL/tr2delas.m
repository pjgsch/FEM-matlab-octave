%**********************************************************************
%  elda = [ ety mnr A0 gf2 gf3  emo nuu ];
%----------------------------------------------------------------------
%  mnr  = material number ->
%  mcl  = material class : first digit 
%  mty  = material type  : second digit
%----------------------------------------------------------------------
%  mcl  = 1  ->  elastic material models
%  mty  = #  ->  model number (see source below)
%----------------------------------------------------------------------
%  emo  = parameter relating axial stress to axial strain
%  nuu  = Poisson's ratio
%**********************************************************************

GlB  = eldaB(e,11);
GeB  = eldaB(e,6);
GsB  = eldaB(e,16);
GDGl = Gl - GlB;

if     mty==1                           % Cauchy stress - linear strain
  Ge   = Gel;   Ged = -Gn*Ge; Gm = Ged+1; 
  A    = Gm*Gm*A0;
  GDGs = E*(Ge-GeB);
%  Gs   = E*Ge;
  Gs   = GsB + GDGs;
  C    = E;
  CL   = A/l0 * C; 
  CA   = 0;
  CL   = CL + CA;
elseif mty==2                      % Cauchy stress - logarithmic strain
  Ge   = Geln;  Ged = -Gn*Ge; Gm = exp(Ged); 
  A    = Gm*Gm*A0;
%  GDGs = E*(Ge-GeB);
  Gs   = E*Ge;
%  Gs   = GsB + GDGs;
  C    = (1/Gl) * E;
  CL   = A/l0 * C; 
  CA   = 0;
  CL   = CL + CA;
elseif mty==3                   % Cauchy stress - Green-Lagrange strain
  Ge   = Gegl;  Ged = -Gn*Ge; Gm = sqrt(2*Ged+1); 
  A    = Gm*Gm*A0;
  Gs   = E*Ge;
  C    = Gl * E;
  CL   = A/l0 * C; 
  CA   = 0;
  CL   = CL + CA;
elseif mty==4             % 2nd Piola-Kirchhoff - Green-Lagrange strain
  Ge   = Gegl;  Ged = -Gn*Ge; Gm = sqrt(2*Ged+1);
  A    = Gm*Gm*A0;
  Gs   = E*Ge*Gl/(Gm*Gm);
  C    = A0/A * (Gm*Gm*Gs/Gl + Gl*Gl*E);
  CL   = A/l0 * C;
  CA   = 0;
  CL   = CL + CA;
end;

C1 = C;                  
C2 = (Gs-GsB)/(Gl-GlB); 

%**********************************************************************
