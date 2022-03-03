%**********************************************************************
% d3t6c9n7a.m : Cable-strut prism
% units are 'millimeter'

close all;clear all;delete('loadincr.m','savedata.m');

LLL=200; HHH=300; MAG=LLL/5;

crd0 = [ 0        0                  0;               
         LLL      0                  0;   
         LLL/2    LLL*(sqrt(3))/2    0;
         0        0                  HHH; 
         LLL      0                  HHH; 
         LLL/2    LLL*(sqrt(3))/2    HHH;
         LLL/2    LLL*(sqrt(3))/6    HHH/2    ];

lok = [ 
9 1 1 7; 9 1 2 7; 9 1 3 7;       % lower struts
9 1 4 7; 9 1 5 7; 9 1 6 7        % upper struts
1 2 1 2; 1 2 2 3; 1 2 3 1;       % lower cables
1 2 4 5; 1 2 5 6; 1 2 6 4;       % upper cables
1 3 1 4; 1 3 2 5; 1 3 3 6; ];    % vertical cables

pp = [1 1 0; 1 2 0; 1 3 0; 2 2 0; 2 3 0; 3 3 0 ];

figure;plotmesh3([0 1 1 0 1 0 0 0 0],lok,crd0,crd0,pp,[],1);
view(40,15);

elda = [ 9 11 10  0   0 100e3 0.25 0 0 0
         1 11  1  1e3 0 100e3 0.25 0 0 0 
         1 11  1  1e3 0 100e3 0.25 0 0 0 ];

pf=[4 3 -1000; 5 3 -1000; 6 3 -1000];

nic=1; tr3d; magf = MAG/max(max(abs(MTp))), 
figure;plotmesh3([magf 1 0 0 1 0 0 0 0],lok,crd0,crd,pp,eldaC,1); 
view(10,15); 

nic=2; tr3d; magf = MAG/max(max(abs(MTp))), 
figure;plotmesh3([magf 1 0 0 1 0 0 0 0],lok,crd0,crd,pp,eldaC,1); 
view(10,15);

%**********************************************************************
