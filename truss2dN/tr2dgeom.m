%**********************************************************************

function [ML,MN,V,eldaC] = tr2dgeom(e,ec,eldaC);

  x1 = ec(1,1); y1 = ec(1,2); x2 = ec(2,1); y2 = ec(2,2);

  l    = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
  s    = (y2-y1)/l; 
  c    = (x2-x1)/l;

  ML  = [  c*c  c*s -c*c -c*s 
           c*s  s*s -c*s -s*s
          -c*c -c*s  c*c  c*s 
          -c*s -s*s  c*s  s*s ];

  MN  = [  s*s -c*s -s*s  c*s 
          -c*s  c*c  c*s -c*c
          -s*s  c*s  s*s -c*s 
           c*s -c*c -c*s  c*c ];

  V   = [ -c -s c s ]';

  eldaC(e,1:3)   = [s c l]; 

%**********************************************************************
