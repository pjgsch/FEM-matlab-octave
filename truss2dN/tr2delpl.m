%**********************************************************************
%  elda = [ ety mnr A0 gf2 gf3  emo nuu Gsv H K ee ];
%----------------------------------------------------------------------
%  mnr  = material number ->
%  mcl  = material class : first digit 
%  mty  = material type  : second digit
%----------------------------------------------------------------------
%  mcl  = 3  ->  elastoplastic material model
%  mty  = #  ->  no used
%----------------------------------------------------------------------
%  emo  = Young's modulus
%  nuu  = Poisson's ratio
%  Gsv  = initial yield stress
%  H    = hardening parameter for isotropic hardening
%  K    = hardening parameter for kinematic hardening
%  ee   = exponent for exponential hardening
%----------------------------------------------------------------------
%  Hardening laws have to be specified with 'hm'
%  hm   = 'li'  ->   linear
%  hm   = 'lu'  ->   Ludwik
%  hm   = 'ml'  ->   modified Ludwik
%  hm   = 'sw'  ->   Swift
%  hm   = 'pr'  ->   Prager
%  hm   = 'b1'  ->   Betten1
%  hm   = 'b2'  ->   Betten2
%  hm   = 'vc'  ->   Voce
%  see source below for more
%**********************************************************************

% Hardening parameters are initialized.

if ~exist('hp1'), hp1 = 0; end;
if ~exist('hp2'), hp2 = 0; end;
if ~exist('hp3'), hp3 = 0; end;
if ~exist('hp4'), hp4 = 0; end;
if ~exist('hp5'), hp5 = 0; end;

% Parameters from 'elda'

Gsv0 = elda(g,8);                     % initial Yield stress
H    = elda(g,9);                     % isotropic hardening parameter
K    = elda(g,10);                    % kinematic hardening parameter
Gev0 = Gsv0/E;

% Begin-increment values

GeB = eldaB(e,21); GepB = eldaB(e,22); GepeB = eldaB(e,23);
GsB = eldaB(e,24); GsvB = eldaB(e,25); GssB  = eldaB(e,26);
GllB = eldaB(e,28);
YB = (GsB-GssB)^2-GsvB^2;

if it==1, Gepe = GepeB; Gll = GllB; end;

% Strain and contraction

Ge   = Gel;   
Ged  = -Gn*Ge; 
Gm   = Ged+1;  
A    = Gm*Gm*A0;
GDGe = Ge - GeB; 

% Elastic stress predictor and yield function

Gse  = GsB + E*(Ge - GeB);
GxB  = GsB - GssB;
Gx   = Gse - GssB;
Y    = Gx*Gx - GsvB*GsvB;

% Initialize all to begin-increment value

GDGs = 0; 
GDGl = 0;
Gs   = GsB;
Gll  = GllB;
Gsv  = GsvB;
Gss  = GssB;
Gep  = GepB;
Gepe = GepeB;

%----------------------------------------------------------------------
if pr=='im'
%----------------------------------------------------------------------

if Y<=0
  Gep  = GepB;  Gepe = GepeB;
  Gs   = Gse;   Gss  = GssB;   Gsv = GsvB;   GDGl = 0; Gll = GllB;
  C    = E;
else
  
% Initially HH must be made very large because for Gepe=0 it is inf.

  HH = 1e8; KK = 0;

  MM = [ 1+2*E*(Gll-GllB)    2*E*(Gs-Gss) 
         2*(Gs-Gss) ...
         -4*KK*(Gs-Gss)^2-4*HH*Gsv*abs(Gs-Gss) 
       ];
  rr = [ -Gs+GsB-2*E*(Gs-Gss)*(Gll-GllB)+E*(Ge-GeB)
         -Y
       ];

  lccr = 1e-5; lnrm = 1000; lmit = 50; lit = 1; 

  while ((lnrm > lccr) & (lit < lmit))
    aaa  = inv(MM)*rr;
    GdGs = aaa(1); 
    GdGl = aaa(2);

    GDGs = GDGs + GdGs; 
    GDGl = GDGl + GdGl;
    Gll  = GllB + GDGl;
    
    Gs    = GsB + GDGs;
    GDGep = 2*GDGl*(Gs-Gss);
    Gep   = GepB + GDGep;
    Gepe  = GepeB + abs(GDGep);

    [Gsv Gss HH KK] = ...
    hardening(Gep,Gepe,hm,'',E,Gsv0,K,hp1,hp2,hp3,hp4,hp5);

    Y   = (Gs-Gss)*(Gs-Gss) - Gsv*Gsv;

    MM = [ 1+2*E*(Gll-GllB)    2*E*(Gs-Gss) 
           2*(Gs-Gss) ...
           -4*KK*(Gs-Gss)^2-4*HH*Gsv*abs(Gs-Gss) 
         ];
    rr = [ -Gs+GsB-2*E*(Gs-Gss)*(Gll-GllB)+E*(Ge-GeB) 
           -Y
         ];

    lnrm = sqrt(rr'*rr);    

    lit = lit+1;
  end;

%  C = (Gs-GsB)/(Ge-GeB);

%  C = E*( 2*KK*(Gs-Gss)^2 + 2*HH*Gsv*abs(Gs-Gss) )/...
%      ( ...
%       (1 + 2*E*(Gll-GllB))*( 2*KK*(Gs-Gss)^2 + 2*HH*Gsv*abs(Gs-Gss) ) + ...
%       2*E*(Gs-Gss)^2 ...
%      );

   C = ( E*(HH+KK) ) / ( E + KK + HH + 2*E*(KK+HH)*(Gll-GllB) );

end; % Y

Gb = 0;
%----------------------------------------------------------------------
elseif pr=='ex'
%----------------------------------------------------------------------
if Y<=0
  Gb   = 1;
  Gep  = GepB;  Gepe = GepeB;
  Gs   = Gse;   Gss  = GssB;   Gsv = GsvB;   Gll = GllB;
  C    = E;
else
  HH   = H; KK = K;

  Gb   = abs( sign(Ge-GeB)*GsvB - (GsB-GssB) )/abs(Gse - GsB);
  if Gb < 1e-5, Gb=0; end;
  Gef  = GeB + Gb*(Ge - GeB);

% If the next procedure is used,
% the stress is incorrect when the increment is partly elastic.
% In that case the increment has to be split in an elastic
% and an elastoplastic part.

MM = [
 1           2*E*(GsB-GssB)
 GsB-GssB    -2*KK*(GsB-GssB)^2 - 2*HH*GsvB*abs(GsB-GssB) 
];
rr = [ 
 E*(Ge-GeB)*(1-Gb);
 0
];

aaa = inv(MM)*rr;
GDGsf = aaa(1);
GDGll = aaa(2);

Gs    = GsB + Gb*(Gse - GsB) + GDGsf;
Gll   = GllB + GDGll;

GDGep = 2*(Gll-GllB)*(Gs-GssB);
Gep   = GepB + GDGep;
Gepe  = GepeB + abs(GDGep);

[Gsv Gss HH KK] = ...
hardening(Gep,Gepe,hm,'',E,Gsv0,K,hp1,hp2,hp3,hp4,hp5);

%C = (Gs-GsB)/(Ge-GeB);
%C = E*(HH+KK)/(E+HH+KK);
C = ( E*( KK*(GsB-GssB)^2 + HH*GsvB*abs(GsB-GssB) ) )/...
    ( (E+KK)*(GsB-GssB)^2 + HH*GsvB*abs(GsB-GssB) );

end; % Y

%----------------------------------------------------------------------
end; % pr
%----------------------------------------------------------------------

CL = A/l0 * C;

%**********************************************************************
