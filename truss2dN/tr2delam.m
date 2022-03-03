%**********************************************************************
%  elda = [ety mnr A0 gf2 gf3  0 0 C10 C01 C11 ];
%----------------------------------------------------------------------
%  mnr  = material number ->
%  mcl  = material class : first digit 
%  mty  = material type  : second digit : see source below
%----------------------------------------------------------------------
%  mcl  = 2  ->  elastomeric material models
%  mty  = #  ->  model number (see source below)
%----------------------------------------------------------------------
%  Cij  = Mooney parameters 
%**********************************************************************

C10  = elda(g,8);                                % elasticity parameter 
C01  = elda(g,9);                                % elasticity parameter 
C11  = elda(g,10);                               % elasticity parameter

GlB  = eldaB(e,11);
GsB  = eldaB(e,16);
GDGl = Gl-GlB;

if     mty==1                                             % Neo-Hookean
  Ge   = Gel;   Ged = -Gn*Ge; Gm = sqrt(1/Gl); 
  A    = Gm*Gm*A0;
  Gs   = 2*C10*(Gl*Gl - 1/Gl);
%  GDGs = 2*C10*(2*Gl + 1/(Gl*Gl))*GDGl;
%  Gs   = GsB + GDGs;
  C    = 2*C10 * (2*Gl + 1/(Gl*Gl));
  CL   = A/l0 * C; 
  CA   = 0;
  CL   = CL + CA;
elseif mty==2                                           % Mooney-Rivlin
  Ge   = Gel;   Ged = -Gn*Ge; Gm = sqrt(1/Gl); 
  A    = Gm*Gm*A0;
  Gs   = 2*( C10*(Gl*Gl - 1/Gl) + C01*(Gl - 1/(Gl*Gl)) ); 
  C    = 2*( C10*(2*Gl + 1/(Gl*Gl)) + C01*(1 + 2/(Gl*Gl*Gl)) );
  CL   = A/l0 * C;
  CA   = 0;
  CL   = CL + CA;
end;

%**********************************************************************
