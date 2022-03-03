%======================================================================
% d3t29c87n33a.m : 7 x di-piramide cable-truss; measures in 'm'

%close all;clear all;delete('loadincr.m','savedata.m');

HHH=4; LLL=3.5; MAG=LLL/5;
a = LLL/2;                            %          3
b = sqrt(3)/2 * LLL;                  %          *  *
c = b/3;                              %          *    *
d = 2*c;                              %          *  1   2
e = HHH/2;                            %          *    *
f = HHH;                              %          *  *
                                      %          4
crd0 = [
%--------------------------------  floor
 0  0  0
 d  0  0
-c  a  0
-c -a  0
%--------------------------------  bottom section 1
 0  0  e
 d  0  e
-c  a  e
-c -a  e
%--------------------------------  bottom section 2
 0  0  e+f
 d  0  e+f
-c  a  e+f
-c -a  e+f
%--------------------------------  bottom section 3
 0  0  e+2*f
 d  0  e+2*f
-c  a  e+2*f
-c -a  e+2*f
%--------------------------------  bottom section 4
 0  0  e+3*f
 d  0  e+3*f
-c  a  e+3*f
-c -a  e+3*f
%--------------------------------  bottom section 5
 0  0  e+4*f
 d  0  e+4*f
-c  a  e+4*f
-c -a  e+4*f
%--------------------------------  bottom section 6
 0  0  e+5*f
 d  0  e+5*f
-c  a  e+5*f
-c -a  e+5*f
%--------------------------------  bottom top
 0  0  e+6*f
 d  0  e+6*f
-c  a  e+6*f
-c -a  e+6*f
%--------------------------------  top
 0  0  7*f
];

lok = [
%--------------------------------  bottom section
9 1  1  5     % strut vertical
%
%1 6  2  5     % cable cross
%1 6  3  5     % cable cross
%1 6  4  5     % cable cross
%
1 2  2  6     % cable vertical
1 2  3  7     % cable vertical
1 2  4  8     % cable vertical
%
1 3  2  7     % cable diagonal
1 3  2  8     % cable diagonal
1 3  3  6     % cable diagonal
1 3  3  8     % cable diagonal
1 3  4  6     % cable diagonal
1 3  4  7     % cable diagonal
%--------------------------------  section 1
9 4  5  6     % strut planar
9 4  5  7     % strut planar
9 4  5  8     % strut planar
%
1 5  6  7     % cable planar
1 5  7  8     % cable planar
1 5  8  6     % cable planar
%
9 1  5  9     % strut vertical
%
%1 6  6  9     % cable cross
%1 6  7  9     % cable cross
%1 6  8  9     % cable cross
%
1 2  6 10     % cable vertical
1 2  7 11     % cable vertical
1 2  8 12     % cable vertical
%
1 3  6 11     % cable diagonal
1 3  6 12     % cable diagonal
1 3  7 10     % cable diagonal
1 3  7 12     % cable diagonal
1 3  8 10     % cable diagonal
1 3  8 11     % cable diagonal
%--------------------------------  section 2
9 4  9 10     % strut planar
9 4  9 11     % strut planar
9 4  9 12     % strut planar
%
1 5 10 11     % cable planar
1 5 11 12     % cable planar
1 5 12 10     % cable planar
%
9 1  9 13     % strut vertical
%
%1 6 10 13     % cable cross
%1 6 11 13     % cable cross
%1 6 12 13     % cable cross
%
1 2 10 14     % cable vertical
1 2 11 15     % cable vertical
1 2 12 16     % cable vertical
%
1 3 10 15     % cable diagonal
1 3 10 16     % cable diagonal
1 3 11 14     % cable diagonal
1 3 11 16     % cable diagonal
1 3 12 14     % cable diagonal
1 3 12 15     % cable diagonal
%--------------------------------  section 3
9 4 13 14     % strut planar
9 4 13 15     % strut planar
9 4 13 16     % strut planar
%
1 5 14 15     % cable planar
1 5 15 16     % cable planar
1 5 16 14     % cable planar
%
9 1 13 17     % strut vertical
%
%1 6 14 17     % cable cross
%1 6 15 17     % cable cross
%1 6 16 17     % cable cross
%
1 2 14 18     % cable vertical
1 2 15 19     % cable vertical
1 2 16 20     % cable vertical
%
1 3 14 19     % cable diagonal
1 3 14 20     % cable diagonal
1 3 15 18     % cable diagonal
1 3 15 20     % cable diagonal
1 3 16 18     % cable diagonal
1 3 16 19     % cable diagonal
%--------------------------------  section 4
9 4 17 18     % strut planar
9 4 17 19     % strut planar
9 4 17 20     % strut planar
%
1 5 18 19     % cable planar
1 5 19 20     % cable planar
1 5 20 18     % cable planar
%
9 1 17 21     % strut vertical
%
%1 6 18 21     % cable cross
%1 6 19 21     % cable cross
%1 6 20 21     % cable cross
%
1 2 18 22     % cable vertical
1 2 19 23     % cable vertical
1 2 20 24     % cable vertical
%
1 3 18 23     % cable diagonal
1 3 18 24     % cable diagonal
1 3 19 22     % cable diagonal
1 3 19 24     % cable diagonal
1 3 20 22     % cable diagonal
1 3 20 23     % cable diagonal
%--------------------------------  section 5
9 4 21 22     % strut planar
9 4 21 23     % strut planar
9 4 21 24     % strut planar
%
1 5 22 23     % cable planar
1 5 23 24     % cable planar
1 5 24 22     % cable planar
%
9 1 21 25     % strut vertical
%
%1 6 22 25     % cable cross
%1 6 23 25     % cable cross
%1 6 24 25     % cable cross
%
1 2 22 26     % cable vertical
1 2 23 27     % cable vertical
1 2 24 28     % cable vertical
%
1 3 22 27     % cable diagonal
1 3 22 28     % cable diagonal
1 3 23 26     % cable diagonal
1 3 23 28     % cable diagonal
1 3 24 26     % cable diagonal
1 3 24 27     % cable diagonal
%--------------------------------  section 6
9 4 25 26     % strut planar
9 4 25 27     % strut planar
9 4 25 28     % strut planar
%
1 5 26 27     % cable planar
1 5 27 28     % cable planar
1 5 28 26     % cable planar
%
9 1 25 29     % strut vertical
%
%1 6 26 29     % cable cross
%1 6 27 29     % cable cross 
%1 6 28 29     % cable cross
%
1 2 26 30     % cable vertical
1 2 27 31     % cable vertical
1 2 28 32     % cable vertical
%
1 3 26 31     % cable diagonal
1 3 26 32     % cable diagonal
1 3 27 30     % cable diagonal
1 3 27 32     % cable diagonal
1 3 28 30     % cable diagonal
1 3 28 31     % cable diagonal
%--------------------------------  top
9 4 29 30     % strut planar
9 4 29 31     % strut planar
9 4 29 32     % strut planar
%
1 5 30 31     % cable planar
1 5 31 32     % cable planar
1 5 32 30     % cable planar
%
9 1 29 33     % strut vertical
%
1 6 30 33     % cable cross
1 6 31 33     % cable cross
1 6 32 33     % cable cross
];

pp = [ 1 1 0; 1 2 0; 1 3 0;
       2 1 0; 2 2 0; 2 3 0;
       3 1 0; 3 2 0; 3 3 0;
       4 1 0; 4 2 0; 4 3 0; ];

if ~exist('Gs1'), Gs1 = 172.8e6; end; % 172.8e6; 125e6;
if ~exist('Gs2'), Gs2 = 59.9e6;  end; % 59.9e6;  50e6; 
if ~exist('Gs3'), Gs3 = 50.9e6;  end; % 50.9e6;  50e6; 
if ~exist('Gs4'), Gs4 = 198.2e6; end; % 198.2e6; 125e6;

elda = [ 9 11 3000e-6 0    0  70e9 0.25 0 0 0;     % strut vertical
         1 11  100e-6 Gs1  0 120e9 0.25 0 0 0;     % cable vertical
         1 11  100e-6 Gs2  0 120e9 0.25 0 0 0;     % cable diagonal
         9 11 3000e-6 0    0  70e9 0.25 0 0 0;     % strut planar
         1 11  100e-6 Gs3  0 120e9 0.25 0 0 0;     % cable planar
         1 11  100e-6 Gs4  0 120e9 0.25 0 0 0  ] ; % cable cross

pf = [ 33 1 1500; 33 2 1500; 33 3 -2000 ];

nic=2; tr3d; magf = MAG/max(max(abs(MTp))); 

sres1 = sqrt(Mfe(33,1).^2 + Mfe(33,2).^2 + Mfe(33,3).^2); 
sres2 = sqrt(MTp(33,1).^2 + MTp(33,2).^2 + MTp(33,3).^2);
MSp = MTp - MIp;
sres3 = sqrt(MSp(33,1).^2 + MSp(33,2).^2 + MSp(33,3).^2);
cres1 = eldaC(:,7);

%======================================================================

