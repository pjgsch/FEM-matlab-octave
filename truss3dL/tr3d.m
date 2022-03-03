%**********************************************************************
% tr3d : 3-dimensional truss element
%======================================================================
% Input is checked; non-specified variables are given a default value.
% Data are stored in a database and variables are initialized.
%======================================================================
tr3dchkinp;                                              % tr3dchkinp.m
fbiblcase;                                                % fbiblcase.m
[Trm] = fbibtransbc(tr,ndof,nndof);                     % fbibtransbc.m
[elda0,eldaB,eldaC,mcl4] = tr3dinidat(ne,elgr,elda,neip,ts,lok,crd0,mm); 
                                                         % tr3dinidat.m
tr2dinizer;                                              % tr2dinizer.m

nc   = size(pp,1);                    % number of kinematic constraints
next = nc - 6;
nint = ne + nc - 3*nnod;

save([matf num2str(0)]);
crdB = crd0; crd = crd0;
%======================================================================
% Incremental calculation 
% ic   = increment counter
% ti   = total time
% it   = iteration step counter
% slow = if 1 then cutbacks is done for nonconvergence
% nic  = number of increments
%======================================================================
ic = 1; ti = 0; it = 0; slow = 1;

while ic<=nic 
%----------------------------------------------------------------------
fbibcutback;                                            % fbibcutback.m
ti = ti + ts; it = 0; loadincr;                            % loadincr.m
pe = peC./slow; 
if ic>1, fe = feC; end;
rs = fe - fi;
Dp = zeros(ndof,1); Ip = zeros(ndof,1); IpT = zeros(ndof,1);
%======================================================================
% System matrix is assembled from element matrices
% System matrix is transformed for local nodal coord.sys.
% nl = 1 -> stiffness matrix is recalculated at increment start
%======================================================================
if (ic==1 | nl==1)
%----------------------------------------------------------------------
sm1=zeros(ndof); sm2=zeros(ndof); AA = zeros(ndof,ne);
mcl4=0; mcl42=0; mcl9=0;

for e=1:ne
  ec = crd(lok(e,3:nenod+2),:); 
  [ML,MN,V,en,eldaC] = tr3dgeom(e,ec,eldaC);               % tr3dgeom.m
  tr2dmat;                                                  % tr2dmat.m

  em1 = CL * ML ;                            % element stiffness matrix
  em2 = CN * MN ;                            % element stiffness matrix
  ef = (CI-CV) * V;                      % element internal load column
  ea = [ en -en ];

  sm1(lokvg(e,:),lokvg(e,:)) = sm1(lokvg(e,:),lokvg(e,:)) + em1;
  sm2(lokvg(e,:),lokvg(e,:)) = sm2(lokvg(e,:),lokvg(e,:)) + em2;
  fi(lokvg(e,:)) = fi(lokvg(e,:)) + ef;
  AA(lokvg(e,:),e) = ea';
end;

sm = sm1+sm2; sm01 = sm1; sm02 = sm2; 
sm = Trm'*sm *Trm; if ic==1, sm00=sm; end; sm0=sm;
AAp = AA(pu,:);
rsm1 = rank(sm1);
rsm2 = rank(sm2);
rsm  = rank(sm);
rs = fe - fi;
%----------------------------------------------------------------------
end;

%======================================================================
% Iterative calculation
% nrm  = convergence norm
% ccr  = convergence limit
% mit  = maximum number of iterations allowed
% sm0  = begin-increment stiffness matrix (for modified Newton)
%======================================================================
nrm = 1000; it = 1; sm0 = sm; 

while (nrm>ccr) & (it<=mit)
%----------------------------------------------------------------------
%======================================================================
% Links and boundary conditions are taken into account
% Unknown nodal point values are solved
% Prescribed nodal values are inserted in the solution vector
% npl  = number of links
% Dp   = iterative displacements
% Ip   = Incremental displacements
% Tp   = Total displacements
%======================================================================
%sm = sm00;                 % only used to test modified Newton-Raphson

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
sm1=zeros(ndof); sm2=zeros(ndof); fi=zeros(ndof,1); 
mcl4=0; mcl42=0; mcl9=0;
nslack = 0;

for e=1:ne
  ec = crd(lok(e,3:nenod+2),:);             % element nodal coordinates
  [ML,MN,V,en,eldaC] = tr3dgeom(e,ec,eldaC);               % tr3dgeom.m
  tr2dmat;                                                  % tr2dmat.m

  em1 = CL * ML ;                            % element stiffness matrix
  em2 = CN * MN ;                            % element stiffness matrix
  ef = (CI-CV) * V;                      % element internal load column

  sm1(lokvg(e,:),lokvg(e,:)) = sm1(lokvg(e,:),lokvg(e,:)) + em1;
  sm2(lokvg(e,:),lokvg(e,:)) = sm2(lokvg(e,:),lokvg(e,:)) + em2;
  fi(lokvg(e,:)) = fi(lokvg(e,:)) + ef;
end;

sm = sm1+sm2; sm01 = sm1; sm02 = sm2; 
sm=Trm'*sm*Trm; fi=Trm'*fi;
%======================================================================
% Calculate residual force and convergence norm
%======================================================================
rs = fe - fi;
nrm = fbibcnvnrm(cnm,pu,ppc,prs,Dp,Ip,rs,fi);            % fbibcnvnrm.m

it = it + 1;                     % increment the iteration step counter

%fbibwr2scr;                  % Write info to the screen : fbibwr2scr.m
%----------------------------------------------------------------------
end; %it
%======================================================================
% Transformation nodal forces from local to global nodal coord.sys.
%======================================================================
fiT = fi; feT = fe; rsT = rs;
fiT = Trm * fi; feT = Trm * fe; rsT = Trm * rs;
%======================================================================
% Column data are stored in matrices
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



