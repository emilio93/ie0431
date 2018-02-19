clear 
clc

s=tf('s');

k=2.5;
l=3.5;

t=0:1/10:3000;

tc=l*(1-0.15);

kp=(2*tc+l)/(k*(tc+l)^2);
ti=(tc^2)/(1/(kp*k)-l);
beta=tc/(2*tc+l);

ps=k*exp(-l*s)/s;
cys=kp*(ti*s+1)/(ti*s);
crs=kp*(beta*ti*s+1)/(ti*s);


%
% Entradas
%
kr=1;
kd=0.01;

t1=20;
t2=300;
t3=600;

% Referencia
r=kr*heaviside(t-t1)-kr*heaviside(t-t2)+1.15*kr*heaviside(t-t2);
% Disturbios
d=kd*heaviside(t-t1)-kd*heaviside(t-t3)+1.1*kd*heaviside(t-t3);


myd=ps/(1+ps*cys);
myr=ps*crs/(1+ps*cys);

y=lsim(myr,r,t);
y=y+lsim(myd,d,t);

figure('rend','painters','pos',[5 5 400 400])
title('Identificación del Modelo')
hold on
plot(t,r,'k--')
plot(t,d,'k-.')
plot(t,y,'k')

