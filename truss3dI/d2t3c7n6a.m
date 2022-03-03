%**********************************************************************
% d2t3c7n6a.m : 2D-tensegrity; units are 'millimeter'
% Comment 'clear' and plotting when used in optimization

%close all;clear all;delete('loadincr.m','savedata.m');

SSS=100;LLL=1.5*SSS;HHH=SSS;

crd0 = [ -SSS/2     0; SSS/2     0; 
         -LLL/2 HHH/2; LLL/2 HHH/2; 
         -SSS/2   HHH; SSS/2   HHH ];
crd0 = [ crd0 zeros(6,1) ];

lok = [ 9 1 1 5; 9 1 2 6; 9 1 3 4;              % struts
        1 2 1 2;                                % horizontal
        1 3 1 3; 1 3 2 4; 1 3 3 5; 1 3 4 6;     % sides
        1 4 3 6; 1 4 4 5 ];                     % diagonal

%figure;plotmesh3([0 1 1 0 0 0 0 0 0],lok,crd0,crd0,[],[],1);view(0,90);

pp = [ 1 3 0; 2 3 0; 3 3 0; 4 3 0; 5 3 0; 6 3 0 ;
       1 1 0; 1 2 0; 2 2 0; ];

%figure;plotmesh3([0 1 1 0 1 0 0 0 0],lok,crd0,crd0,pp,[],1);view(0,90);

if ~exist('Gs1'), Gs1 = 2.25e2; end;
if ~exist('Gs2'), Gs2 = 2.25e2; end;
if ~exist('Gs3'), Gs3 = 2.25e2; end;

elda = [ 9 11 10 0   0 100e3 0.25 0 0 0         % struts
         1 11 1  Gs1 0 100e3 0.25 0 0 0         % horizontal
         1 11 1  Gs2 0 100e3 0.25 0 0 0         % sides
         1 11 1  Gs3 0 100e3 0.25 0 0 0 ];      % diagonal

%nic=1; tr3d; magf = 10/max(max(abs(MTp)));
%figure;plotmesh3([magf 1 0 0 1 0 0 0 0],lok,crd0,crd,pp,eldaC,1);view(0,90);

pf = [ 6 1 -100; 6 2 100 ];

nic=2; tr3d; magf = 10/max(max(abs(MTp)));
%figure;plotmesh3([magf 1 0 0 1 0 0 0 0],lok,crd0,crd,pp,eldaC,1);view(0,90);

% For optimization we have to calculate some output variables.

sres1 = sqrt(Mfe(6,1).^2 + Mfe(6,2).^2 + Mfe(6,3).^2); 
sres2 = sqrt(MTp(6,1).^2 + MTp(6,2).^2 + MTp(6,3).^2);
MSp = MTp - MIp;
sres3 = sqrt(MSp(6,1).^2 + MSp(6,2).^2 + MSp(6,3).^2);
cres1 = eldaC(:,7);

%**********************************************************************
