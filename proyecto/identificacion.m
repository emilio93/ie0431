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
format long

% Formato presentacion
set(groot,'defaultLineLineWidth',2);
set(groot,'defaultAxesLineWidth',2);
set(groot,'defaultTextFontSize',10);
c1=[0 0 0.6];
c2=[.7 .3 .3];
get(groot,'factory')

% Se inicia la variable compleja s
s=tf('s');

% Se inicia un vector de tiempo
t_inicial=0; % segundos
t_final=10; % segundos
t_pasos=1000; % cantidad de elementos
t_paso=(t_final-t_inicial)/t_pasos;
t=t_inicial:t_paso:t_final; % vector de tiempo

% El proceso real para el nivel de una columna de destilación calefactada
ps=-2*(-0.25*s+1)/(s*(0.5*s+1))

% Se simula el proceso ante una entrada escalón
h=1;
r_escalon=heaviside(t);

salida=lsim(ps,r_escalon,t);
%salida=awgn(salida, 1, -30); % se agrega ruido

km1=-2;
lm1=0.295;
tm1=exp(1)*(-.3347)/-2;
modelo1 = km1*exp(-lm1*s)/(s*(tm1*s+1))
modsim=lsim(modelo1,r_escalon,t);    
    
asint=transpose(-2*t+1.5);
errorasint=salida-asint;
%errormin=min(abs(errorasint))

figure('PaperPosition',[.25 .25 6 4],'rend','painters','pos',[0 0 500 400])
title('Respuesta de la Planta a una Entrada Escalón')
hold on
ylabel('')
xlabel('Tiempo [s]')
xlim([0 4])
ylim([-7 2])
p0=plot(t,0*t,'k','LineWidth',.25);
p1=plot(t,r_escalon,'k--', 'Color', c1);
p2=plot(t,salida,'k','Color', c2);
% plot(t,modsim,'k-.')
% plot(t,1.5-2*t,'k:')

% line([0.75 0.75], [-5 5],'Color','black','LineStyle',':')


% yyaxis right
% ylabel('Error')
% plot(t,salida-modsim)
%ylim([-0.05 0.15])
legend([p1 p2],'Entrada','Proceso', 'Location', 'southoutside', 'Orientation', 'horizontal')

saveas(gcf,'img/identificacion1.eps','epsc')

salida_en_9 = salida(9/t_paso)
salida_en_10 = salida(10/t_paso)
k_obtenido= salida_en_10 - salida_en_9


% figure('PaperPosition',[.25 .25 8 6],'rend','painters','pos',[20 20 300 200])
% hold on
% title('Error del modelo')
% 
% plot(t,salida-modsim,'k')
% ylim([-0.05 0.15])
% xlim([0 1.75])
% legend('Error')

% %
% % Modelo 1
% % Integrante de 2do orden mas tiempo mierto
% %
% km1=-2;
% lm1=0.295099001;
% tm1=exp(1)*(-.3347)/-2;
% modelo1 = km1*exp(-lm1*s)/(s*(tm1*s+1))
% modsim=lsim(modelo1,r_escalon,t);
% 
% figure('rend','painters','pos',[5 5 400 400])
% title('Respuesta al Escalón Unitario')
% hold on
% ylabel('Nivel [m]');
% xlabel('Tiempo [s]');
% xlim([0 3]);
% % ylim();
% 
% plot(t,r_escalon,'k--')
% 
% plot(t,salida,'Color', [.5 .5 .5])
% plot(t,modsim,'k-.')
% % plot(t,r_escalon-transpose(salida)) % error
% 
% legend('r(t)','p_r(s)','modelo 1','Location','northeast','Orientation','vertical');
% % saveas(gcf,'img/proceso_real_escalon.eps','epsc');
% 
% 
% figure('rend','painters','pos',[5 5 400 400])
% title('Error en los modelos con respecto al tiempo')
% hold on
% ylabel('Error de nivel [m]');
% xlabel('Tiempo [s]');
% xlim([0 t_final]);
% % ylim();
% errormodelo=salida-modsim;
% iae=trapz(abs(errormodelo))
% errorfinal=errormodelo(end)
% plot(t,errormodelo,'k')
% plot(t,0*t,'k:')
% legend('modelo 1','Location','northeast','Orientation','vertical');
% % saveas(gcf,'img/error_modelo_escalon.eps','epsc');
% 
% 
% % Prueba de lazo cerrado
% 
% % Controlador Proporcional
% kp=1;
% cps=kp;
% 
% 
% %function [error, control, manipulada, ]

