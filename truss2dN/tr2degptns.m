%======================================================================
delete('loadincr.m','savedata.m');

crd0 = [ 0 0 ; 100 0 ]; 
lok = [ 9 1 1 2 ];

mat=elda(2);

if ~exist('pr'), pr='im'; end;
if ~exist('cnm'), cnm=2; end;
if ~exist('ccr'), ccr=1e-8; end;
if ~exist('dim'), dim=1; end;
if ~exist('DGe0'), DGe0=0; end;
if ~exist('GDt'), GDt=0.005; end;
if ~exist('nic'), nic=1; end;

pp0 = [ 1 1 0 ; 1 2 0 ; 2 2 0 ];
pp  = [ pp0 ; 2 1 1 ]; 

if DGe0>0, 
  [St,Sft,nic,GDt,tend] = mloin(0,1.4/DGe0,2500,0,['100*exp(' num2str(DGe0) '*t)'],[0 -100]);
else
%  [St,Sft,nic,GDt,tend] = mloin(0,14,0,GDt,'100*exp(0.1*t)',[0 -100]); 
  [St,Sft,nic,GDt,tend] = mloin(0,0,500,GDt,'100*exp(0.1*t)',[0 -100]);
%  [St,Sft,nic,GDt,tend] = mloin(0,0,500,GDT/5,'pol',[0 0 100*GDt 50]); 
%  [St,Sft,nic,GDt,tend] = mloin(0,0,nic,GDt,'pol',[0 0 nic*GDt/3 25 2*nic*GDt/3 -25 nic*GDt 0]);
end;

ts=GDt;

msada('eld',[1 4; 1 6; 1 7; 1 11; 1 25; 1 26; 1 28],'rfc',[2 1 1]);

%======================================================================
