%**********************************************************************
%  elda = [ ety mnr A0 gf2 gf3  emo nuu p1 p2 p3 p4 p5 p6 p7 p8 ];
%----------------------------------------------------------------------
%  mnr  = material number ->
%  mcl  = material class : first digit 
%  mty  = material type  : second digit
%----------------------------------------------------------------------
%  mcl  = 7  ->  elastoviscous material model (creep)
%  mty  = #  ->  creep model : see source below
%----------------------------------------------------------------------
%  emo  = Young's modulus
%  nuu  = Poisson's ratio
%  p1-8 = material parameters
%**********************************************************************

R = 8.314; 

if     mty==1			   % Norton
   AA  = elda(g,8);
   ee  = elda(g,9);
elseif mty==2			   % Dorn
   ma  = 'do';
   BB  = elda(g,8);
   Gb  = elda(g,9);
elseif mty==3			   % Andrade
   ma  = 'an';
   Gb  = elda(g,8);
   k   = elda(g,9);
elseif mty==4		           % Soderberg 
   ma  = 'sb';
   BB  = elda(g,8);
   Gs0 = elda(g,9);
elseif mty==8                      % adapted Soderberg 
   BB  = elda(g,8);
   Gs0 = elda(g,9);
   Gx  = elda(g,10);
elseif mty==5			   % Lifszic
   ma  = 'lc';
   GDH = elda(g,8);
   TK  = elda(g,9);
elseif mty==6			   % Wiese
   ma  = 'wi';
   T   = elda(g,8);
   CT  = elda(g,9); 
   E   = E - CT*T;
   A1  = elda(g,10);
   A2  = elda(g,11);
   e1  = elda(g,12);
   e2  = elda(g,13);
   m1  = elda(g,14);
   m2  = elda(g,15);
end;

GeB = eldaB(e,21); GeeB = eldaB(e,22); GevB = eldaB(e,23);
GsB = eldaB(e,24);

Ge   = Gel; dGedGl = 1;
%Ge   = Geln; dGedGl = 1/Gl;
Ged  = -Gn*Ge; 
Gm   = Ged+1;  
%Gm   = exp(Ged);  
A    = Gm*Gm*A0;

%----------------------------------------------------------------------
if pr=='im'
%----------------------------------------------------------------------

Gs  = GsB;
BGs = abs(Gs);
Gse = GsB + E*(Ge - GeB);

lccr = 1e-5; lnrm = 1000; lmit = 10; lit = 1;

while ((lnrm > lccr) & (lit < lmit))

  if	 mty==1 		       % Norton
    f	 = AA*Gs^ee;
    dfds = ee*AA*Gs^(ee-1);
  elseif mty==2 		       % Dorn
    f	 = BB*exp(Gb*Gs);
    dfds = BB*Gb*exp(Gb*Gs);
  elseif mty==3 		       % Andrade
    f	 = (1/3)* Gb * ti^(-2/3) + k ;
    dfds = 0;
  elseif mty==4 		       % Soderberg
    f	 = BB*(exp(Gs/Gs0)-1);     
    dfds = (BB/Gs0)*(exp(Gs/Gs0));
  elseif mty==8                        % adapted Soderberg 
    f    = BB*(exp(Gs^Gx/Gs0)-1);   
    dfds = (Gx*BB*Gs^(Gx-1)/Gs0)*(exp(Gs^Gx/Gs0));
  elseif mty==6 		       % Wiese
    f	 = A1*exp(e1/T)*Gs^m1 + A2*exp(e2/T)*Gs^m2; 
    dfds = m1*A1*exp(e1/T)*Gs^(m1-1) + m2*A2*exp(e2/T)*Gs^(m2-1);
  elseif mty==7 		       % tp
    Gaa  = C1*(sinh(Gbb*Gs))^n1 * exp(-Q1/R*T);
    AA   = C2*Gs^n2;
    BB   = C3*Gs^n3*exp(-Q2/R*T);
    dAAdGs = C2*n2*Gs^(n2-1);
    dBBdGs = C3*n3*Gs^(n3-1)*exp(-Q2/R*T);
    f	 = AA*Gaa*exp(-Gaa*ti) + BB*Gaa*exp(Gaa*ti);
    dfds = dAAdGs*Gaa*exp(-Gaa*ti) + dBBdGs*Gaa*exp(Gaa*ti);
  end;
 
  K = 1 + GDt*E*dfds;
  r = Gse - (Gs + GDt*E*f);

  GdGs = r/K;
  Gs = Gs + GdGs; 

  BGs = abs(Gs);

  lnrm = abs(GdGs);
  lit = lit + 1;
end; % while

Gee = Gs/E;
Gev = GevB + GDt*f;

%C = (Gs-GsB)/(Ge-GeB);
C = E/(1 + GDt*E*dfds);

%----------------------------------------------------------------------
elseif pr=='ex'
%----------------------------------------------------------------------

Gs = GsB;
Gev = GevB;

if     ma=='nl', Gev = Gev + GDt*AA*Gs^ee;                                      % Norton
elseif ma=='nn', Gev = Gev + GDt*AA*Gs^ee;                                      % Norton
elseif ma=='do', Gev = Gev + GDt*BB*exp(Gb*Gs);                                 % Dorn
%elseif ma=='an', Gev = Gb*(ti-ts)^(1/3) + k*(ti-ts);                           % Andrade
%elseif ma=='an', Gev = Gb*(ti)^(1/3) + k*(ti);                                 % Andrade
elseif ma=='an', Gev = Gev + GDt*( (1/3)*Gb*(ti)^(-2/3) + k );                  % Andrade
elseif ma=='ae', Gev = Gev + GDt*(0.01)/(1)*exp((ti-ts)/1);
elseif ma=='lg', Gev = Gev + GDt*(0.01)*(200)/(1 + 200*(ti-ts));
elseif ma=='wi', Gev = Gev + GDt*(A1*exp(e1/T)*Gs^m1 + A2*exp(e2/T)*Gs^m2);     % Wiese
elseif ma=='tp'                                                                 % theta-projection
                 AA = C2*(Gs^n2); BB = C3*(Gs^n3)*exp(-Q2/(R*T)); 
                 Gaa = exp(-Q1/(R*T))*(C1)*(sinh(Gbb*Gs))^n1;
                 Gev = Gev + GDt*( AA*Gaa*exp(-Gaa*ti) + BB*Gaa*exp(Gaa*ti) );
%                 Gev = AA*(1-exp(-Gaa*ti)) + BB*(exp(Gaa*ti)-1); 
elseif ma=='lc', Gev = Gev + GDt*(Gs/TK)*exp(-GDH/(R*TK));                      % Lifszic
elseif ma=='sb', Gev = Gev + GDt*BB*(exp(Gs/Gs0)-1); 
end;

Gee = Ge - Gev;
%Gs = GsB + E*(Ge - GeB) - E*(Gev - GevB);
Gs = E * Gee;

%C = (Gs-GsB)/(Ge-GeB);
C = E;

%----------------------------------------------------------------------
end; % pr
%----------------------------------------------------------------------

CL = A/l0 * C;

%**********************************************************************
