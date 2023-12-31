function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 3,
        sys=mdlOutputs(t,x,u);
    case {1,2,4,9},
        sys=[];
    otherwise
        error(['unhandled flag=',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes;
sizes.NumContStates=0;
sizes.NumDiscStates=0;
sizes.NumOutputs=2;
sizes.NumInputs=0;
sizes.DirFeedthrough=0;
sizes.NumSampleTimes=0;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[];
function sys=mdlOutputs(t,x,u)
sys(1)=2;
sys(2)=0.2;