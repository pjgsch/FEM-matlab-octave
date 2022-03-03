%******************************************************************************
%
% plotmesh3.m

function plotmesh3(option,loka,crd0,crd,pp,eidaC,val)

%clf;

atelkp = size(loka,2)-2; 
atel   = size(loka,1); nel = atel;
atkp   = size(crd0,1);

if atelkp>2
  [outsides] = outline(loka);
end;

magfac = option(1);
inimsh = option(2);
nodpnt = option(3);
elmnrs = option(4);
intpnt = option(5);
isodir = option(6);
matdir = option(7);
pssdir = option(8);
inpval = option(9);

if ~exist('magfac'), magfac = 0; end;
if ~exist('inimsh'), inimsh = 0; end;
if ~exist('nodpnt'), nodpnt = 0; end;
if ~exist('elmnrs'), elmnrs = 0; end;
if ~exist('intpnt'), intpnt = 0; end;
if ~exist('isodir'), isodir = 0; end;
if ~exist('matdir'), matdir = 0; end;
if ~exist('pssdir'), pssdir = 0; end;
if ~exist('inpval'), inpval = 0; end;
if atelkp>2,         twodim = 1; else, twodim = 0; end;

%fprintf('magfac (%g) ',magfac); nv = input(''); if ~isempty(nv), magfac=nv; end;
%fprintf('inimsh (%d) ',inimsh); nv = input(''); if ~isempty(nv), inimsh=nv; end;
%fprintf('nodpnt (%d) ',nodpnt); nv = input(''); if ~isempty(nv), nodpnt=nv; end;
%fprintf('elmnrs (%d) ',elmnrs); nv = input(''); if ~isempty(nv), elmnrs=nv; end;
%fprintf('intpnt (%d) ',intpnt); nv = input(''); if ~isempty(nv), intpnt=nv; end;
%fprintf('isodir (%d) ',isodir); nv = input(''); if ~isempty(nv), isodir=nv; end;
%fprintf('matdir (%d) ',matdir); nv = input(''); if ~isempty(nv), matdir=nv; end;
%fprintf('pssdir (%d) ',pssdir); nv = input(''); if ~isempty(nv), pssdir=nv; end;
%fprintf('inpval (%d) ',inpval); nv = input(''); if ~isempty(nv), inpval=nv; end;

if nodpnt<0, nodpnt=0; outlin=1; else, outlin=0; end;

if (twodim==1 & magfac~=0)
  plaxipc; 
  ipc0 = eidaC(:,26:27);
  ipc  = eidaC(:,28:29);
  idp  = ipc - ipc0;
  ipcorg = ipc;
  ipc  = ipc - idp + magfac*idp;
end;

if magfac==0
  inimsh=1; defmsh=0; 
  crd=crd0;
else
  defmsh = 1;
end;

cdp = crd - crd0;
crdorg = crd;
crd = crd - cdp + magfac*cdp;

maxx0=max(crd0(:,1)); minx0=min(crd0(:,1));
maxy0=max(crd0(:,2)); miny0=min(crd0(:,2));
maxz0=max(crd0(:,3)); minz0=min(crd0(:,3));
maxx1=max(crd(:,1));  minx1=min(crd(:,1));
maxy1=max(crd(:,2));  miny1=min(crd(:,2));
maxz1=max(crd(:,3));  minz1=min(crd(:,3));
maxx=max([maxx0 maxx1]); maxy=max([maxy0 maxy1]); maxz=max([maxz0 maxz1]);
minx=min([minx0 minx1]); miny=min([miny0 miny1]); minz=min([minz0 minz1]);
mi  =min([minx  miny  minz]) ; ma  =max([maxx  maxy  maxz]);
%if maxx1>maxy1 , maxy1=maxx1; else , maxx1=maxy1; end;

%axis([minx1 maxx1 miny1 maxy1]);
%axis([minx ma miny ma]);
axis([mi ma mi ma mi ma]);
axis('square');

hold on;

%======================================================================

if inimsh~=0
if outlin~=1
for e=1:atel
  ec = crd0(loka(e,3:atelkp+2),:); 
  ety = loka(e,1);
  if inpval>=0, plelem(ec,atelkp,ety); end;
  plnode(ec,atelkp,'or');
end;
else
%  [outsides] = outline(loka);
  plout(crd0,outsides,'w');
end;
end;

if defmsh~=0
if outlin~=1
for e=1:atel
  ec = crd(loka(e,3:atelkp+2),:); 
  cl = 'b';
  ety = loka(e,1);
%
%  if eidaC(e,5)>=10, cl ='b'; end;
%  if eidaC(e,5)<10, cl='g'; end;
%  if eidaC(e,5)<7.5, cl='r'; end;
%  if eidaC(e,5)<5, cl='y'; end;
%  if eidaC(e,5)<2.5, cl='w'; end;
%
  if eidaC(e,6)~=0, lw = eidaC(e,6)/max(eidaC(:,6)); else, lw=1; end;
  if lw==0, lw=1; end;
%  if inpval>=0, plelev(ec,atelkp,lw); end;
  if abs(eidaC(e,7))<eps & ety==1, ety=-1; end;
  if inpval>=0, plelev(ec,atelkp,ety); end;
  plnode(ec,atelkp,'or');
end;
else
  plout(crd,outsides,'b');
end;
end;

%======================================================================

%if inimsh>0
%for e=1:atel
%  ec = crd0(loka(e,3:atelkp+2),:); 
%  plelem(ec,atelkp,'b');
%end;
%end;
%
%if inimsh<0, defmsh=-defmsh; end;
%
%if defmsh>0
%for e=1:atel
%  ec = crd(loka(e,3:atelkp+2),:); 
%  plelem(ec,atelkp,'b');
%%  plelem(ec,atelkp,'oy');
%end;
%end;
%
%if defmsh<0
%clear edges edg x y;
%edges = [];
%edges = [edges; loka(:,[1 2])];
%edges = [edges; loka(:,[2 3])];
%edges = [edges; loka(:,[3 4])];
%edges = [edges; loka(:,[4 1])];
%
%newedges = sort(edges')';
%newnewedges = sortrows(newedges,[1 2]);
%
%j=1;
%edg(j,:) = newnewedges(1,:);
%for i=2:size(newnewedges,1)-1
%  if (((newnewedges(i,1) ~= newnewedges(i+1,1)) | ...
%      (newnewedges(i,2) ~= newnewedges(i+1,2))) & ...
%     ((newnewedges(i,1) ~= newnewedges(i-1,1)) | ...
%      (newnewedges(i,2) ~= newnewedges(i-1,2)))) 
%    j=j+1;
%    edg(j,:) = newnewedges(i,:);
%  end;
%end;
%edg(j+1,:) = newnewedges(i+1,:);
%
%for i = 1 : size(edg,1)
%  x = [crd(edg(i,1),1) crd(edg(i,2),1)];
%  y = [crd(edg(i,1),2) crd(edg(i,2),2)];
%  cl = line(x,y); set(cl,'Color','black');
%end;
%
%end;

%======================================================================

if elmnrs==1
for e=1:atel
  ec = crd(loka(e,3:atelkp+2),:); 
  xgem = sum(ec(:,1))/atelkp; 
  ygem = sum(ec(:,2))/atelkp;
  zgem = sum(ec(:,3))/atelkp;
  text(xgem,ygem,zgem,num2str(e));
end;
end;

if nodpnt~=0
for i=1:atkp
  text(crd(i,1)+ma/30,crd(i,2)+ma/20,crd(i,3)+ma/20,num2str(i));
end;
end;

if (intpnt==1)
for i=1:size(pp,1)
  ppn = pp(i,1); ppd = pp(i,2); ppv = pp(i,3);
  if ppv==0, c = 'blue'; else, c = 'red'; end;
  ppx = crd(ppn,1); ppy = crd(ppn,2); ppz = crd(ppn,3);
  if ppd==1, 
    ppxx1 = ppx - (ma-mi)/10; ppxx2 = ppx - (ma-mi)/50;
    x = [ ppxx1 ppxx2 ]; y = [ ppy ppy ]; z = [ ppz ppz ];
  end;
  if ppd==2, 
    ppyy1 = ppy - (ma-mi)/10; ppyy2 = ppy - (ma-mi)/50;
    x = [ ppx ppx ]; y = [ ppyy1 ppyy2 ]; z = [ ppz ppz ];
  end;
  if ppd==3, 
    ppzz1 = ppz - (ma-mi)/10; ppzz2 = ppz - (ma-mi)/50;
    x = [ ppx ppx ]; y = [ ppy ppy ]; z = [ ppzz1 ppzz2 ];
  end;
  plot3(x,y,z,'Linewidth',5,'Color',c);
end;
end;

if (defmsh~=0 & twodim==1)
for e=1:atel
  ec = crd(loka(e,3:atelkp+2),:); 
  eipc = ipc(neip*(e-1)+1:neip*e,:);

  if intpnt==1
    for ip=1:neip
      text(eipc(ip,1),eipc(ip,2),'x');
      text(eipc(ip,1)+ma/30,eipc(ip,2)+ma/30,num2str(ip));
    end;
  end;

  if isodir==1
    f1=ma/(5*nel);
    for ip=1:neip
      plot([eipc(ip,1) eipc(ip,1)+eidaC(neip*(e-1)+ip,30)*f1],...
           [eipc(ip,2) eipc(ip,2)+eidaC(neip*(e-1)+ip,31)*f1]);
      plot([eipc(ip,1) eipc(ip,1)+eidaC(neip*(e-1)+ip,32)*f1],...
           [eipc(ip,2) eipc(ip,2)+eidaC(neip*(e-1)+ip,33)*f1]);
    end;
  elseif matdir==1
    f10=ma/(11*sqrt(nel));
    for ip=1:neip
      dd1 = eidaC(neip*(e-1)+ip,49);
      dd2 = eidaC(neip*(e-1)+ip,50);
      if (dd1>0 | dd2>0)
        f1 = f10*(dd1);
        f2 = f10*(dd2);
        n11 = cos(eidaC(neip*(e-1)+ip,13)*pi/180);
        n12 = sin(eidaC(neip*(e-1)+ip,13)*pi/180);
        n21 = -n12;
        n22 = n11;
        plot([eipc(ip,1)-n11*f2 eipc(ip,1)+n11*f2],...
             [eipc(ip,2)-n12*f2 eipc(ip,2)+n12*f2],'r');
        plot([eipc(ip,1)-n21*f1 eipc(ip,1)+n21*f1],...
             [eipc(ip,2)-n22*f1 eipc(ip,2)+n22*f1],'b');

%        plot([eipc(ip,1) eipc(ip,1)+n11*f1],...
%             [eipc(ip,2) eipc(ip,2)+n12*f1],'r');
%        plot([eipc(ip,1) eipc(ip,1)+n21*f1],...
%             [eipc(ip,2) eipc(ip,2)+n22*f1],'b');
      end;
    end;
  elseif pssdir==1
    f1=ma/(8*sqrt(nel));
    for ip=1:neip
      plot([eipc(ip,1)-eidaC(neip*(e-1)+ip,40)*f1 ...
            eipc(ip,1)+eidaC(neip*(e-1)+ip,40)*f1],...
           [eipc(ip,2)-eidaC(neip*(e-1)+ip,41)*f1 ...
            eipc(ip,2)+eidaC(neip*(e-1)+ip,41)*f1],'r');
      plot([eipc(ip,1)-eidaC(neip*(e-1)+ip,42)*f1 ...
            eipc(ip,1)+eidaC(neip*(e-1)+ip,42)*f1],...
           [eipc(ip,2)-eidaC(neip*(e-1)+ip,43)*f1 ...
            eipc(ip,2)+eidaC(neip*(e-1)+ip,43)*f1],'r');
    end;
  end;

  if inpval==1
    valval = eidaC(:,val);
    f1=ma/(15*sqrt(nel));
    for ip=1:neip
      text(eipc(ip,1),eipc(ip,2),'.');
      text(eipc(ip,1)+f1,eipc(ip,2)+f1,num2str(valval(neip*(e-1)+ip)));
    end;
  end;

end;
end;

%if version == '4.2c', 
  axis('equal'); axis('off'); 
%end;

hold off;
crd=crdorg;
if (twodim==1 & magfac~=0), ipc = ipcorg; end;

%save pmsh magfac inimsh nodpnt elmnrs intpnt isodir matdir pssdir inpval

%******************************************************************************
%**********************************************************************

function [outsides] = outline(loka);

nel = size(loka,1);
for e = 1:nel
  ns = 4*(e-1);
%  sides(ns+1,[1 2]) = loka(e,[1 2]);
%  sides(ns+2,[1 2]) = loka(e,[2 3]);
%  sides(ns+3,[1 2]) = loka(e,[3 4]);
%  sides(ns+4,[1 2]) = loka(e,[4 1]);
  sides(ns+1,[1 2]) = loka(e,[3 4]);
  sides(ns+2,[1 2]) = loka(e,[4 5]);
  sides(ns+3,[1 2]) = loka(e,[5 6]);
  sides(ns+4,[1 2]) = loka(e,[6 3]);
end;

sidesm = [min(sides,[],2) max(sides,[],2)];

ns = size(sides,1);
j = 1;

for s = 1:ns
  arr =[ones(ns,1)*sidesm(s,1) ones(ns,1)*sidesm(s,2)];
  dif = sidesm - arr;
  n = find(dif(:,1)==0 & dif(:,2)==0);
  sn = size(n,1); 
  if sn==1  , outsides(j,:) = sides(s,:); j=j+1; end;
end;

%**********************************************************************
%******************************************************************************

function plelem(ec,atelkp,ety);

if atelkp==2
  for i=1:atelkp , x(i) = ec(i,1); y(i) = ec(i,2); z(i) = ec(i,3); end;
elseif atelkp==4
  for i=1:atelkp , x(i) = ec(i,1); y(i) = ec(i,2); end;
  x(atelkp+1) = ec(1,1); y(atelkp+1) = ec(1,2);
elseif atelkp==8
  x(1) = ec(1,1); x(2) = ec(5,1); x(3) = ec(2,1); x(4) = ec(6,1);
  x(5) = ec(3,1); x(6) = ec(7,1); x(7) = ec(4,1); x(8) = ec(8,1);
  y(1) = ec(1,2); y(2) = ec(5,2); y(3) = ec(2,2); y(4) = ec(6,2);
  y(5) = ec(3,2); y(6) = ec(7,2); y(7) = ec(4,2); y(8) = ec(8,2);
  x(9) = x(1); y(9) = y(1);
end;

if     ety==0, lw=1; c='k';
elseif ety==1, lw=1; c='b';
elseif ety==9, lw=2; c='r';
end;

plot3(x,y,z,'LineWidth',lw,'Color',c);

%******************************************************************************
%**********************************************************************
function ploutl(crd0,outsides,c);

j = size(outsides,1);

for i=1:j
   x=[crd0(outsides(i,1),1) crd0(outsides(i,2),1)]; 
   y=[crd0(outsides(i,1),2) crd0(outsides(i,2),2)];
   plot(x,y,c); 
end;

%   x=[crd0(outsides(i,1),1) crd0(outsides(i,2),1)]; 
%   y=[crd0(outsides(i,1),2) crd0(outsides(i,2),2)];
%   plot(x,y,c); 

%**********************************************************************
%******************************************************************************

function plelev(ec,atelkp,ety);

if atelkp==2
  for i=1:atelkp , x(i) = ec(i,1); y(i) = ec(i,2); z(i) = ec(i,3); end;
elseif atelkp==4
  for i=1:atelkp , x(i) = ec(i,1); y(i) = ec(i,2); end;
  x(atelkp+1) = ec(1,1); y(atelkp+1) = ec(1,2);
elseif atelkp==8
  x(1) = ec(1,1); x(2) = ec(5,1); x(3) = ec(2,1); x(4) = ec(6,1);
  x(5) = ec(3,1); x(6) = ec(7,1); x(7) = ec(4,1); x(8) = ec(8,1);
  y(1) = ec(1,2); y(2) = ec(5,2); y(3) = ec(2,2); y(4) = ec(6,2);
  y(5) = ec(3,2); y(6) = ec(7,2); y(7) = ec(4,2); y(8) = ec(8,2);
  x(9) = x(1); y(9) = y(1);
end;

if     ety==0,  c='k'; lw=1;
elseif ety==1,  c='b'; lw=3;
elseif ety==9,  c='r'; lw=3;
elseif ety==-1; c='k'; lw=3;
end;

plot3(x,y,z,'LineWidth',lw,'Color',c);

%******************************************************************************
%******************************************************************************

function plnode(ec,atelkp,c);

if atelkp==2
  for i=1:atelkp , x(i) = ec(i,1); y(i) = ec(i,2); z(i) = ec(i,3); end;
elseif atelkp==4
  for i=1:atelkp , x(i) = ec(i,1); y(i) = ec(i,2); end;
  x(atelkp+1) = ec(1,1); y(atelkp+1) = ec(1,2);
elseif atelkp==8
  x(1) = ec(1,1); x(2) = ec(5,1); x(3) = ec(2,1); x(4) = ec(6,1);
  x(5) = ec(3,1); x(6) = ec(7,1); x(7) = ec(4,1); x(8) = ec(8,1);
  y(1) = ec(1,2); y(2) = ec(5,2); y(3) = ec(2,2); y(4) = ec(6,2);
  y(5) = ec(3,2); y(6) = ec(7,2); y(7) = ec(4,2); y(8) = ec(8,2);
  x(9) = x(1); y(9) = y(1);
end;

plot3(x,y,z,c);

%**********************************************************************
%**********************************************************************


