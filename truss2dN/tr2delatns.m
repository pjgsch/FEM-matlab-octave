%======================================================================
delete('loadincr.m','savedata.m');

crd0 = [ 0 0 ; 100 0 ]; 
lok  = [ 9 1 1 2 ]; 
pp0  = [ 1 1 0 ; 1 2 0 ; 2 2 0 ];

elda = [ 9 ma 10 0 0 100000 0.3 0 0 0 ]; 

%%%% prescribed elongation
pp   = [ pp0; 2 1 1 ]; 
%[St,Sft,nic,GDt,tend] = mloin(0,0,nic,1,'pol',[0 -50 nic nic-50]); 
[St,Sft,nic,GDt,tend] = mloin(0,0,nic,1,'t',[0 0]); 
%%%% prescribed forxe
%if     ma==11,
%  pp = pp0; pf = [ 2 1 4.9e5 ]; 
%  [St,Sft,nic,GDt,tend] = mloin(0,0,200,1,'pol',[0 0 200 1]);
%elseif ma==13.
%  pp = pp0; pf = [ 2 1 4.165e5 ]; 
%  [St,Sft,nic,GDt,tend] = mloin(0,0,200,1,'pol',[0 0 200 1]);
%elseif ma==14,
%  pp = pp0; pf = [ 2 1 3.8e3 ]; 
%  [St,Sft,nic,GDt,tend] = mloin(0,200,200,0,'(300/200)*t',[0 -50]);
%end;

msada('eld',[1 4; 1 7; 1 11],'rfc',[2 1]);

mit=100;ccr=0.01;nl=1; 
%======================================================================
