%**********************************************************************
% tr2dL : 2-dimensional linear truss element
%======================================================================
%----------------------------------------------------------------------
% Calculate some parameters from the input data.
%  nndof   :  number of nodal degrees of freedom 
%  nnod    :  number of nodes
%  ndof    :  number of system degrees of freedom
%  ne      :  number of elements
%  nenod   :  number of element nodes 
%  nedof   :  number of element degrees of freedom 
%  negr    :  number of element groups
%  lokvg   :  location of degrees of freedom of elements in structure
%----------------------------------------------------------------------

nndof = 2;
nnod  = size(crd0,1); 
ndof  = nnod * nndof;   
ne    = size(lok,1);
nenod = size(lok,2)-2;
nedof = nndof * nenod;
negr  = size(elda,1);   

lokvg(1:ne,:) = ... 
    [ nndof*(lok(1:ne,3)-1)+1 nndof*(lok(1:ne,3)-1)+2 ...
      nndof*(lok(1:ne,4)-1)+1 nndof*(lok(1:ne,4)-1)+2 ];

%----------------------------------------------------------------------
% Calculate transformation matrix 'Trm' for local dof's, if needed.
%----------------------------------------------------------------------

Trm = eye(ndof);
if exist('tr'), 
  ntr = size(tr,1); 
  for itr=1:ntr
    trp = round(tr(itr,1));     tra = tr(itr,2);
    trc = cos((pi/180)*tra);  trs = sin((pi/180)*tra);
    k1  = nndof*(trp-1)+1;    k2  = nndof*(trp-1)+2;
    trm = [trc -trs ; trs trc];
    Trm([k1 k2],[k1 k2]) = trm;
  end;
else, ntr = 0; tr = []; end;

%----------------------------------------------------------------------
% Initialization of databases 
%  elpa  : element parameters
%  elda0 : initiel values
%  eldaC : current values
%  ety : element type    ;  egr : element group  ;
%  mnr : material number ;  mcl : material class ;  mty : material type
%  l0  : initial element length
%  s0  : sine of axis angle
%  c0  : cosine of axis angle
%----------------------------------------------------------------------

for e=1:ne
  ety = lok(e,1); egr = lok(e,2);
  mnr  = elda(egr,2);	   A0	= elda(egr,3);      
  E    = elda(egr,6);	   Gn	= elda(egr,7);
  mcl  = floor(mnr/10);    mty  = rem(mnr,10);
  k1   = lok(e,3); k2 = lok(e,4);
  x10  = crd0(k1,1); y10 = crd0(k1,2); x20 = crd0(k2,1); y20 = crd0(k2,2);
  l0   = sqrt((x20-x10)*(x20-x10)+(y20-y10)*(y20-y10));
  s0   = (y20-y10)/l0;
  c0   = (x20-x10)/l0;

  elpa(e,:)  = [ety egr nenod nndof nedof];
  elda0(e,:) = [ s0 c0 l0 A0 0 0 Gn E mcl mty ];
  eldaC(e,:) = [ s0 c0 l0 A0 0 0 Gn E 0   0	];
end; % element loop 'e'

%----------------------------------------------------------------------
% Boundary conditions are reorganized.
% Additional arrays for later partitioning are made.
%  npdof :  number of prescribed degrees of freedom
%  npfor :  number of prescribed nodal forces
%  nudof :  number of unknown degrees of freedom 
%
%  Information for partitioning the system of equations associated
%  with prescribed boundary conditions is made available in the arrays
%  ppc, ppv, pfc  and  pfv.
%----------------------------------------------------------------------

if ~exist('pp'), pp = []; ppc = []; ppv = []; end;
if ~exist('pf'), pf = []; pfc = []; pfv = []; end;

npdof = size(pp,1);
npfor = size(pf,1);
nudof = ndof - npdof;

if npdof>0
  ppc = [nndof*(round(pp(:,1))-1)+round(pp(:,2))]; 
  ppv = pp(:,nndof+1);
end;
if npfor>0, 
  pfc = [nndof*(round(pf(:,1))-1)+round(pf(:,2))]; 
  pfv = pf(:,nndof+1);
end;

%  Information for partitioning the system of equations associated
%  with linked degrees of freedom is made available in the arrays
%  plc  and  prc.

if ~exist('pl'),  pl  = []; plc = []; end;
if ~exist('pr'),  pr  = []; prc = []; end;
if ~exist('lim'), lim = []; end;

npl = size(pl,1);
npr = size(pr,1);

if ~exist('lif'), lif = zeros(1,npl); end;

if npl>0
  plc = [nndof*(round(pl(:,1))-1)+round(pl(:,2))];
  prc = [nndof*(round(pr(:,1))-1)+round(pr(:,2))];
end;

%  Some extra arrays are made for later use.

pa = 1:ndof; pu = 1:ndof; prs = 1:ndof;
pu([ppc' plc']) = [];
prs([ppc' pfc' plc']) = [];

%  pe0   :  column with prescribed initial displacements
%  fe0   :  array with prescribed initial forces

pe0 = zeros(ndof,1); pe0(ppc(1:npdof)) = ppv(1:npdof);
fe0 = zeros(ndof,1); fe0(pfc(1:npfor)) = pfv(1:npfor);

%----------------------------------------------------------------------
% Initialization to zero
%  pe    :  column with nodal displacements
%  p     :  column with nodal displacements
%  fe    :  column with external (applied) nodal forces
%  fi    :  column with internal (resulting) nodal forces
%  #T    :  column with transformed components
%----------------------------------------------------------------------

pe  = zeros(ndof,1); p   = zeros(ndof,1); pT  = zeros(ndof,1);  
fe  = zeros(ndof,1); fi  = zeros(ndof,1); 
feT = zeros(ndof,1); fiT = zeros(ndof,1);  

%----------------------------------------------------------------------
% Loop over all elements to generate element stiffness matrix 'em'
% Assemble 'em' into structural stiffness matrix 'sm'
%  ec0  : initial coordinates of element nodes
%  ec   : current coordinates of element nodes
%----------------------------------------------------------------------
sm = zeros(ndof); 

for e=1:ne
  ety = elpa(e,1); egr = elpa(e,2); 
  nenod = elpa(e,3); nedof = elpa(e,5); 
  ec0 = crd0(lok(e,3:2+nenod),:); ec = ec0;
  em = zeros(nedof); 

%----------------------------------------------------------------------
% Element stiffness matrix

  s   = eldaC(e,1) ; c  = eldaC(e,2); 
  ML  = [  c*c  c*s -c*c -c*s ;  c*s  s*s -c*s -s*s
          -c*c -c*s  c*c  c*s ; -c*s -s*s  c*s  s*s ];

%----------------------------------------------------------------------

  l0 = elda0(e,3); A0 = elda0(e,4); E0 = elda0(e,8);

  em = (A0/l0 * E0) * ML ;
  sm(lokvg(e,1:nedof),lokvg(e,1:nedof)) = ...
    sm(lokvg(e,1:nedof),lokvg(e,1:nedof)) + em;
end; % element loop 'e'

%----------------------------------------------------------------------
% Transformation for local nodal coordinate systems
%----------------------------------------------------------------------
sm = Trm' * sm * Trm; 
%----------------------------------------------------------------------
% Boundary conditions and links
%----------------------------------------------------------------------
pe = pe0; fe = fe0; rs = fe;

if npl>0, rs = rs - sm(:,plc)*lif'; end; 

%----------------------------------------------------------------------
% Partitioning is done in the function                     fbibpartit.m

[sm,rs] = fbibpartit(1,sm,rs,ndof,pa,ppc,plc,prc,pe,lim);

%----------------------------------------------------------------------
% Solving the system of equations and take prescribed displacements
% and links into account.
% Update nodal point coordinates 'crd'.

sol = inv(sm)*rs; % sol = sm\rs;

pe(pu) = sol;
if npl>0, pe(plc) = lim*pe(prc) + lif'; end;

p = pe; pT = Trm * p;
crd = crd0 + reshape(pT,nndof,nnod)';

%----------------------------------------------------------------------
% Calculate stresses and strains and the internal forces 'ef'.
% Internal forces 'ef' are assembled into 'fi', the structural
% internal forces, representing the reaction forces.
%----------------------------------------------------------------------
fi = zeros(ndof,1); 

for e=1:ne
  ety = elpa(e,1); egr = elpa(e,2); 
  ec0 = crd0(lok(e,2+1:2+nenod),:);
  ec = crd(lok(e,2+1:2+nenod),:);
  ef = zeros(nedof,1);

%----------------------------------------------------------------------
% Element internal forces

  s   = eldaC(e,1) ; c  = eldaC(e,2); 
  V    = [ -c -s c s ]';

%----------------------------------------------------------------------

  l0 = elda0(e,3); A0 = elda0(e,4); 
  E0 = elda0(e,8); Gn0 = elda0(e,7);
  x1 = ec(1,1); y1 = ec(1,2); x2 = ec(2,1); y2 = ec(2,2);
  l  = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
  s  = (y2-y1)/l;     c  = (x2-x1)/l;
  Gl  = l/l0; Ge = Gl-1; 
  Ged = -Gn0*Ge; Gm = Ged+1; A = Gm*Gm*A0; Gs = E0 * Ge; N = A * Gs; 

  eldaC(e,1:7)   = [s c l A 0 Ge Gs]; 
  eldaC(e,11:18) = [Gl Gm Ge 0 0 Gs 0 N];

  ef = N * V;

  fi(lokvg(e,1:nedof)) = fi(lokvg(e,1:nedof)) + ef;
end; 

rs = fe - fi;
fi = Trm' * fi; fiT = fi; fiT = Trm * fi; rsT = feT - fiT;

%----------------------------------------------------------------------
% Reshaping columns into matrices

Mp  = reshape(p,nndof,nnod)';    MTp = Mp;
Mfi = reshape(fi,nndof,nnod)';   Mfe = reshape(fe,nndof,nnod)';
Mrs = reshape(rs,nndof,nnod)';

if ntr>=1
MpT  = reshape(pT,nndof,nnod)';  MTpT = MpT;
MfiT = reshape(fiT,nndof,nnod)'; MfeT = reshape(feT,nndof,nnod)';
MrsT = reshape(rsT,nndof,nnod)';
end;
%----------------------------------------------------------------------

%**********************************************************************
