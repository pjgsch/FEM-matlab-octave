%======================================================================
delete('loadincr.m','savedata.m');

crd0 = [ 0 0 ; 100 0 ]; 
lok  = [ 9 1 1 2 ];
pp0  = [ 1 1 0 ; 1 2 0 ; 2 2 0 ];

mat=elda(2);

if ~exist('pr'),  pr='ie';  end;
if ~exist('cnm'), cnm=6;    end;
if ~exist('ccr'), ccr=1e-8; end;
if ~exist('u0'),  u0=1;     end;
if ~exist('f0'),  f0=0.1;   end;

%%%% strain step
 pp = [ pp0 ; 2 1 u0 ];
% [St,Sft,nic,GDt,tend] = mloin(0,0,100,0.0001,'jmp',[0 10]);
 [St,Sft,nic,GDt,tend] = mloin(0,10,1000,0,'jmp',[0 1]); ts = GDt; 
%%%% for multi-mode :
% [St,Sft,nic,GDt,tend] = mloin(0,1-0.01,0,0.01,'pol',[0 1 1 1]);
% [St,Sft,nic,GDt,tend] = mloin(0,0,100,0.001,'pol',[0 0 0 1 1 1]);

%%%% strain history
% pp = pp0; pf = [ 2 1 u0 ];  
% [St,Sft,nic,GDt,tend] = mloin(0,0,200,0.01,'pol',[0 1 0.5 1 2 16] ); 

%%%% stress step
% pp = pp0; pf  = [ 2 1 f0 ]; 
% [St,Sft,nic,GDt,tend] = mloin(0,0,100,0.001,'jmp',[0 10]); 

%%%% harmonic loading
%%%% For the Maxwell model the phase angle for strain loading is 
%%%% Gd1 = atan(1/Gt*Go) or Gd1 = atan(1/(mm(1,2)*Go)) .
%%%% From the plot we find : Gd2 = 0.016*Go .
%%%% The difference GGd = (Gd1-Gd2)*180/pi degrees.
% pp = [ pp0 ; 2 1 u0 ];
% Go = 20*pi; 
% [St,Sft,nic,GDt,tend] = mloin(0,4*(2*pi)/Go,0,0.001,'sin((20*pi)*t)',[0 0]);

ts = GDt; 

msada('eld',[1 6; 1 7],'efc',[2 1],'rfc',[1 1],'sts',[1],'stn',[1]);
%======================================================================

