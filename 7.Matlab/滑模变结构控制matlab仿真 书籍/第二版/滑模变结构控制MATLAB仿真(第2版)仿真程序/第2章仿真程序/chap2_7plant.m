function dx=Plant(t,x,flag,para)
dx=zeros(2,1);
a=25;b=133;
ut=para(1);
dt=3.0*sin(t);
dx(1)=x(2);  
dx(2)=-a*x(2)+b*ut+dt;