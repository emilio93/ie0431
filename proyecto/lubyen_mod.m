%
% Universidad de Costa Rica
% Escuela de Ing Eléctrica
% IE0431 Sistemas de Control
%
% Emilio Javier Rojas Álvarez
% Moises Francisco Campos Zepeda
% Sara Daniela Diaz Marin
%

% Se limpia el área de trabajo
clear 
clc

% Máxima precision de matlab XD
% (probablemente se puede configurar con másn)
format long

% Se inicia la variable compleja s
s=tf('s');

% Se inicia un vector de tiempo
t_inicial=0; % segundos
t_final=0.5; % segundos
t_pasos=1000000;  % cantidad de elementos
t=t_inicial:(t_final-t_inicial)/t_pasos:t_final; % vector de tiempo

% El proceso real para el nivel de una columna de destilación calefactada
ps=-2*(-0.25*s+1)/(s*(0.5*s+1))

% Se simula el proceso ante una entrada escalón
h=1;
r_escalon=h+0*t;

salida=lsim(ps,r_escalon,t);
% salida=awgn(salida, 1, -40); % se agrega ruido

% Equivalente a usar data cursor
% se hallan t1 y t2
    [y_t1,temp1]=max(salida(:));
    
    y_t1=y_t1
    t1=temp1/(t_pasos/(t_final-t_inicial))

    t2 = temp1; % 0 está después del máximo /\
    while t2 <= t_pasos && salida(t2) > 0
       t2 = t2+1;
    end
    y_t2=salida(t2)
    
    t2=(salida(t2-1)*t2-(t2-1)*salida(t2)) / (salida(t2-1)-salida(t2))
    
    t2=t2/(t_pasos/(t_final-t_inicial))
    
figure('rend','painters','pos',[5 5 400 400])
title('Identificación del Modelo')
hold on
xlabel('Tiempo [s]');
xlim([0 0.5]);
ylim([-0.01 0.1])
plot(t,salida)
plot(t,0*t)

% se halla k
t_inicial=0; % segundos
t_final=100; % segundos
t_pasos=1000; % cantidad de elementos
t_paso=(t_final-t_inicial)/t_pasos
t=t_inicial:t_paso:t_final; % vector de tiempo

h=1;
r_escalon=h+0*t;

salida=lsim(ps,r_escalon,t);
k=salida(100/t_paso)-salida(99/t_paso)

syms tau1 tau2 k

eq1 = 1==((tau1+tau2)/(tau2))*exp(-t1/tau2);

eq2 = y_t2==k*t2+k*(tau1+tau2)*exp(-t2/tau2)-k*(tau1+tau2);
eq3 = y_t1==k*t1+k*(tau1+tau2)*exp(-t1/tau2)-k*(tau1+tau2);

sols = solve(eq1,eq2,eq3,'MaxDegree',3);

kk  = sols.k;
tt1 = sols.tau1;
tt2 = sols.tau2;
kk=double(kk)
tt1=double(tt1)
tt2=double(tt2)

% Se inicia un vector de tiempo
t_inicial=0; % segundos
t_final=50; % segundos
t_pasos=10000; % cantidad de elementos
t=t_inicial:(t_final-t_inicial)/t_pasos:t_final; % vector de tiempo

% El proceso real para el nivel de una columna de destilación calefactada
ps=-2*(-0.25*s+1)/(s*(0.5*s+1))

% Se simula el proceso ante una entrada escalón
h=1;
r_escalon=h+0*t;
proceso=lsim(ps,r_escalon,t);

psm=kk*(-tt1*s+1)/(s*(tt2*s+1))
modelo=lsim(psm,r_escalon,t);

figure('rend','painters','pos',[5 5 400 400])
title('Identificación del Modelo')
hold on
xlabel('Tiempo [s]');
xlim([0 4]);
plot(t,proceso,'b--')
plot(t,modelo,'k')
plot(t,0*t,'k:')
legend('proceso','modelo')

figure('rend','painters','pos',[5 5 400 400])
title('Error del Modelo')
hold on
xlabel('Tiempo [s]');
xlim([0 4]);
plot(t,proceso-modelo,'k')
plot(t,0*t,'k:')
legend('error')

% Reestablecer precisión de mátlab
format short