close all;

figure(1);
plot(t,x(:,1+3),'r',t,x(:,1)','b','linewidth',2);
grid on;
legend('x','ideal x');
xlabel('time/(s)');ylabel('x');
figure(2);
plot(t,x(:,2+3),'r','linewidth',2);
grid on;
legend('dx');
xlabel('time(s)');ylabel('dx');
figure(3);
plot(t,x(:,3+3),'r',t,x(:,2)','b','linewidth',2);
grid on;
legend('y','ideal y');
xlabel('time(s)');ylabel('y');
figure(4);
plot(t,x(:,4+3),'r','linewidth',2);
grid on;
legend('dy');
xlabel('time(s)');ylabel('dy');
figure(5);
plot(t,x(:,5+3),'r',t,x(:,3)','b','linewidth',2);
grid on;
legend('\theta','ideal \theta');
xlabel('time(s)��');ylabel('\theta');
figure(6);
plot(t,x(:,6+3),'r','linewidth',2);
legend('d \theta');
grid on;
xlabel('time(s)');ylabel('d \theta');
figure(7);
plot(t,ut(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('control input u1');
grid on;
figure(8);
plot(t,ut(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('control input u2');
grid on;