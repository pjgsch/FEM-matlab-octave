%**********************************************************************
edit tr2d.m

%======================================================================
% Tensile; elastic;
% Type 'edit tr2delatns.m' to specify geometry and loading.
%----------------------------------------------------------------------
clear all; ma=11; nic=250; tr2delatns; tr2d;                   % Gs-Gel
clear all; ma=12; nic=250; tr2delatns; tr2d;                  % Gs-Geln
clear all; ma=13; nic=150; tr2delatns; tr2d;                     % Gs-A
clear all; ma=14; nic=150; tr2delatns; tr2d;                      % P-E
%----------------------------------------------------------------------
figure; plotplot(S111,S17,2);grid on;xlabel('\lambda');ylabel('\sigma [MPa]'); 
figure; plotplot(S111,Sfi21,2);grid on;xlabel('\lambda');ylabel('F [N]'); 
figure; plotplot(S111,S14,2);grid on;xlabel('\lambda');ylabel('A [mm^2]'); 
figure; plotplot(Sic,Sit,2);grid on;xlabel('ic');ylabel('it'); 
%======================================================================

%======================================================================
% Tensile; elastomeric;
% Type 'edit tr2delmtns.m' to specify geometry and loading.
%----------------------------------------------------------------------
clear all; ma=21;C01=20000;C10=0;    nic=300; tr2delmtns; tr2d;
clear all; ma=22;C01=20000;C10=20000;nic=300; tr2delmtns; tr2d;
%----------------------------------------------------------------------
figure; plotplot(S111,S17,2);grid on;xlabel('\lambda');ylabel('\sigma [MPa]'); 
figure; plotplot(S111,Sfi21,2);grid on;xlabel('\lambda');ylabel('F [N]'); 
%======================================================================

%======================================================================
% Tensile; viscoelastic;                              
% type 'edit tr2dvietns.m' to specify geometry and loading.
%----------------------------------------------------------------------
clear all; elda=[9 42 10 0 0 0   0.0 1 0 0 0]; mm=[1 0.01];     tr2dvietns; tr2d; 
clear all; elda=[1 42 10 0 0 0   0.3 1 0 0 0]; mm=[1e9 1];      tr2dvietns; tr2d; 
clear all; elda=[9 42 10 0 0 1   0.0 1 0 0 0]; mm=[1e10 1e-12]; tr2dvietns; tr2d; 
clear all; elda=[9 42 10 0 0 1   0.0 1 0 0 0]; mm=[1 0.01];     tr2dvietns; tr2d; 

clear all; elda=[9 42 10 0 0 0   0.0 1 0 0 0]; mm=[100 0.1];    tr2dvietns; tr2d; 
clear all; elda=[9 42 10 0 0 100 0.0 1 0 0 0]; mm=[1e10 1e-9];  tr2dvietns; tr2d; 
clear all; elda=[9 42 10 0 0 100 0.0 1 0 0 0]; mm=[100 0.1];    tr2dvietns; tr2d; 
clear all; elda=[9 42 10 0 0 100 0.0 2 0 0 0]; mm=[100 0.1; 100 0.1]; tr2dvietns; tr2d; 

clear all; elda = [1 42 10 0 0 2.5e5 0.3 12 0 0 0 ];
mm = [ 3.0e6 3.1e-8; 1.4e6 3.0e-7; 3.9e6 3.0e-6; 5.4e6 2.9e-5; 
       1.3e6 2.8e-4; 2.3e5 2.7e-3; 7.6e4 2.6e-2; 3.7e4 2.5e-1; 
       3.3e4 2.5e+0; 1.7e4 2.4e+1; 8.0e3 2.3e+2; 1.2e4 2.2e+3 ];
tr2dvietns; tr2d; 

clear all; elda = [ 1 42 1 0 0  0 0.3 8 0 0 0 ];
mm = [ 7.6e4  9.8e-5; 5.3e+4 1.2e-3; 1.9e+4 1.3e-2; 1.7e+3 9.8e-2
       9.0e-1 2.3e+0; 4.5e-3 5.1e+1; 2.7e-5 7.2e+2; 2.4e-7 1.0e+4 ];
tr2dvietns; tr2d; 

clear all; elda  = [1 42 1 0 0  2.5e5 0.3 12 0 0 0 ];
mm = [ 3.0e6 3.1e-8; 1.4e6 3.0e-7; 3.9e6 3.0e-6; 5.4e6 2.9e-5;
       1.3e6 2.8e-4; 2.3e5 2.7e-3; 7.6e4 2.6e-2; 3.7e4 2.5e-1;
       3.3e4 2.5e+0; 1.7e4 2.4e+1; 8.0e3 2.3e+2; 1.2e4 2.2e+3 ];
tr2dvietns; tr2d; 
%----------------------------------------------------------------------
figure; plot(Sti,S16);grid on;xlabel('t [s]');ylabel('\epsilon '); 
figure; plot(Sti,SGs1);grid on;xlabel('t [s]');ylabel('\sigma [MPa]'); 
figure; plot(Sti,S17);grid on;xlabel('t [s]');ylabel('\sigma '); 
figure; plot(S16,S17);grid on;xlabel('\epsilon');ylabel('\sigma');
%======================================================================

%======================================================================
% Tensile test; creep;                                
% Type 'edit tr2delvtns.m' to specify geometry and loading.
%----------------------------------------------------------------------
clear all; elda=[9 71 10 0 0 1e9 0.3 1e-9 1];        f0=1e7; tr2delvtns; tr2d; % Norton 
clear all; elda=[9 72 10 0 0 1e9 0.3 1e-6 1e-6];     f0=7e6; tr2delvtns; tr2d; % Dorn
clear all; elda=[9 73 10 0 0 1e9 0.3 0.003 0.0003 ]; f0=7e7; tr2delvtns; tr2d; % Andrade
clear all; elda=[9 74 10 0 0 1e5 0.3 1e-6 1e2];      f0=1e3; tr2delvtns; tr2d; % Soderberg
clear all; elda=[9 75 10 0 0 1e3 0.3 1e4 1000];      f0=1e2; pr='ex';  tr2delvtns; tr2d; % Lifszic
clear all; E=59533; elda=[9 76 10 0 0 E 0.3 398 66.667 4e-7 1e-12 -3223 -7348 3 12]; f0=100; cmn=6; tr2delvtns; tr2d; % Wiese 
%----------------------------------------------------------------------
figure; plot(Sti,S17);grid on;xlabel('t [s]');ylabel('\sigma [MPa]');
figure; plot(Sti,S16);grid on;xlabel('t [s]');ylabel('\epsilon');
figure; plot(Sti,S125);grid on;xlabel('t [s]');ylabel('C [MPa]');
figure; plot(Sti,Sfi21);grid on;xlabel('t [s]');ylabel('F [N]');            
%======================================================================

%======================================================================
% Tensile test; elastoplastic; hardening laws;        
% Type 'edit tr2dplatns.m' to specify geometry and loading.
%----------------------------------------------------------------------
clear all; hm='li';                             tr2dplatns; tr2d;
clear all; hm='li'; hp1=5000;                   tr2dplatns; tr2d;
clear all; hm='li'; hp1=-10000;                 tr2dplatns; tr2d; 
clear all; hm='lu'; hp1=0.3;                    tr2dplatns; tr2d;
clear all; hm='ml'; hp1=1; hp2=0.3; m=1; n=0.3; tr2dplatns; tr2d;
clear all; hm='sw'; hp1=1; hp2=0.3;             tr2dplatns; tr2d;
clear all; hm='pr';                             tr2dplatns; tr2d;
clear all; hm='b1'; hp1=0.3;                    tr2dplatns; tr2d;
clear all; hm='b2'; hp1=0.3;                    tr2dplatns; tr2d;
clear all; hm='vc'; hp1=1; hp2=0.3;             tr2dplatns; tr2d;
clear all; hm='ex'; hp1=5000; hp2=0.8;          tr2dplatns; tr2d;
clear all; hm='so'; hp1=10000;                  tr2dplatns; tr2d;
clear all; hm='qu'; hp1=10000; hp2=100000;      tr2dplatns; tr2d;
clear all; hm='su'; hp1=500; hp2=0.3;           tr2dplatns; tr2d;
clear all; hm='hm'; hp1=0.25; hp2=200;          tr2dplatns; tr2d;
%----------------------------------------------------------------------
figure; plot(S16,S17,S16,S17,'r+');grid on;
        xlabel('\epsilon');ylabel('\sigma [MPa]'); 
figure; plot(S121,S116);grid on; 
        xlabel('\epsilon');ylabel('\sigma [MPa]'); 
figure; plot(Su21,Sfi21);grid on; 
        xlabel('u [mm]'); ylabel('F [N]'); 
figure; plot(S16,S129,S16,S129,'r+');grid on;
        xlabel('\epsilon');ylabel('C [MPa]'); 
%======================================================================

%======================================================================
% Tensile test; Perzyna;                              
% Type 'edit tr2dprztns.m' to specify geometry and loading.
%----------------------------------------------------------------------
clear all; DGe0=0.01; GDt=0; nic=100; tr2dprztns; tr2d; 
clear all; DGe0=0.1;  GDt=0; nic=100; tr2dprztns; tr2d; 
clear all; DGe0=1;    GDt=0; nic=100; tr2dprztns; tr2d; 

clear all; DGe0=0; GDt=0.001; nic=200; tr2dprztns; tr2d; 
clear all; DGe0=0; GDt=0.01;  nic=200; tr2dprztns; tr2d; 
clear all; DGe0=0; GDt=0.1;   nic=200; tr2dprztns; tr2d; 
%----------------------------------------------------------------------
figure; plotplot(S111,S17,2);grid on;
        xlabel('\lambda');ylabel('\sigma [MPa]');
%======================================================================

%======================================================================
% Tensile test; EGP;                                  
% Type 'edit tr2degptns.m' to specify geometry and loading.
%----------------------------------------------------------------------
clear all; elda=[9 61 10 0 0 1092 0.4  300 1e20 3  0   1  2.031926e-29 2.2e5   0.23    1.0  ]; GDt=0.005; nic=500; tr2degptns; tr2d; % PP
clear all; elda=[9 61 10 0 0 2400 0.35 300 1e20 15 13  11 3.8568e-27   2.617e5 0.0625  0.927]; GDt=0.005; nic=500; tr2degptns; tr2d; % PET
clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; GDt=0.005; nic=500; tr2degptns; tr2d; % PC
clear all; elda=[9 61 10 0 0 3300 0.37 300 1e20 13 100 14 4.261903e-34 2.6e5   0.294   2.1  ]; GDt=0.005; nic=500; tr2degptns; tr2d; % PS

clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; DGe0=1e-3; tr2degptns; tr2d; % PC
clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; DGe0=1e-2; tr2degptns; tr2d; % PC
clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; DGe0=1e-1; tr2degptns; tr2d; % PC
clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; DGe0=1e+0; tr2degptns; tr2d; % PC

clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; GDt=1e-3; nic=500; tr2degptns; % PC
clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; GDt=1e-2; nic=500; tr2degptns; % PC
clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; GDt=1e-1; nic=500; tr2degptns; % PC
clear all; elda=[9 61 10 0 0 2305 0.37 300 1e20 29 270 19 9.7573e-27   2.9e5   0.06984 0.72 ]; GDt=1e+0; nic=500; tr2degptns; % PC
%----------------------------------------------------------------------
figure; plot(S16,S17);grid on;
        xlabel('\epsilon');ylabel('\sigma [MPa]'); 
%======================================================================

%**********************************************************************




