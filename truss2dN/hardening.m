%**********************************************************************

function [Gsv Gss HH KK] = hardening(Gep,Gepe,ihm,khm,E,Gsv0,K,p1,p2,p3,p4,p5);

Gev0 = Gsv0/E;

if     ihm=='li', H = p1;                               % linear
       Gsv = Gsv0 + H*Gepe; 
       HH  = H;                    
elseif ihm=='lu', n = p1;                               % Ludwik
       Gsv = Gsv0 + Gsv0*(Gepe/Gev0)^n;
       HH  = n*(E)*(Gepe/Gev0)^(n-1); 
elseif ihm=='ml', m = p1; n = p2;                       % modified Ludwik
       Gsv = Gsv0*(1 + m*Gepe^n);  
       HH  = Gsv0*n*m*Gepe^(n-1);          
elseif ihm=='sw', m = p1; n = p2;                       % Swift
       Gsv = (Gsv0/m^n)*(m + Gepe)^n; 
       HH  = (Gsv0/m^n)*n*(m + Gepe)^(n-1);   
elseif ihm=='pr',                                       % Prager
       Gsv = Gsv0 + Gsv0*tanh(Gepe/Gev0);  
       HH  = (1/Gev0)*(sech(Gepe/Gev0))^2; 
elseif ihm=='b1', m = p1;                               % Betten1
       Gsv = Gsv0 + Gsv0*(tanh((Gepe/Gev0)^m))^(1/m); 
       HH  = E*(Gepe/Gev0 )^(m-1) * ...  
             (tanh((Gepe/Gev0)^m))^(1/m-1) * ...
             (sech((Gepe/Gev0)^m))^2;     
elseif ihm=='b2', m = p1;                               % Betten2
       Gsv = Gsv0 + (E*Gepe)*(1 + (Gepe/Gev0)^m)^(-1/m);
       HH  = E*(1 + (Gepe/Gev0)^m)^(-1/m) - ...
             (1/Gev0)*(E*Gepe)*(Gepe/Gev0)^(m-1) * ...
             (1 + (Gepe/Gev0)^m)^(-1/m-1); 
elseif ihm=='vc', m = p1; n = p2;                       % Voce
       Gsv = (Gsv0/(1-n))*(1 - n*exp(-m*Gepe)); 
       HH  = (Gsv0/(1-n))*n*m*exp(-m*Gepe) ;
elseif ihm=='ex', Ga = p1; Gbb = p2;                    % exponential 
       Gsv = Gsv0 + Ga*(Gepe)^Gbb;         
       HH  = Ga*Gbb*(Gepe)^(Gbb-1); 
elseif ihm=='so', H = p1; a = p2; b = p3; c = p4; d = p5; % softening
       Gsv = Gsv0 + H*Gepe + a*Gepe^2 + b*Gepe^3 + c*Gepe^4 + d*Gepe^7;
       HH  = H + 2*a*Gepe + 3*b*Gepe^2 + 4*c*Gepe^3 + 7*d*Gepe^6;
elseif ihm=='hm', a = p1; b = p2; c = p3;               % tanh
       Gsv = Gsv0 + Gsv0*a*(tanh(b*Gepe))^(c);
       HH  = Gsv0*a*c*(tanh(b*Gepe))^(c-1)*b*(1-(tanh(b*Gepe))^2);
elseif ihm=='qu', a = p1; b = p2;                       % quadratic
       Gsv = Gsv0 + a*Gepe - b*Gepe^2;
       HH  = a - 2*b*Gepe;
elseif ihm=='su', Gsu = p1; ee = p2;                    % exp with Gsu
       Gsv = Gsv0 + (Gsu)*(1 - exp(-ee*Gepe));
       HH  = (Gsu - Gsv0)*ee*exp(-ee*Gepe);
end;

Gss = K*Gep;
KK  = K;

%**********************************************************************

