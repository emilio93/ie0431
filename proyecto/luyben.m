clear
clc

ymin=-.09453;
t1=0.2028;
t2=0.4371;
parameters=[ymin t1 t2];

xo=[1 1 1]';

options=optimset('MaxFunEvals',10000);


[x, fval]=fsolve(@inverse,xo,options,parameters);
kp=x(1,1);
tau1=x(2,1);
tau2=x(3,1);

syms kp tau1 tau2
u=1;
eq1 = ymin == u*kp*(t1-tau1-tau2+(tau1+tau2)*exp(-t1/tau2));
eq2 = 0 == u*kp*(1-((tau1+tau2)/tau2)*exp(-t1/tau2));
eq3 = 0 == u*kp*(t2-tau1-tau2+(tau1+tau2)*exp(-t1/tau2));
sols=solve(eq1,eq2,eq3)

kp=double(sols.kp)
tau1=double(sols.tau1)
tau2=double(sols.tau2)

s=tf('s');

ps=-2*(-0.25*s+1)/s/(0.25*s+1)
kp=kp;
modelo=-kp*(-tau1*s+1)/s/(tau2*s+1)

t=0:1/1000:3;
escalon=-heaviside(t);

figure
lsim(ps,escalon,t)
hold on
lsim(modelo,escalon,t)
legend('ps','modelo')
function f=inverse(x,parameters)
    kp=x(1,1);
    tau1=x(2,1);
    tau2=x(3,1);
    ymin=parameters(1);
    t1=parameters(2);
    t2=parameters(3);
    f(1,1)=ymin-kp*(t1-tau1-tau2+(tau1+tau2)*exp(-t1/tau2));
    f(2,1)=1-(tau1+tau2)*(exp(-t1/tau2))/tau2;
    f(3,1)=t2-tau1-tau2+(tau1+tau2)*(exp(-t2/tau2))/tau2;
end
    
    