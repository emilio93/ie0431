g=5;

kp=pi()^2/(log(0.15))^2+1

t=0:1/100:8;


zeta=1/sqrt(kp);
omegan=sqrt(kp);

%tiempo al pico
tp=pi()/(omegan*sqrt(1-zeta^2))
tp=pi()/(omegan*sqrt(1-zeta^2))+0*t;


u=g+0*t;
max=g*1.15+0*t;
u2pmax=g*1.02+0*t;
u2pmin=g*0.98+0*t;
s=tf('s'); sys=kp/(s^2+2*s+kp);

% tiempo de retardo
tr=(1.1+0.125*zeta+0.469*zeta^2)/(omegan)
tr=tr+0*t;

% tiempo de levantamiento
tl=(1-0.4167*zeta+2.917*zeta^2)/(omegan)
tl=(1-0.4167*zeta+2.917*zeta^2)/(omegan)+0*t;
klmin=0.1*g+0*t;
klmax=0.9*g+0*t;

figure('rend','painters','pos',[10 10 600 300])

lsim(sys,u,t,'b-')
hold on
title('Respuesta del sistema a un escalón')
ylabel('Amplitud')
xlabel('Tiempo')

xlim([0 5.5])
ylim([0 6])

plot(t,u,'r-', t,max,'B--', t,u2pmax,'k--' , tp,t,'b-.', tr,t,'k-', t,klmin,'k-.', t,klmax,'k-.', t,(2.5+0*t),'k-', t,u2pmin,'k--')

legend('Respuesta y(s)','Entrada r(s)','Sobrepaso máximo','Banda 2%','Tiempo al pico', 'Tiempo de retardo','90% de r(s)','10% de r(s)', 'Location','east')
saveas(gcf, 'img/ej1-1.eps','epsc');

legend('Respuesta y(s)','Entrada r(s)','Sobrepaso máximo','Banda 2%', 'Tiempo al pico','Location','northeast')
xlim([1.75 4.25])
ylim([4.8 5.8])
saveas(gcf, 'img/ej1-2.eps','epsc');