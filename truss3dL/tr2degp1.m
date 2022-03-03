%**********************************************************************
%  elda = [ ety mnr A0 gf2 gf3  emo nuu T Gh0 H h Dinf AA0 GDH Gmm Gt0 ];
%----------------------------------------------------------------------
%  mnr  = material number ->
%  mcl  = material class : first digit 
%  mty  = material type  : second digit
%----------------------------------------------------------------------
%  mcl  = 6  ->  viscoelastic material model (Leonov/EGP)
%----------------------------------------------------------------------
%  emo  = Young's modulus
%  nuu  = Poisson's ratio
%  T    = absolute temperature
%  Gh0  = material parameter
%  H    = material parameter
%  h    = material parameter
%  Dinf = material parameter
%  AA0  = material paramater
%  GDH  = material parameter
%  Gmm  = material parameter
%  Gt0  = material parameter
%**********************************************************************

R = 8.314;

T    = elda(g,8);
Gh0  = elda(g,9);
H    = elda(g,10);
h    = elda(g,11);
Dinf = elda(g,12);
AA0  = elda(g,13);
GDH  = elda(g,14);
Gmm  = elda(g,15);
Gt0  = elda(g,16);


%if     ma=='pt'
%  E  = 2400;         Gn = 0.35;     H  = 15;      h  = 13;     Dinf = 11;
%  A0 = 3.8568e-27;   GDH = 2.617e5; Gm = 0.0625;  Gt0 = 0.927; 
%elseif ma=='pc'
%  E  = 2305;         Gn = 0.37;     H  = 29;      h  = 270;    Dinf = 19;
%  A0 = 9.7573e-27;   GDH = 2.9e5;   Gm = 0.06984; Gt0 = 0.72;  
% %E  =900;
% %A0 = 1.28e-25;     GDH = 2.9e5;   Gm = 9.7e-2;  Gt0 = 0.72;
%elseif ma=='pp'
%  E  = 1092;         Gn = 0.4;      H  = 3;       h  = 0;      Dinf = 1;
%  A0 = 2.031926e-29; GDH = 2.2e5;   Gm = 0.23;    Gt0 = 1.0; 
%elseif ma=='ps'
%  E  = 3300;         Gn = 0.37;     H  = 13;      h  = 100;    Dinf = 14;
%  A0 = 4.261903e-34; GDH = 2.6e5;   Gm = 0.294;   Gt0 = 2.1;  
%end;

% some model parameters are calculated from input

K  = E/(3*(1-2*Gn));     % bulk modulus
G  = E/(2*(1+Gn));       % shear modulus
Gw = H/(2*(1+Gn));       % hardening shear modulus 

if     dim==1, KK = 0; GG = E; GW = H;
elseif dim==3, KK = K; GG = 2/3*G*(1+Gn); GW = 2/3*H*(1+Gn); end;

GeB     = eldaB(e,21); GeeB = eldaB(e,22); GevB = eldaB(e,23); 
BGevB   = eldaB(e,24); DB   = eldaB(e,25); GhB  = eldaB(e,26);
sigDGeB = eldaB(e,27);
GsB     = GG*GeeB + GW*GeB;

Gh = GhB; Ght = Gh; 
Gee = GeeB; Geet = Gee; 
D = DB; Dt = D;
BGev = BGevB; GDBGev = 0;

Ge = Geln; Ged = -Gn*Ge; Gm = exp(Ged); Gl = exp(Ge); dGedGl = 1/Gl;
%Ge = Gel; Ged = -Gn*Ge; Gm = Ged+1;; Gl = Ge + 1; dGedGl = 1;
A  = Gm*Gm*A0;

sigDGe = sign(Ge - GeB);
%if sigDGe*sigDGeB < 0, Gh = Gh0; end;
%C = E;

%----------------------------------------------------------------------
if pr=='im'
%----------------------------------------------------------------------

lccr = 1e-8; lnrm = 100; lmit = 10; lit = 1;

while ((lnrm > lccr) & (lit < lmit))

  Gz = 1/(Gh);

  MM = [
   1 + GG*GDt*Gz  GDt*GG*Gz*Gee
   0              1 + h/Dinf*GDBGev
  ];
  rr = [
   -Gee + GeeB + Ge - GeB - GDt*GG*Gz*Gee
   -D + DB + h*GDBGev - (D*h)/Dinf*GDBGev
  ];

  aaa = inv(MM)*rr;
  GdGee = aaa(1);
  GdD   = aaa(2);
  
  Gee = Gee + GdGee;
  D = D + GdD;

  J      = exp((1-2*Gn)*Gee);     % logarithmic strain
%  J      = (1-2*Gn)*Gee + 1;    % linear strain

  Gsh    = KK*(J - 1);    
  Gsd    = GG*Gee; 
  Gsw    = GW*Ge;
  Gs     = Gsh + Gsd + Gsw;
  BGs    = abs(Gsd+Gsh);
  Gev    = Ge - Gee;
  BGev   = BGevB + abs(Gev-GevB);
  GDBGev = BGev - BGevB;


%  ppp    = -(BGs)/3;
  ppp    = -(Gsd+Gsh)/3;
  AA     = AA0 * exp( GDH/(R*T) + Gmm*ppp/Gt0 - D );
  xx     = BGs/(sqrt(3)*Gt0);
  fff    = sinh(xx);

  if BGs>0, Gh = AA * BGs/(sqrt(3) * fff);
  else,     Gh = Gh0; 
  end;

%  lnrm   = max( abs((Gee-Geet) ) , (D-Dt) );
  lnrm   = max( abs((Gee-Geet)/Gee ) );

  Geet   = Gee; 
  Dt     = D;
  Ght    = Gh;

  lit    = lit + 1;

end;

C1 = ( GG + GW*(1 + GDt*GG*Gz) ) / ( 1+GDt*GG*Gz );
C2 = (Gs-GsB)/(Ge-GeB);

%----------------------------------------------------------------------
elseif pr=='ex'
%----------------------------------------------------------------------

Gz = 1/(2*Gh);

Gee = Ge - GeB + (1 - GDt*E*Gz)*GeeB;
%D = DB + (1 - DB/Dinf)*h*GDBGev;

J      = exp((1-2*Gn)*Gee);     % logarithmic strain
%J      = (1-2*Gn)*Gee + 1;    % linear strain

Gsh    = KK*(J - 1);    
Gsd    = GG*Gee; 
Gsw    = GW*Ge;
Gs     = Gsh + Gsd + Gsw;
BGs    = abs(Gsd+Gsh);
Gev    = Ge - Gee;
BGev   = BGevB + abs(Gev-GevB);
GDBGev = BGev - BGevB;

D = DB + (1 - DB/Dinf)*h*GDBGev;


%ppp    = -(BGs)/3;
ppp    = -(Gsd+Gsh)/3;
AA     = AA0 * exp( GDH/(R*T) + Gmm*ppp/Gt0 - D );
xx     = BGs/(sqrt(3)*Gt0);
fff    = sinh(xx);

if BGs>0, Gh = AA * BGs/(sqrt(3) * fff);
else,     Gh = Gh0; 
end;

C1 = ( GG + GW*(1 + GDt*GG*Gz) ) / ( 1+GDt*GG*Gz );
C2 = (Gs-GsB)/(Ge-GeB);

%----------------------------------------------------------------------
end; % pr
%----------------------------------------------------------------------

C = C1;
C = C*dGedGl;

CL  = A/l0 * C;

%**********************************************************************
