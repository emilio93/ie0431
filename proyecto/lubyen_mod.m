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
% Se inicia la variable compleja s
s=tf('s');

% Se inicia un vector de tiempo
t_inicial=0; % segundos
t_final=0.5; % segundos
t_pasos=10000000; % cantidad de elementos
t=t_inicial:(t_final-t_inicial)/t_pasos:t_final; % vector de tiempo

% El proceso real para el nivel de una columna de destilación calefactada
ps=-2*(-0.25*s+1)/(s*(0.5*s+1))

% Se simula el proceso ante una entrada escalón
h=1;
r_escalon=h+0*t;

salida=lsim(ps,r_escalon,t);
% salida=awgn(salida, 1, -20); % se agrega ruido


% Equvalente a usar data cursor
% se hallan t1 o t2
    [y_t1,t1]=max(salida(:));
    y_t1=y_t1 % imprimir

    t2 = t1; %can't index at 0
    while t2 <= t_pasos && salida(t2) > 0
       t2 = t2+1;
    end

    t1=t1/(t_pasos/(t_final-t_inicial))

    y_t2=salida(t2)
    t2=t2/(t_pasos/(t_final-t_inicial))
    

% cortey=1.5;
asint=transpose(-2*t+1.5);
% errorasint=salida-asint;
% errorasint=errorasint(end);
% eps=0.000000001
% while (errorasint(end)>eps)
%     if ()
%     asint=transpose(-2*t+1.5);
%     errorasint=salida-asint;
%     errorasint=errorasint(end);
% end

% %errormin=min(abs(errorasint))
% figure('rend','painters','pos',[5 5 400 400])
% title('Identificación del Modelo')
% hold on
% ylabel('Nivel [m]');
% xlabel('Tiempo [s]');
% xlim([0 0.5]);
% ylim([-0.01 0.1])
% plot(t,salida)
% plot(t,asint)
% plot(t,0*t)
% plot(0.75+0*t,-t)


% se halla k
t_inicial=0; % segundos
t_final=100; % segundos
t_pasos=10000; % cantidad de elementos
t_paso=(t_final-t_inicial)/t_pasos
t=t_inicial:t_paso:t_final; % vector de tiempo

h=1;
r_escalon=h+0*t;

salida=lsim(ps,r_escalon,t);
k=salida(100/t_paso)-salida(99/t_paso)

syms tau1 tau2

%eq1 = 1==((tau1+tau2)/(tau2))*exp(-t1/tau2);
eq2 = 0==k*t2+k*(tau1+tau2)*exp(-t2/tau2)-k*(tau1+tau2);
eq3 = y_t1==k*t1+k*(tau1+tau2)*exp(-t1/tau2)-k*(tau1+tau2);

sols = solve(eq2,eq3);

%kk  = sols.k;
tt1 = sols.tau1;
tt2 = sols.tau2;
%kk=double(kk)
tt1=double(tt1)
tt2=double(tt2)

% Se inicia un vector de tiempo
t_inicial=0; % segundos
t_final=5000; % segundos
t_pasos=100000; % cantidad de elementos
t=t_inicial:(t_final-t_inicial)/t_pasos:t_final; % vector de tiempo

% El proceso real para el nivel de una columna de destilación calefactada
ps=-2*(-0.25*s+1)/(s*(0.5*s+1))

% Se simula el proceso ante una entrada escalón
h=1;
r_escalon=h+0*t;
proceso=lsim(ps,r_escalon,t);

psm=k*(-tt1*s+1)/(s*(tt2*s+1))
modelo=lsim(psm,r_escalon,t);

figure('rend','painters','pos',[5 5 400 400])
title('Identificación del Modelo')
hold on
ylabel('Nivel [m]');
xlabel('Tiempo [s]');
xlim([0 50]);
plot(t,proceso,'k--')
plot(t,modelo,'k')
plot(t,0*t,'k:')


legend('proceso','modelo')

figure('rend','painters','pos',[5 5 400 400])
title('Error del Modelo')
hold on
ylabel('Nivel [m]');
xlabel('Tiempo [s]');
xlim([0 5000]);
ylim([-0.01 0.1])
plot(t,proceso-modelo,'k')
plot(t,0*t,'k:')
legend('error','0')