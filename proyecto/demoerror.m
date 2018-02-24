clear 
clc

s=tf('s');

t=0:1/1000:5;

ps=-2*(-0.25*s+1)/(s*(0.5*s+1));

psm=-2.1*(-0.24*s+1)/(s*(0.4*s+1));

escalon=heaviside(t);

proceso=lsim(ps,escalon,t);
modelo=lsim(psm,escalon,t);
errormodelo=modelo-proceso;
errorabs=(modelo-proceso);

iae=trapz(errorabs)
ise=trapz(errormodelo.^2)

figure('rend','painters','pos',[5 5 400 400])
title('Error del Modelo')
hold on
plot(t,errormodelo,'k')
plot(t,0*t,'k:')
legend('error','0')