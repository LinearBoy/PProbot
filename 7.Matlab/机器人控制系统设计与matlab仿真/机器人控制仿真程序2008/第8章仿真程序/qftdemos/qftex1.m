% QFTEX1 Main Example.

% Author: Y. Chait
% 10/10/94
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

clc
clear
echo on

% Example #1 (main example) is used in the manual to describe in great
% detail the application of QFT (including use of relevant toolbox functions)
% to a feedback design problem with a parametrically uncertain plant and
% several robust performance specifications.

% Please refer to manual for more details....

% Strike any key to advance from one plot to another....
pause % Strike any key to continue
clc

%	Consider a continuous-time, siso, negative unity feedback system

%                                   |V(s)            |D(s)
%                         ----      |      ----      |
%             ---->x---->|G(s)|---->x---->|P(s)|---->x---->
%             R(s) |      ----             ----        | Y(s)
%                  |               --                  |
%                  ---------------|-1|------------------
%                                  --

%       The plant P(s) has parametric a uncertainty model:
%	           |      k                                   |
%	   P(s)  = { ----------- :    k in [1,10], a in [1,5] }
%	           | (s+a) (s+b)      b in [20,30]            |

pause % Strike any key to continue
clc

%	The performance specifications are: design a controller
%       G(s) such that it achieves

%  1) Robust stability

%  2) Robust margins (via closed-loop magnitude peaks)
%         | P(jw)G(jw) |
%         |------------| < 1.2,  w>0
%         |1+P(jw)G(jw)|

%  3) Robust output disturbance rejection
%         |Y(jw)|       |(jw)^3+64(jw)^2+748(jw)+2400|
%         |-----| < 0.02|----------------------------|, w<10
%         |D(jw)|       |    (jw)^2+14.4(jw)+169     |

%  4) Robust input disturbance rejection
%         |Y(jw)|
%         |-----| < 0.01, w<50
%         |V(jw)|
%

pause % Strike any key to continue
echo off
clc

% PROBLEM DATA

% compute the boundary of the plant templates
disp('Computing plant templates (40 points at 4 frequencies)....')
drawnow

c = 1; k = 10; b = 20;
for a = logspace(log10(1),log10(5),10),
 nump(c,:) = k;  denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
k = 1; b = 30;
for a = logspace(log10(1),log10(5),10),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = 30; a = 5;
for k = logspace(log10(1),log10(10),10),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = 20; a = 1;
for k = logspace(log10(1),log10(10),10),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
nompt = 21;  % define nominal plant case

% Compute responses
w = [.1,5,10,100];
P=freqcp(nump,denp,w);

disp(' ')
disp('plottmpl(w,w,P,nompt); %show templates')
drawnow
plottmpl(w,w,P,nompt), title('Plant Templates')
qpause;close(gcf);

% BOUNDS
disp(' ')
disp('Computing bounds...')
disp(' ')
disp('bdb1=sisobnds(1,w,wbd1,W1,P,R,nompt); %margins')
drawnow
R=0;
wbd1 = [.1,5,10,100]; % compute bounds at all frequencies in w
W1 = 1.2;  % define weight
bdb1 = sisobnds(1,w,wbd1,W1,P,R,nompt);
disp('plotbnds(bdb1); %show bounds')
drawnow
plotbnds(bdb1),title('Robust Margins Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb2=sisobnds(2,w,wbd2,W2,P,R,nompt); %output disturbance rejection')
drawnow
wbd2=[.1,5,10]; % the frequency array
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],w));% weight computed at w
bdb2 = sisobnds(2,w,wbd2,W2,P,R,nompt);
disp('plotbnds(bdb2); %show bounds')
drawnow
plotbnds(bdb2),title('Robust Output Disturbance Rejection Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb3=sisobnds(3,w,wbd3,W3,P,R,nompt); %input disturbance rejection')
drawnow
wbd3=[.1,5,10]; % the frequency array
W3 = 0.01;% define weight
bdb3 = sisobnds(3,w,wbd3,W3,P,R,nompt);
disp('plotbnds(bdb3); %show bounds')
plotbnds(bdb3),title('Robust Input Disturbance Rejection Bounds');
qpause;close(gcf);

disp(' ')
disp('bdb=grpbnds(bdb1,bdb2,bdb3); %grouping bounds')
drawnow
bdb=grpbnds(bdb1,bdb2,bdb3);
disp('plotbnds(bdb); %show all bounds')
plotbnds(bdb),title('All Bounds');
qpause;close(gcf);

disp(' ')
disp('ubdb=sectbnds(bdb); %intersect bounds')
drawnow
ubdb=sectbnds(bdb);
disp('plotbnds(ubdb); show bounds')
drawnow
plotbnds(ubdb),title('Intersection of Bounds');
qpause;close(gcf);

% DESIGN
disp(' ')
disp('Design')
disp('lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0); %loop shaping')
disp(' ')
disp('There are two possible controllers here:')
disp(' ')
disp('            379*(s/42 + 1) ')
disp('  1)     --------------------    strictly proper ')
disp('         s^2/247^2+ s/247 + 1 ')
disp(' ')
disp('           379*(s/42 + 1) ')
disp('  2)       -----------------     proper ')
disp('              s/165 + 1 ')
disp(' ');
disp('  3)     Following Example 1 (Chapter 4) in manual');
disp(' ');
ans=input('Enter your choice (1,2, or 3) ==>  ');
nc0=379*[1/42,1];dc0=[1/247^2,1/247,1];
if ans==2, nc0=379*[1/42,1];dc0=[1/165,1];
elseif ans==3, nc0=1; dc0=1; end
wl = logspace(-2,3,100);  % define a frequency array for loop shaping
nL0=nump(nompt,:); dL0=denp(nompt,:);
del0=0; % no delay
lpshape(wl,ubdb,nL0,dL0,del0,nc0,dc0);
qpause;
numC=nc0; denC=dc0;

% ANALYSIS
disp(' ')
disp('Analysis....')
disp('Re-define a more dense plant template (100 points)....')
drawnow

% redfine a more dense plant template boundary
c = 1; k = 10; b = 20;
for a = logspace(log10(1),log10(5),25),
 nump(c,:) = k;  denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
k = 1; b = 30;
for a = logspace(log10(1),log10(5),25),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = 30; a = 5;
for k = logspace(log10(1),log10(10),25),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end
b = 20; a = 1;
for k = logspace(log10(1),log10(10),25),
 nump(c,:) = k; denp(c,:) = [1,a+b,a*b];  c = c + 1;
end

P=freqcp(nump,denp,wl);
G=freqcp(numC,denC,wl);

disp(' ')
disp('chksiso(1,wl,W1,P,R,G); %margins spec')
drawnow
chksiso(1,wl,W1,P,R,G);
qpause;close(gcf);

disp(' ')
disp('chksiso(2,wl,W2,P,R,G); %output disturbance rejection spec')
drawnow
ind=find(wl<=10);
W2=abs(freqcp(0.02*[1,64,748,2400],[1,14.4,169],wl));
chksiso(2,wl(ind),W2(ind),P(:,ind),R,G(ind));
qpause;close(gcf);

disp(' ')
disp('chksiso(3,wl,W3,P,R,G); %input disturbance rejection spec')
drawnow
chksiso(3,wl(ind),W3,P(:,ind),R,G(ind));
qpause;close(gcf);
