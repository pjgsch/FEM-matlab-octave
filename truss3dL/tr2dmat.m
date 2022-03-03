%**********************************************************************
% tr2Dmat 
%======================================================================

g = elgr(e);                                     % element group
CV = 0;

ety  = elda(g,1);
Gs0  = elda(g,4);
GDT  = elda(g,5);

mcl  = elda0(e,9)  ;  mty  = elda0(e,10);
s0   = elda0(e,1)  ;  c0   = elda0(e,2);  
l0   = elda0(e,3)  ;  A0   = elda0(e,4);  
E    = elda0(e,8)  ;

lt   = eldaC(e,3)  ;  CL   = eldaC(e,5); 
A    = eldaC(e,4)  ;  EB   = eldaC(e,28);

%if it<-1
if it<1
  CL  = eldaB(e,5); 
  if mcl==3,  CL = A/l0 * E; end;
  if mcl==5,  CL = A/l0 * E; end;
  if mcl==6,  CL = A/l0 * E; end;
  if mcl==9,  CL = A/l0 * EB; end;
%  if mcl==10, CL = elda0(e,38); end;
  CN = eldaB(e,31); 
  CI = 0;
  CV = 0;
  if ic==1, 
    Gs = Gs0 + E*(-(1e-6)*GDT);
    CN = A0/l0 * Gs;
    CI = A0 * Gs;   
  end;
  
else 

l    = eldaC(e,3);                              % element length
Gl   = l/l0;                                    % stretch ratio
GD   = l - l0;                                  % elongation

Gel  = Gl-1;                                    % linear strain
Geln = log(Gl);                                 % logarithmic strain
Gegl = 1/2*(Gl*Gl-1);                           % Green-Lagrange strain

A0   = elda(g,3);                               % initial cross.area
E    = elda(g,6);                               % Young's modulus
Gn   = elda(g,7);                               % Poisson's ratio

%======================================================================
%  Calculation of stress and stiffness for various material models

if     mcl==1,                                             % tr2delas.m
  tr2delas;                                                
elseif mcl==2,                                             % tr2delam.m
  tr2delam;                                                
elseif mcl==3,                                             % tr2delpl.m
  tr2delpl;                                                
  eldaC(e,21:29) = [Ge Gep Gepe Gs Gsv Gss Gb Gll C]; 
elseif mcl==4,                                             % tr2dviel.m
  tr2dviel;                                                
elseif mcl==5,                                             % tr2dperz.m
  tr2dperz;                                                
  eldaC(e,21:28) = [Ge Gevp BGevp Gs Gsy Gee Gll C];
elseif mcl==6                                              % tr2dleon.m 
  tr2degp1;                                               
  eldaC(e,21:28) = [Ge Gee Gev BGev D Gh sigDGe C];
elseif mcl==7,                                             % tr2delvi.m
  tr2delvi;                                                
  eldaC(e,21:25) = [Ge Gee Gev Gs C]; 
elseif mcl==9,                                             % tr2dniti.m
  tr2dniti;                                                
  eldaC(e,21:30) = [Ge xi mf Gs 0 Gbx Gbm EB TT 0]; 
elseif mcl==10,                                            % tr2dcohz.m
  tr2dcohz;                      
end;

%======================================================================

P = Gm*Gm*Gs/Gl;                           % 2nd Piola-Kirchhoff stress
N = Gs*A;                                  % axial force

CN = A/l * Gs;                             % stiffness factor
CI = A * Gs;                               % stiffness factor

if (ety==1 & Gs<0), 
  nslack = nslack+1;
  CL=0; CN=0; CI=0; Gs=0; P=0; N=0; 
end;
%if (ety==1 & Gs<0), CN=0; CI=0; end;

%======================================================================
%  Data are stored in eldaC : array with current values
%----------------------------------------------------------------------

eldaC(e,4:7)   = [A  CL Ge  Gs]; 
eldaC(e,11:18) = [Gl Gm Gel Geln Gegl Gs P N];
eldaC(e,31:33) = [CN CI CV];

%======================================================================
end; %if it

%**********************************************************************
