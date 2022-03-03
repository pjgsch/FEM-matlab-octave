%======================================================================
delete('loadincr.m','savedata.m');

crd0 = [ 0 0 ; 100 0 ]; 
lok  = [ 9 1 1 2 ];
pp0  = [ 1 1 0 ; 1 2 0 ; 2 2 0 ];

mat=elda(2);

if ~exist('pr'),  pr='im';  end;
if ~exist('cnm'), cnm=2;    end;
if ~exist('ccr'), ccr=1e-8; end;
if ~exist('u0'),  u0=1;     end;
if ~exist('f0'),  f0=0.1;   end;

%%%% strain step;
 pp = [ pp0 ; 2 1 u0 ]; 
 [St,Sft,nic,GDt,tend] = mloin(0,10,100,0,'jmp',[0 1]); 
 if mat==76, [St,Sft,nic,GDt,tend] = mloin(0,149,100,0,'pol',[0 0 0 0.1 200 0.1]); end;

%%%% stress step;
% pp = pp0; pf = [ 2 1 f0 ]; 
% [St,Sft,nic,GDt,tend] = mloin(0,10,100,0,'jmp',[0 1]); 
% if mat==76, [St,Sft,nic,GDt,tend] = mloin(0,149,100,0,'pol',[0 0 0 0.1 50 0.1 50 0.05 150 0.1]); end;

ts = GDt; 

msada('eld',[1 6; 1 7; 1 23; 1 25],'rfc',[2 1]);
%======================================================================
