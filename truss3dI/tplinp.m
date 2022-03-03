%**********************************************************************
% tplinp.m : Template input file

clear all;close all;delete('loadincr.m','savedata.m');

crd0 = [% x-cooed   y-coord   z-coord
          xxxx      xxxx      xxxx
];

lok = [% ety   egr   node1  node2
         x     x     x      x
];

figure;plotmesh3([0 0 1 0 0 0 0 0 0],lok,crd0,crd0,[],[],1);
view(40,15);

pp = [% node  dof  value
        x     x    x
];

figure;plotmesh3([0 0 1 0 1 0 0 0 0],lok,crd0,crd0,pp,[],1);
view(40,15);

elda = [% ety  mnr  A0     Gs0    0  E      Gn    0 0 0
          x    11   xxxxxx xxxxxx 0  xxxxx  xxxx  0 0 0
];

nic=1; tr3d;

figure;plotmesh3([10 1 0 0 0 0 0 0 0],lok,crd0,crd,pp,eldaC,1);
view(40,15);

pf = [% node  dof  value
        x     x    xxxx
];

nic=2; tr3d;

figure;plotmesh3([10 1 0 0 0 0 0 0 0],lok,crd0,crd,pp,eldaC,1);
view(40,15);

%**********************************************************************
