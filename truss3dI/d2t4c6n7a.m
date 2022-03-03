%**********************************************************************
% d2t4c6n7a.m : 2D di-pyramid

%clear all;close all;delete('loadincr.m','savedata.m');

crd0 = [% x-cooed   y-coord   z-coord
0 0 0; -0.5 0 0; 0.5 0 0; 
0 1 0; -0.5 1 0; 0.5 1 0; 
0 2 0
];

lok = [% ety   egr   node1  node2
9 1 1 4; 9 1 4 7; 9 1 4 5; 9 1 4 6;
1 2 2 5; 1 2 3 6; 
1 3 1 5; 1 3 1 6; 
1 4 5 7; 1 4 6 7
];

%figure;plotmesh3([0 0 1 0 0 0 0 0 0],lok,crd0,crd0,[],[],1);view(0,90);

pp = [% node  dof  value
1 1 0; 1 2 0; 1 3 0;
2 1 0; 2 2 0; 2 3 0;
3 1 0; 3 2 0; 3 3 0;
4 3 0; 5 3 0; 6 3 0; 7 3 0;
];

%figure;plotmesh3([0 0 1 0 1 0 0 0 0],lok,crd0,crd0,pp,[],1);view(0,90);

if ~exist('Gs1'), Gs1 = 1e6; end;
if ~exist('Gs2'), Gs2 = 1e6; end;
if ~exist('Gs3'), Gs3 = 1e6; end;

elda = [% ety  mnr  A0     Gs0    0  E      Gn    0 0 0
9 11 100e-6 0   0 200e9 0.25 0 0 0
1 11 10e-6  Gs1 0 200e9 0.25 0 0 0
1 11 10e-6  Gs2 0 200e9 0.25 0 0 0
1 11 10e-6  Gs3 0 200e9 0.25 0 0 0
];

%nic=1; tr3d; magf=10000;
%figure;plotmesh3([magf 1 0 0 0 0 0 0 0],lok,crd0,crd,pp,eldaC,1);view(0,90);

pf = [% node  dof  value
7 1 10
];

nic=2; tr3d; magf=1000;
%figure;plotmesh3([magf 1 0 0 0 0 0 0 0],lok,crd0,crd,pp,eldaC,1);view(0,90);

sres1 = sqrt(Mfe(7,1).^2 + Mfe(7,2).^2 + Mfe(7,3).^2); 
sres2 = sqrt(MTp(7,1).^2 + MTp(7,2).^2 + MTp(7,3).^2);
MSp = MTp - MIp;
sres3 = sqrt(MSp(7,1).^2 + MSp(7,2).^2 + MSp(7,3).^2);
cres1 = eldaC(:,7);

%**********************************************************************
