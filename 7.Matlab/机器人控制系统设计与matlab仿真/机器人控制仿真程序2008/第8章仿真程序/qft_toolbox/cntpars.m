function cont = cntpars(num,den,T)
% CNTPARS Parse controller. (Utility Function)
%         CNTPARS takes a transfer function and determine the D.C. gain
%         (K), real and complex poles, and real and complex zeros. This
%         information is then stored in what is called the controller
%         matrix. The controller matrix is used by all the IDEs.

% Author: Craig Borghesani
% Date: 9/3/93
% Revised: 2/17/96 9:31 AM V1.1 updates
% Copyright (c) 1995-98 by The MathWorks, Inc.
%       $Revision: 1.4 $

% Because all the CAD functions use this function, the following code
% detemines whether it is a continuous or discrete CAD function
% calling.  T=[] in all the continuous CAD environments

%%%%%% V5 change to accomodate nargin change
nargval = nargin;

if nargval==3,
 if ~length(T),
  nargval=2;
 end
end

% seperate numerator and denominator into real and complex zeros and poles
num_rts=roots(num);
den_rts=roots(den);

q=1;
% obtain D.C. gain (K) of controller

cont(1,1:4)=[NaN NaN NaN 0];
if nargval==2,
 n=find(num~=0); d=find(den~=0);
 if ~length(n) | (~length(d)), error('Num or Den cannot be zero'); end
 cont(1,1:4)=[num(n(length(n)))/den(d(length(d))) NaN NaN 0];
 cont(2,1:4)=[0 NaN NaN 0.7]; c=2;
else
 cont(1,1:4)=[1 NaN NaN 0];
 cont(2,1:4)=[0 0 NaN 0.5];
 cont(3,1:4)=[0 NaN NaN 0.6]; c=3;
end

% separate and store poles and zeros
delays=0;preds=0;nsum=1;dsum=1;
while q<=length(num_rts),
 c=c+1;
 if imag(num_rts(q))==0,
  if nargval==3 & abs(num_rts(q)-1)>1e-10,
   nsum=nsum*(1-num_rts(q));
   if num_rts(q)~=0,
    num_rts(q)=log(num_rts(q))/T;
   end
  end
  cont(c,1:4)=[-num_rts(q) NaN NaN 2];
  q=q+1;
 else
  if nargval==3,
   num_rts(q)=log(num_rts(q))/T;
  end
  re=real(num_rts(q)); im=imag(num_rts(q));
  wn=sqrt(re^2+im^2); zta=-re/wn;
  cont(c,1:4)=[zta wn NaN 4]; q=q+2;
  if nargval==3,
   a=zta*wn; b=wn*sqrt(1-zta^2);
   nsum=nsum*(1-2*exp(-a*T)*cos(b*T)+exp(-2*a*T));
  end
 end
end
q=1;
while q<=length(den_rts),
 c=c+1;
 if imag(den_rts(q))==0,
  if nargval==3 & abs(den_rts(q)-1)>1e-10,
   dsum=dsum*(1-den_rts(q));
   if den_rts(q)~=0,
    den_rts(q)=log(den_rts(q))/T;
   end
  end
  cont(c,1:4)=[-den_rts(q) NaN NaN 1];
  q=q+1;
 else
  if nargval==3,
   den_rts(q)=log(den_rts(q))/T;
  end
  re=real(den_rts(q)); im=imag(den_rts(q));
  wn=sqrt(re^2+im^2); zta=-re/wn;
  cont(c,1:4)=[zta wn NaN 3]; q=q+2;
  if nargval==3,
   a=zta*wn; b=wn*sqrt(1-zta^2);
   dsum=dsum*(1-2*exp(-a*T)*cos(b*T)+exp(-2*a*T));
  end
 end
end

% if discrete, determine the number of integrators
if nargval==3,
 y=find(abs(1+cont(:,1))<1e-10 & cont(:,4)==1); cont(y,:)=[];
 x=find(cont(:,1)==0 & cont(:,4)==2);
 yl=length(y);
 if yl,
  if length(x), cont(x(1),:)=[];
  else delays=delays+1; end
  if yl==3,
   x=find(-cont(:,1)==-1 & cont(:,4)==2);
   if length(x), cont(x,:)=[];
   else cont=[cont; -1 NaN NaN 1]; end
  elseif yl>3,
   error('Cannot have more than 3 integrators');
  end
 end
 yy=find(abs(1+cont(:,1))<1e-10 & cont(:,4)==2); cont(yy,:)=[];
 x=find(cont(:,1)==0 & cont(:,4)==1);
 yyl=length(yy);
 if yyl,
  if length(x), cont(x(1),:)=[];
  else preds=preds+1; end
  if yyl==3,
   x=find(cont(:,1)==-1 & cont(:,4)==1);
   if length(x), cont(x,:)=[];
   else cont=[cont; -1 NaN NaN 2]; end
  elseif yyl>3,
   error('Cannot have more than 3 differentiators');
  end
 end
 yd=find(cont(:,1)~=0 & cont(:,4)==1);
 x=find(cont(:,1)==0 & cont(:,4)==2);
 if length(x)>=length(yd), cont(x(1:length(yd)),:)=[];
 elseif length(x)<length(yd),
  delays=length(yd)-length(x)+delays;
  cont(x,:)=[];
 end
 yn=find(cont(:,1)~=0 & cont(:,4)==2);
 x=find(cont(:,1)==0 & cont(:,4)==1);
 if length(x)>=length(yn), cont(x(1:length(yn)),:)=[];
 elseif length(x)<length(yn),
  preds=length(yn)-length(x)+preds;
  cont(x,:)=[];
 end
 yd=find(cont(:,2)~=NaN & cont(:,4)==3);
 x=find(cont(:,1)==0 & cont(:,4)==2);
 if length(x)>=length(yd), cont(x(1:length(yd)),:)=[];
 elseif length(x)<length(yd),
  delays=length(yd)-length(x)+delays;
  cont(x,:)=[];
 end
 yn=find(cont(:,2)~=NaN & cont(:,4)==4);
 x=find(cont(:,1)==0 & cont(:,4)==1);
 if length(x)>=length(yn), cont(x(1:length(yn)),:)=[];
 elseif length(x)<length(yn),
  preds=length(yn)-length(x)+preds;
  cont(x,:)=[];
 end
 x=find(cont(:,1)==0 & cont(:,4)==2);
 xxl=length(x)+preds;
 cont(x,:)=[];
 x=find(cont(:,1)==0 & cont(:,4)==1);
 cont(x,:)=[];
 xl=length(x)+delays;
 cont(2,1)=yl; cont(2,2)=yyl;
 cont(3,1)=xl-xxl;
 n=find(num~=0); d=find(den~=0);
 cont(1,1)=nsum/dsum*num(n(1))/den(d(1));

elseif nargval==2,  % Continuous
 xl=find(cont(:,1)==0 & cont(:,4)==2); cont(xl,:)=[];
 xll=find(cont(:,1)==0 & cont(:,4)==1); cont(xll,:)=[];
 cont(2,1)=length(xll)-length(xl);
end
