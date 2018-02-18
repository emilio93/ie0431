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
t_final=9; % segundos
t_pasos=1000; % cantidad de elementos
t=t_inicial:(t_final-t_inicial)/t_pasos:t_final; % vector de tiempo

% El proceso real para el nivel de una columna de destilación calefactada
ps=-2*(-0.25*s+1)/(s*(0.5*s+1))

% Se simula el proceso ante una entrada escalón
h=1;
r_escalon=h+0*t;

salida=lsim(ps,r_escalon,t);
% salida=awgn(salida, 1, -20); % se agrega ruido

asint=transpose(-2*t+1.5);
errorasint=salida-asint;
errormin=min(abs(errorasint))
figure('rend','painters','pos',[5 5 400 400])
title('Identificación del Modelo')
hold on
ylabel('Nivel [m]');
xlabel('Tiempo [s]');
xlim([0 3]);
ylim([-3 0.5])
plot(t,salida)
plot(t,asint)
plot(t,0*t)
plot(0.75+0*t,-t)

%
% Modelo 1
% Integrante de 2do orden mas tiempo mierto
%
km1=-2;
lm1=0.295099001;
tm1=exp(1)*(-.3347)/-2;
modelo1 = km1*exp(-lm1*s)/(s*(tm1*s+1))
modsim=lsim(modelo1,r_escalon,t);

figure('rend','painters','pos',[5 5 400 400])
title('Respuesta al Escalón Unitario')
hold on
ylabel('Nivel [m]');
xlabel('Tiempo [s]');
xlim([0 3]);
% ylim();

plot(t,r_escalon,'k--')

plot(t,salida,'Color', [.5 .5 .5])
plot(t,modsim,'k-.')
% plot(t,r_escalon-transpose(salida)) % error

legend('r(t)','p_r(s)','modelo 1','Location','northeast','Orientation','vertical');
% saveas(gcf,'img/proceso_real_escalon.eps','epsc');


figure('rend','painters','pos',[5 5 400 400])
title('Error en los modelos con respecto al tiempo')
hold on
ylabel('Error de nivel [m]');
xlabel('Tiempo [s]');
xlim([0 t_final]);
% ylim();
errormodelo=salida-modsim;
errorfinal=errormodelo(end)
plot(t,errormodelo,'k')
plot(t,0*t,'k:')
legend('modelo 1','Location','northeast','Orientation','vertical');
% saveas(gcf,'img/error_modelo_escalon.eps','epsc');


% Prueba de lazo cerrado

% Controlador Proporcional
kp=1;
cps=kp;


%function [error, control, manipulada, ]

