function [sys,x0,str,ts] = spacemodel(t,x,u,flag)

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0.5;0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)
m=1.65;
l=0.28;
D=0.01;
I=1/3*m*l^2;
G=0.52920;

sys(1)=x(2);
sys(2)=-D/I*x(2)+G/I*u;
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);