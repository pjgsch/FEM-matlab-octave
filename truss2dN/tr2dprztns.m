%**********************************************************************
delete('loadincr.m','savedata.m');

crd0 = [0 0; 100 0]; 
lok  = [9 1 1 2]; 
pp0  = [1 1 0; 1 2 0; 2 2 0];
pp   = [ pp0; 2 1 1 ]; 
%pp  = pp0; pf = [ 2 1 3500 ];

elda = [ 9 51 10 0 0 1800 0.37 0.001 3 37 -200 500 700 800 30000]; 
hp1=-200;hp2=500;hp3=700;hp4=800;hp5=30000; hm='so'; pr='im'; 

if GDt==0
%  [St,Sft,nic,GDt,tend] = mloin(0,0.4/DGe0,nic,0,['100*' num2str(DGe0) '*t'],[0 0]);
  [St,Sft,nic,GDt,tend] = mloin(0,0.4/DGe0,nic,0,'pol',[0 0 0.4/DGe0 40]);
elseif DGe0==0
%  [St,Sft,nic,GDt,tend] = mloin(0,0,nic,GDt,'pol',[0 0 nic*GDt 40]);
  [St,Sft,nic,GDt,tend] = mloin(0,0,nic,GDt,'pol',[0 0 nic*GDt/3 25 2*nic*GDt/3 -25 nic*GDt 0]);
end;

%pp = pp0; pf = [ 2 1 3500 ];
%[St,Sft,nic,GDt,tend] = mloin(0,0,nic,GDt,'pol',[0 0 nic*GDt 1]); 
%ccr=1e-4;slw=0; 

nl=1; ts = GDt; 

msada('eld',[1 4; 1 6; 1 7; 1 11; 1 25; 1 28],'rfc',[2 1 1]);


%======================================================================
