g=5;

kp=pi()^2/(log(0.15))^2+1

t=0:1/1000:8;


zeta=1/sqrt(kp);
omegan=sqrt(kp);

%tiempo al pico
tp=pi()/(omegan*sqrt(1-zeta^2))


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

lsim(sys,u,t)
hold on
plot(t,max, t,u2pmax, t,u2pmin, tr,t, t,klmin, t,klmax, tp,t)
legend('r(s)','Mp','2% Máximo','2%Mínimo','tiempo de retardo','10% r(s)', '90% r(s)','tiempo al pico','Location','northeastoutside')
saveas(gcf, 'img/ej1-1.eps','epsc');
xlim([1.75 4.25])
ylim([4.8 5.8])
saveas(gcf, 'img/ej1-2.eps','epsc');
exit