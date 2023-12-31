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
global M

sizes = simsizes;
sizes.NumContStates  = 50;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0.2*ones(50,1)];
str = [];
ts  = [];

M=2;
function sys=mdlDerivatives(t,x,u)
global M

r=0.1*sin(pi*t);
dr=0.1*pi*cos(pi*t);
ddr=-0.1*pi*pi*sin(pi*t);

e=u(1);
de=u(2);

xx(1)=r+e;
xx(2)=dr+de;

alfa=5;
rou=de+alfa*e;
kesi=ddr-alfa*de;

if M==1
	K=1.0;
	R=kesi-K*sign(rou);
elseif M==2
	K=5;
   delta0=0.03;
   delta1=5;
   delta=delta0+delta1*abs(e);
   R=kesi-K*rou/(abs(rou)+delta);
end


for i=1:1:25
    thtaf(i,1)=x(i);
end
for i=1:1:25
    thtag(i,1)=x(i+25);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fsd=0;
for l1=1:1:5
   gs1=-[(xx(1)+pi/6-(l1-1)*pi/12)/(pi/24)]^2;
	u1(l1)=exp(gs1);
end

for l2=1:1:5
   gs2=-[(xx(2)+pi/6-(l2-1)*pi/12)/(pi/24)]^2;
	u2(l2)=exp(gs2);
end

for l1=1:1:5
	for l2=1:1:5
		fsu(5*(l1-1)+l2)=u1(l1)*u2(l2);
		fsd=fsd+u1(l1)*u2(l2);
	end
end

fs=fsu/(fsd+0.001);

fx1=thtaf'*fs';
gx1=thtag'*fs'+0.001;

ut=(-fx1+R)/gx1;

r1=5.0;r2=1;

S1=-r1*rou*fs;
S2=-r2*rou*fs*ut;

for i=1:1:25
    sys(i)=S1(i);
end
for j=26:1:50
    sys(j)=S2(j-25);
end

function sys=mdlOutputs(t,x,u)
global M

r=0.1*sin(pi*t);
dr=0.1*pi*cos(pi*t);
ddr=-0.1*pi*pi*sin(pi*t);

e=u(1);
de=u(2);

xx(1)=r+e;
xx(2)=dr+de;

alfa=5;
rou=de+alfa*e;
kesi=ddr-alfa*de;

if M==1
	K=1.0;
	R=kesi-K*sign(rou);
elseif M==2
	K=5;
   delta0=0.03;
   delta1=5;
   delta=delta0+delta1*abs(e);
   R=kesi-K*rou/(abs(rou)+delta);
end

for i=1:1:25
    thtaf(i,1)=x(i);
end
for i=1:1:25
    thtag(i,1)=x(i+25);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fsd=0;
for l1=1:1:5
   gs1=-[(xx(1)+pi/6-(l1-1)*pi/12)/(pi/24)]^2;
	u1(l1)=exp(gs1);
end

for l2=1:1:5
   gs2=-[(xx(2)+pi/6-(l2-1)*pi/12)/(pi/24)]^2;
	u2(l2)=exp(gs2);
end
 
for l1=1:1:5
	for l2=1:1:5
		fsu(5*(l1-1)+l2)=u1(l1)*u2(l2);
		fsd=fsd+u1(l1)*u2(l2);
	end
end

fs=fsu/(fsd+0.001);

fx1=thtaf'*fs';
gx1=thtag'*fs'+0.001;

ut=(-fx1+R)/gx1;

sys(1)=ut;
sys(2)=fx1;
sys(3)=gx1;