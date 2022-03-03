 
  gg = 1;
  E1a = elda5(gg,1);  E1b = elda5(gg,5);
  E2a = elda5(gg,2);  E2b = elda5(gg,6);
  E3a = elda5(gg,3);  E3b = elda5(gg,7);
  E4a = elda5(gg,4);  E4b = elda5(gg,8);
  P1a = elda5(gg,9);  P1b = elda5(gg,13);
  P2a = elda5(gg,10); P2b = elda5(gg,14);
  P3a = elda5(gg,11); P3b = elda5(gg,15);
  P4a = elda5(gg,12); P4b = elda5(gg,16);





  EEB  = eldaB(e,15) ; PPB = eldaB(e,17) ; TTB = eldaB(e,29) ;
  xiB  = eldaB(e,22) ; mfB = eldaB(e,23) ;
  
  xi = xiB; mf = mfB;

  TT   = etC(e);

  Ge   = Gegl;         EE = Ge;
  Ged  = -Gn*Ge; 
  Gm   = Ged+1;  
  A    = Gm*Gm*A0;

  dEE = EE - EEB;
  dTT = TT - TTB;

  EE1 = E1a*TT + E1b; EE2 = E2a*TT + E2b; 
  EE3 = E3a*TT + E3b; EE4 = E4a*TT + E4b; 
  PP1 = P1a*TT + P1b; PP2 = P2a*TT + P2b; 
  PP3 = P3a*TT + P3b; PP4 = P4a*TT + P4b; 

  EAF = EE1; EMS = EE1+EE2; EMF = EE1+EE2+EE3+EE4; EAS = EE1+EE3;
  PAF = PP1; PMS = PP1+PP2; PMF = PP1+PP2+PP3+PP4; PAS = PP1+PP3;

  E0 = PP1/EE1;
  if E0<0,
    E0 = 0.01 * (PMS-PAF)/(EMS-EAF);
    if EEB<EAF, xiB = (-PAF)/(PMS-PAF); end;
  end;
  if abs(E0)<1, E0 = 0.1*PMS/EMS; end;
%  E1 = (PP2+PP4)/(EE2+EE4);
  E1 = (PMF-PAS)/(EMF-EAS);

  dPP = 0; Gb = 1; Gbx = 1; Gbm = 1;

  if EEB<EAF % PPB<PP1 %
    if dEE~=0, Gb = (EAF-EEB)/(EE-EEB); else, Gb=1; end;
    if (Gb>=1 | Gb<0)
      GPe = E0; GPt = 0;
      dPP = dPP + GPe*dEE + GPt*dTT;
      xi = xiB; mf = mfB;
    elseif Gb<1, 
      GPe = E0; GPt = 0;
      dPP = dPP + Gb*GPe*dEE; dEE = (1-Gb)*dEE; dTT = (1-Gb)*dTT;
    end;
  elseif EEB>EMF % PPB>(PP1+PP2+PP3+PP4) %
    if dEE~=0, Gb = (EEB-EMF)/(EEB-EE); else, Gb=1; end;
    if (Gb>=1 | Gb<0)
      GPe = E1; GPt = 0;
      dPP = dPP + GPe*dEE + GPt*dTT;
      xi = xiB; mf = mfB;
    elseif Gb<1
      GPe = E1; GPt = 0;
      dPP = dPP + Gb*GPe*dEE; dEE = (1-Gb)*dEE; dTT = (1-Gb)*dTT;
    end;
  else 
    Gb = 0;
  end;

%fprintf('Gb = %9.4g dEE = %9.4g dPP = %9.4g PP = %9.4g \n',Gb, dEE, dPP, PPB+dPP)

if (Gb>=0 & Gb<1)
  EEx = EE2 + EE4*mfB;
  EEt = E1a + E2a*xiB + E3a*mfB + E4a*xiB*mfB;
  xi  = xiB + (1/EEx)*dEE - (EEt/EEx)*dTT;

  if xi>1, Gbx = (1-xiB)/(xi-xiB); xi = 1; end;
  if xi<0, Gbx = xiB/(xiB - xi);   xi = 0; end;

  dEE1 = Gbx * dEE; dEE2 = dEE - dEE1;
  dTT1 = Gbx * dTT; dTT2 = dTT - dTT1;

  EEt = E1a + E2a*xi + E3a*mfB + E4a*xi*mfB;
  PPx = PP2 + PP4*mfB;
  PPt = P1a + P2a*xi + P3a*mfB + P4a*xi*mfB;

  GPe = PPx/EEx;
  GPt = PPt - PPx*(EEt/EEx);

  dPP = dPP + GPe*dEE1 + GPt*dTT1;

%fprintf('Gbx = %9.4g dEE1 = %9.4g dPP = %9.4g PP = %9.4g \n',Gbx, dEE1,dPP, PPB+dPP)

end;

if Gbx<1
  EEm = EE3 + EE4*xi;
  mf  = mfB + (1/EEm)*dEE2 - (EEt/EEm)*dTT2;

  if mf>1, Gbm = (1-mfB)/(mf-mfB); mf = 1; end;
  if mf<0, Gbm = mfB/(mfB - mf);   mf = 0; end;

  dEE21 = Gbm * dEE2; dEE22 = dEE2 - dEE21;
  dTT21 = Gbm * dTT2; dTT22 = dTT2 - dTT21;

  EEt = E1a + E2a*xi + E3a*mf + E4a*xi*mf;
  PPm = PP3 + PP4*xi;
  PPt = P1a + P2a*xi + P3a*mf + P4a*xi*mf;

  GPe = PPm/EEm;
  GPt = PPt - PPm*(EEt/EEm);

  dPP = dPP + GPe*dEE21 + GPt*dTT21;

%fprintf('Gbm = %9.4g dEE21 = %9.4g dPP = %9.4g PP = %9.4g \n',Gbm, dEE21,dPP, PPB+dPP)

end;

if (Gbm)<1
  if (mf==1 & xi==1), GPe = E1; GPt = 0; end;
  if (mf==0 & xi==0), GPe = E0; GPt = 0; end;
  
  dPP = dPP + GPe*dEE22 + GPt*dTT22;
end;

  PP = PPB + dPP;

  Gs = PP*(Gl/(Gm*Gm));
  C  = GPe*Gl*Gl/(Gm*Gm) + PP/(Gm*Gm);
  CV = 0;%GPt*A*dTT*Gl/(Gm*Gm);
  CL = A/l0 * C;

%fprintf('C = %9.4g CL = %9.4g \n',C,CL)

  if EE<EE1
    EB = E0;
  elseif EE>(EE1+EE2+EE3+EE4)
    EB = E1;
  else
    EB = PPx/EEx;
  end;

%**********************************************************************
