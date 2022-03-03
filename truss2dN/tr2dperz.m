%**********************************************************************
%  elda = [ ety mnr A0 gf2 gf3  emo nuu Gg N Gsy0 H a b c d ];
%----------------------------------------------------------------------
%  mnr  = material number ->
%  mcl  = material class : first digit 
%  mty  = material type  : second digit
%----------------------------------------------------------------------
%  mcl  = 5  ->  viscoplastic material model (Perzyna)
%----------------------------------------------------------------------
%  emo  = Young's modulus
%  nuu  = Poisson's ratio
%  Gg   = material parameter
%  N    = material parameter
%  Gsy0 = initial yield stress
%  H    = hardening parameter
%  a-d  = hardening parameters
%----------------------------------------------------------------------
%  Hardening laws have to be specified with 'hm'
%  hm   = 'li'  ->  linear
%  hm   = 'so'  ->  softening
%  hm   = 'lu'  ->  Ludwik
%  hm   = 'pr'  ->  Prager
%**********************************************************************

% Parameters from 'elda'

Gg   = elda(g,8);
N    = elda(g,9);
Gsy0 = elda(g,10);
H    = elda(g,11);
a    = elda(g,12);
b    = elda(g,13);
c    = elda(g,14);
d    = elda(g,15);

% Hardening parameters are initialized.

if ~exist('hp1'), hp1 = H; end;
if ~exist('hp2'), hp2 = a; end;
if ~exist('hp3'), hp3 = b; end;
if ~exist('hp4'), hp4 = c; end;
if ~exist('hp5'), hp5 = d; end;

% Begin-increment values

GeB  = eldaB(e,21); GevpB = eldaB(e,22); BGevpB = eldaB(e,23); 
GsB  = eldaB(e,24); GsyB  = eldaB(e,25);
GeeB = eldaB(e,26); GllB  = eldaB(e,27); Gst = GsB;
Gey0 = Gsy0/E;

if it==1, Gevp = GevpB; Gll = GllB; end;

% Strain and contraction

Ge   = Gel;  Ged = -Gn*Ge; Gm = Ged+1; dGedGl = 1;
%Ge   = Geln; Ged = -Gn*Ge; Gm = exp(Ged);  dGedGl = 1/Gl;
%Ge   = Gegl; Ged = -Gn*Ge; Gm = sqrt(2*Ged+1); dGedGl = Gl;
A    = Gm*Gm*A0;
GDGe = Ge - GeB; 

Gse  = GsB + E*(Ge - GeB);
BGse = abs(Gse);
F    = BGse - GsyB;

  GDGs  = 0;
  GDGl  = 0;
  Gs    = GsB;
  Gsy   = GsyB;
  BGs   = abs(Gs);
  BGevp = BGevpB;

if F<0
  Gs   = Gse;    Gsy   = GsyB;
  Gevp = GevpB;  BGevp = BGevpB;
  Gll  = GllB;
  C    = E;
  C1   = E;
  C2   = E;
else

%----------------------------------------------------------------------
if pr=='im'
%----------------------------------------------------------------------

lccr = 1e-5; lnrm = 100; lmit = 50; lit = 1; 

Gff = (F/Gsy0);
Gff = 1/2*(Gff + abs(Gff));
Gf  = Gff^N; 
dGfdF  = N*(F/Gsy0)^(N-1)*(1/Gsy0);
dGfdGs = dGfdF*sign(Gs);
dGfdGl = -dGfdF*H*sign(Gs);

MM = [ %+E*GDGl/BGs 
 1                E*sign(Gs) 
 -GDt*Gg*dGfdGs   1 - GDt*Gg*dGfdGl 
];
rr = [ 
 E*GDGe - GDGs - E*GDGl*sign(Gs) 
 GDt*Gg*Gf - GDGl 
];

while ((lnrm > lccr) & (lit < lmit))
  aaa  = inv(MM)*rr;
  GdGs = aaa(1);  
  GdGl = aaa(2);

  GDGs = GDGs + GdGs; 
  GDGl = GDGl + GdGl;

  Gs     = GsB + GDGs;
  Gll    = GllB + GDGl;
  BGs    = abs(Gs);
  GDGevp = GDGl*(Gs/BGs);
  Gevp   = GevpB + GDGevp;
  BGevp  = BGevpB + abs(GDGevp);

  [Gsy Gss HH KK] = ...
  hardening(Gevp,BGevp,hm,'',E,Gsy0,0,hp1,hp2,hp3,hp4,hp5);

  F   = BGs - Gsy;

  Gff = (F/Gsy0);
  Gff = 1/2*(Gff + abs(Gff));
  Gf  = Gff^N; 
  dGfdF = N*(F/Gsy0)^(N-1)*(1/Gsy0);
  dGfdGl = -dGfdF*HH*sign(Gs);
  dGfdGs = dGfdF*sign(Gs);

  MM = [ %+E*GDGl/BGs  
   1                E*sign(Gs) 
   -GDt*Gg*dGfdGs   1 - GDt*Gg*dGfdGl
  ];
  rr = [ 
   E*GDGe - GDGs - E*GDGl*sign(Gs) 
   GDt*Gg*Gf - GDGl 
  ];

  lnrm = sqrt(rr'*rr);    

  lit = lit+1;
end; % while

C1 = E*(1-Gg*GDt*dGfdGl) / ...
    ( (1-Gg*GDt*dGfdGl) + E*sign(Gs)*Gg*GDt*dGfdGs  + ...
       E*GDGl*(1/abs(Gs))*(1-Gg*GDt*dGfdGl) );
C2 = (Gs-GsB)/(Ge-GeB);

%----------------------------------------------------------------------
elseif pr=='ex'
%----------------------------------------------------------------------

Gff = (F/Gsy0);
Gff = 1/2*(Gff + abs(Gff));
Gf  = Gff^N; 

MM = [
 1  E*sign(GsB)
 0  1 
];
rr = [
 GsB + E*GDGe + E*GllB*sign(GsB)
 GllB + Gg*Gf*GDt*sign(GsB)
];

aaa = inv(MM)*rr;
Gs  = aaa(1);
Gll = aaa(2);

BGs    = abs(Gs);
GDGevp = (Gll-GllB)*(Gs/BGs);
Gevp   = GevpB + GDGevp;
BGevp  = BGevpB + abs(GDGevp);

[Gsy Gss HH KK] = ...
hardening(Gevp,BGevp,hm,'',E,Gsy0,0,hp1,hp2,hp3,hp4,hp5);

F = BGs - Gsy;

C1 = E;
C2 = (Gs-GsB)/(Ge-GeB);

%----------------------------------------------------------------------
end; % pr
%----------------------------------------------------------------------

%----------------------------------------------------------------------
end; % F
%----------------------------------------------------------------------

Gee = Ge - Gevp;

C = C1;
C = C*dGedGl;

CL  = A/l0 * C;

%**********************************************************************
