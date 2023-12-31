close all;

figure(1);
subplot(211);
plot(t,y(:,1),'r',t,y(:,2),'b:','linewidth',2);
xlabel('time(s)');ylabel('angle tracking');
legend('ideal angle','angle tracking');
subplot(212);
plot(t,cos(t),'r',t,y(:,3),'b:','linewidth',2);
xlabel('time(s)');ylabel('speed tracking');
legend('ideal speed','speed tracking');

figure(2);
subplot(211);
plot(t,u(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input,u');
subplot(212);
plot(t,deltau(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Control input compensation');