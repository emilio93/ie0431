clear 
clc
format long
s=tf('s');

t=0:1/1000:10;

ps=-2*(-0.25*s+1)/(s*(0.5*s+1));

% alfaro
psm=-2*exp(-.2950*s)/(s*(0.4549*s+1));

% luyben
psm=-1.999999*(-0.250003*s+1)/(s*(0.500014*s+1));

escalon=heaviside(t);

proceso=lsim(ps,escalon,t);
modelo=lsim(psm,escalon,t);
errormodelo=modelo-proceso;
errorabs=abs(modelo-proceso);

iae=trapz(errorabs(1:4000)/1000)
ise=trapz(errormodelo(1:4000).^2/1000)

iae=trapz(errorabs(1:6000)/1000)
ise=trapz(errormodelo(1:6000).^2/1000)

iae=trapz(errorabs(1:10000)/1000)
ise=trapz(errormodelo(1:10000).^2/1000)



figure('rend','painters','pos',[5 5 400 400])
title('Error del Modelo')
hold on
plot(t,errormodelo,'k')
plot(t,0*t,'k:')
legend('error','0')

format short