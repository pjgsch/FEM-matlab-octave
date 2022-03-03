%======================================================================
% d2t1c2n4a.m : two-dimensional mast
% units are 'meter'.

close all;clear all;delete('loadincr.m','savedata.m');

crd0 = [ 0 0 0; 0 4 0; -1 0 0; 1 0 0 ];
lok  = [ 9 1 1 2; 1 2 3 2; 1 2 4 2 ];
elda = [ 9 11 100e-6 0   0 200e9 0.3 0 0 0
         1 11 10e-6  1e6 0 200e9 0.3 0 0 0 ];

figure;plotmesh3([0 1 0 0 1 0 0 0 0],lok,crd0,crd0,[],[],1); 
view(0,90);

pp = [ 1 1 0; 1 2 0; 1 3 0;
       2 3 0;
       3 1 0; 3 2 0; 3 3 0; 4 1 0; 4 2 0; 4 3 0 ];
pf = [ 2 1 1000 ];

nic=1; tr3d;

figure;plotmesh3([100000 1 0 0 0 0 0 0 0],lok,crd0,crd,pp,eldaC,1); 
view(0,90);

nic=2; tr3d; 

figure;plotmesh3([10 1 0 0 0 0 0 0 0],lok,crd0,crd,pp,eldaC,1); 
view(0,90);
%======================================================================
