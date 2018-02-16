%
% Universidad de Costa Rica
% Escuela de Ing Eléctrica
% IE0431 Sistemas de Control
%
% Emilio Javier Rojas Álvarez
% Moises Campos
% Sara Daniela Diaz Marin
%

% Se limpia el área de trabajo
clear 
clc

% Se inicia la variable compleja s
s=tf('s');

% Se inicia un vector de tiempo
t_inicial=0; % segundos
t_final=2000; % segundos
t_pasos=1000; % cantidad de elementos
t=t_inicial:1/t_pasos:t_final; % vector de tiempo

% El proceso real para el nivel de una columna de destilación calefactada
ps=-2*(-0.25*s+1)/(s*(0.5*s+1))

% Se simula el proceso ante una entrada escalón
r_escalon=1+0*t;
figure('rend','painters','pos',[5 5 400 400])
salida=lsim(ps,r_escalon,t);
plot(t,r_escalon,'k--', t,salida,'k')
title('Respuesta al Escalón Unitario');
ylabel('Nivel [m]');
xlabel('Tiempo [s]');
xlim([0 t_final]);
legend('r(t)','y(t)','Location','northeast','Orientation','vertical');
saveas(gcf,'img/proceso_real_escalon.eps','epsc');

% figure('rend','painters','pos',[5 5 400 400])
hold on

opt = balredOptions('Offset',.1,'StateElimMethod','Truncate');
% Compute second-order approximation
rsys = -2.15*exp(-0.05*s)/(s*(s+1.1))
modsim=lsim(rsys,r_escalon,t);
plot(t,modsim);



% h=1;
% [rele,t]=gensig('square',2,10-0.5,0.001);
% rele=-h+2*h*rele(t>0.5);
% t=t(t<t(end)-0.5);
% releaux=t>0.499;
% rele=h+rele-releaux;
% 
% figure('rend','painters','pos',[5 5 400 400])
% salida=lsim(ps,rele,t);
% 
% a=(max(salida)-min(salida))/2
% plot(t,rele,'k--', t,salida,'k');
% % xlim([0 4])
% ylabel('Nivel [m]')
% xlabel('Tiempo [s]')
% 
% 
% figure('rend','painters','pos',[5 5 400 400])
% plot(t,rele,'k--', t,salida,'k')
% xlim([1980 2000])
% ylabel('Nivel [m]')
% xlabel('Tiempo [s]')
% 
% 
% control=1+10*exp(-t)+10*exp(-2*t)-10*exp(0.0001*t);
% salida=lsim(ps,control,t);
% figure('rend','painters','pos',[5 5 400 400])
% plot(t,control,'k--', t,salida,'k');
% xlim([0 20])
% ylabel('Nivel [m]')
% xlabel('Tiempo [s]')




% Prueba de lazo cerrado
