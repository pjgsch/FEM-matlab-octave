%======================================================================
% d3t15c33n18a.m : 5 x triangular anti-prism; no real tensegrity
% measures in 'mm'

%clear all;close all;delete('loadincr.m','savedata.m');

LLL=2000; HHH=5000; RRR=1000; elen=LLL; ROT=150; MAG=LLL/5;

crd0 = [
RRR*cos((150)*pi/180)        RRR*sin((150)*pi/180) 0;
RRR*cos(( 30)*pi/180)        RRR*sin(( 30)*pi/180) 0;
RRR*cos((270)*pi/180)        RRR*sin((270)*pi/180) 0;
RRR*cos((150+ROT)*pi/180)    RRR*sin((150+ROT)*pi/180) HHH;
RRR*cos(( 30+ROT)*pi/180)    RRR*sin(( 30+ROT)*pi/180) HHH;
RRR*cos((270+ROT)*pi/180)    RRR*sin((270+ROT)*pi/180) HHH;
RRR*cos((150+2*ROT)*pi/180)  RRR*sin((150+2*ROT)*pi/180) 2*HHH;
RRR*cos(( 30+2*ROT)*pi/180)  RRR*sin(( 30+2*ROT)*pi/180) 2*HHH;
RRR*cos((270+2*ROT)*pi/180)  RRR*sin((270+2*ROT)*pi/180) 2*HHH;
RRR*cos((150+3*ROT)*pi/180)  RRR*sin((150+3*ROT)*pi/180) 3*HHH;
RRR*cos(( 30+3*ROT)*pi/180)  RRR*sin(( 30+3*ROT)*pi/180) 3*HHH;
RRR*cos((270+3*ROT)*pi/180)  RRR*sin((270+3*ROT)*pi/180) 3*HHH;
RRR*cos((150+4*ROT)*pi/180)  RRR*sin((150+4*ROT)*pi/180) 4*HHH;
RRR*cos(( 30+4*ROT)*pi/180)  RRR*sin(( 30+4*ROT)*pi/180) 4*HHH;
RRR*cos((270+4*ROT)*pi/180)  RRR*sin((270+4*ROT)*pi/180) 4*HHH;
RRR*cos((150+5*ROT)*pi/180)  RRR*sin((150+5*ROT)*pi/180) 5*HHH;
RRR*cos(( 30+5*ROT)*pi/180)  RRR*sin(( 30+5*ROT)*pi/180) 5*HHH;
RRR*cos((270+5*ROT)*pi/180)  RRR*sin((270+5*ROT)*pi/180) 5*HHH;
];

lok = [ 
1 2  1  2; 1 2  2  3; 1 2  3  1;        % bottom
%
9 1  1  4; 9 1  2  5; 9 1  3  6;        % struts
1 3  4  5; 1 3  5  6; 1 3  6  4;        % top
1 4  2  6; 1 4  3  4; 1 4  1  5;        % sides
%
9 1  4  7; 9 1  5  8; 9 1  6  9;
1 3  7  8; 1 3  8  9; 1 3  9  7;
1 4  5  9; 1 4  6  7; 1 4  4  8; 
%
9 1  7 10; 9 1  8 11; 9 1  9 12;
1 3 10 11; 1 3 11 12; 1 3 12 10;
1 4  8 12; 1 4  9 10; 1 4  7 11; 
%
9 1 10 13; 9 1 11 14; 9 1 12 15;
1 3 13 14; 1 3 14 15; 1 3 15 13;
1 4 11 15; 1 4 12 13; 1 4 10 14; 
%
9 1 13 16; 9 1 14 17; 9 1 15 18;         % +3
1 3 16 17; 1 3 17 18; 1 3 18 16;         % +3
1 4 14 18; 1 4 15 16; 1 4 13 17; 
];

pp = [ 1 1 0; 1 2 0; 1 3 0; 
       2 1 0; 2 2 0; 2 3 0; 
       3 1 0; 3 2 0; 3 3 0 ];

if ~exist('Gs1'), Gs1 = 400; end;
if ~exist('Gs2'), Gs2 = 50; end;
if ~exist('Gs3'), Gs3 = 500; end;

elda = [ 9 11 1000 0   0 100e3 0.25 0 0 0        % struts
         1 11 100  Gs1 0 100e3 0.25 0 0 0        % bottom
         1 11 100  Gs2 0 100e3 0.25 0 0 0        % top
         1 11 100  Gs3 0 100e3 0.25 0 0 0  ];    % sides

pf=[    16 1 -500; 17 1 -500; 18 1 -500];
pf=[pf; 16 2 -500; 17 2 -500; 18 2 -500];
pf=[pf; 16 3 -666; 17 3 -666; 18 3 -666];

nic=2; tr3d; magf = MAG/max(max(abs(MTp))); 

sres1 = sqrt(Mfe(16,1).^2 + Mfe(16,2).^2 + Mfe(16,3).^2); 
sres2 = sqrt(MTp(16,1).^2 + MTp(16,2).^2 + MTp(16,3).^2);
MSp = MTp - MIp;
sres3 = sqrt(MSp(16,1).^2 + MSp(16,2).^2 + MSp(16,3).^2);
cres1 = eldaC(:,7);

% figure; mshop = [1 1 1 0 1 0 0 0 0]; plotmovie;
% for i=1:1:120, view(10*i,15); pause(0.1); axis(ax); end; hold off;
%======================================================================
