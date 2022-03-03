%**********************************************************************
% tr2d : 2-dimensional truss element
%======================================================================
tr2dchkinp;                                              % tr2dchkinp.m
fbiblcase;                                                % fbiblcase.m
[Trm] = fbibtransbc(tr,ndof,nndof);                     % fbibtransbc.m
[elda0,eldaB,eldaC,mcl4] = tr2dinidat(ne,elgr,elda,neip,ts,lok,crd0,mm); 
                                                         % tr2dinidat.m
tr2dinizer;                                              % tr2dinizer.m

save([matf num2str(0)]);
crdB = crd0; crd = crd0;
%======================================================================
% Incremental calculation 
%======================================================================
ic = 1; ti = 0; it = 0; slow = 1;

while ic<=nic 
%----------------------------------------------------------------------
fbibcutback;                                            % fbibcutback.m
ti = ti + ts; it = 0; loadincr;                            % loadincr.m
pe = peC./slow; fe = feC;  
rs = fe - fi;
Dp = zeros(ndof,1); Ip = zeros(ndof,1); IpT = zeros(ndof,1);
%======================================================================
% System matrix is assembled from element matrices
% System matrix is transformed for local nodal coord.sys.
%======================================================================
if (ic==1 | nl==1)
%----------------------------------------------------------------------
sm=zeros(ndof); mcl4=0; mcl42=0; mcl9=0;

for e=1:ne
  ec = crd(lok(e,3:nenod+2),:);
  [ML,MN,V,eldaC] = tr2dgeom(e,ec,eldaC);                  % tr2dgeom.m
  tr2dmat;                                                  % tr2dmat.m

  em = CL * ML + CN * MN ;                   % element stiffness matrix
  ef = (CI-CV) * V;                      % element internal load column

  sm(lokvg(e,:),lokvg(e,:)) = sm(lokvg(e,:),lokvg(e,:)) + em;
end;

sm = Trm'*sm *Trm; if ic==1, sm00=sm; end; sm0=sm;
%----------------------------------------------------------------------
end;
%======================================================================
% Iterative calculation
%======================================================================
nrm = 1000; it = 1; sm0 = sm; 

while (nrm>ccr) & (it<=mit)
%----------------------------------------------------------------------
%======================================================================
% Links and boundary conditions are taken into account
% Unknown nodal point values are solved
% Prescribed nodal values are inserted in the solution vector
%======================================================================
%sm = sm00;                  % only used to test modified Newton-Raphson

if npl>0, rs = rs - sm(:,plc)*lif'; end;
[sm,rs] = fbibpartit(it,sm,rs,ndof,pa,ppc,plc,prc,pe,lim);% fbibpartit.m

sol = inv(sm)*rs; 

p = zeros(ndof,1); p(pu) = sol; 
if it==1, p(ppc) = pe(ppc); end;
if npl>0, p(plc) = lim*p(prc) + lif'; end;

Dp = p; Ip = Ip + Dp; Tp = Tp + Dp; 
%======================================================================
% Transformation dof's from local to global nodal coordinate systems
%======================================================================
DpT = Trm * Dp; IpT = IpT + DpT; TpT = TpT + DpT;
crd = crd0 + reshape(TpT,nndof,nnod)';
%======================================================================
% Calculate stresses and strains.
% Make system matrix and internal force vector for next step.
%======================================================================
sm=zeros(ndof); fi=zeros(ndof,1); mcl4=0; mcl42=0; mcl9=0;

for e=1:ne
  ec = crd(lok(e,3:nenod+2),:);             % element nodal coordinates
  [ML,MN,V,eldaC] = tr2dgeom(e,ec,eldaC);                  % tr2dgeom.m
  tr2dmat;                                                  % tr2dmat.m

  em = CL * ML + CN * MN ;                   % element stiffness matrix
  ef = (CI-CV) * V;                      % element internal load column

  sm(lokvg(e,:),lokvg(e,:)) = sm(lokvg(e,:),lokvg(e,:)) + em;
  fi(lokvg(e,:)) = fi(lokvg(e,:)) + ef;
end;

sm=Trm'*sm*Trm; fi=Trm'*fi;
%======================================================================
% Calculate residual force and convergence norm
%======================================================================
rs = fe - fi;
nrm = fbibcnvnrm(cnm,pu,ppc,prs,Dp,Ip,rs,fi);            % fbibcnvnrm.m

it = it + 1;                     % increment the iteration step counter

fbibwr2scr;                                              % fbibwr2scr.m
%----------------------------------------------------------------------
end; %it
%======================================================================
% Transformation nodal forces from local to global nodal coord.sys.
%======================================================================
fiT = fi; feT = fe; rsT = rs;
fiT = Trm * fi; feT = Trm * fe; rsT = Trm * rs;

%======================================================================
% Update and store values
%======================================================================
fbibcol2mat1;                                          % fbibcol2mat1.m
crdB = crd; feB = fe; eldaB = eldaC; HGsB = HGsC; 
savefile = [matf num2str(ic)]; savedata;                   % savedata.m

ic = ic + 1;                          % increment the increment counter
save([matf '00'],'ic');                           % save date to 'matf'

%----------------------------------------------------------------------
end; %ic

%**********************************************************************



