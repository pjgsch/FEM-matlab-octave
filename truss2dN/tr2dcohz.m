%**********************************************************************
% cohesive zone
%======================================================================

Gf0 = elda0(e,36);
Gd  = elda0(e,37);
CL0 = elda0(e,38);
Gm  = 0;
Ge  = Gel;

% In a CZ-truss the cross-sectional area is assumed to be constant.

A  = A0;

% The stress in a CZ-truss equals the traction T from the CZ-law.

Gs = (Gf0/Gd)*(GD/Gd)*exp(-(GD/Gd));

% The material stiffness is 'dGs/dGl' or 'dT/dGl'.
% This equals 'dT/dGD * dGD/dGl = dT/dGD * l0'.

C  = (Gf0/Gd)*(1/Gd)*(1-(GD/Gd))*exp(-(GD/Gd)) * l0;

% The truss-stiffness is 'A/l0 * C' as usual.

CL = A/l0 * C;

% For compression, the stiffness is very large.

if GD<0, CL = 1e2*CL0; end;

CV = 0;

%**********************************************************************
