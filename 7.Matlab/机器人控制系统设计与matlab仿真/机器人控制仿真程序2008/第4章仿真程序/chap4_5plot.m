close all;

figure(1);
subplot(211);
plot(t,yd1(:,1),'r',t,y(:,1),'b');
xlabel('time(s)');ylabel('Position tracking for Link 1');
subplot(212);
plot(t,yd1(:,2),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Speed tracking for Link 1');

figure(2);
subplot(211);
plot(t,yd2(:,1),'r',t,y(:,3),'b');
xlabel('time(s)');ylabel('Position tracking for Link 2');
subplot(212);
plot(t,yd2(:,2),'r',t,y(:,4),'b');
xlabel('time(s)');ylabel('Speed tracking for Link 2');

figure(3);
subplot(211);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input of Link1');
subplot(212);
plot(t,u(:,2),'r');
xlabel('time(s)');ylabel('Control input of Link2');