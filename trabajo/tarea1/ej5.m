%
% Universidad de Costa Rica
% Escuela de Ing Eléctrica
% IE0431 Sistemas de Control
% Emilio Javier Rojas Álvarez

s=tf('s');

K=1.15;
T=8.5;
a=0.6;

P=K/(T*s+1)/(a*T*s+1)

pzmap(P)
saveas(gcf,'img/ej5-pzmap-proc','epsc')

kp=4/69
myr1=myr(kp)
figure('rend','painters','pos',[10 10 300 280])
pzmap(myr1)
title(strcat('Diagrama de Polos y Ceros - Caso Kp=',num2str(kp,3)))
ylabel('Eje Imaginario')
xlabel('Eje Real')
saveas(gcf,'img/ej5-pzmap-sis-crit','epsc')

step(myr1)
title(strcat('Respuesta al Escalón Unitario - Caso Kp=',num2str(kp,3)))
ylabel('Amplitud')
xlabel('Tiempo')
saveas(gcf,'img/ej5-step-sis-crit','epsc')

kp=1/25
myr2=myr(kp)
pzmap(myr2)
title(strcat('Diagrama de Polos y Ceros - Caso Kp=',num2str(kp,3)))
ylabel('Eje Imaginario')
xlabel('Eje Real')
saveas(gcf,'img/ej5-pzmap-sis-sub1','epsc')

step(myr2)
title(strcat('Respuesta al Escalón Unitario - Caso Kp=',num2str(kp,3)))
ylabel('Amplitud')
xlabel('Tiempo')
saveas(gcf,'img/ej5-step-sis-sub1','epsc')

kp=50/100
myr3=myr(kp)
pzmap(myr3)
title(strcat('Diagrama de Polos y Ceros - Caso Kp=',num2str(kp,3)))
ylabel('Eje Imaginario')
xlabel('Eje Real')
saveas(gcf,'img/ej5-pzmap-sis-sobre1','epsc')

step(myr3)
title(strcat('Respuesta al Escalón Unitario - Caso Kp=',num2str(kp,3)))
ylabel('Amplitud')
xlabel('Tiempo')
saveas(gcf,'img/ej5-step-sis-sobre1','epsc')

kp=-2
myr4=myr(kp)
pzmap(myr4)
title(strcat('Diagrama de Polos y Ceros - Caso Kp=',num2str(kp,3)))
ylabel('Eje Imaginario')
xlabel('Eje Real')
saveas(gcf,'img/ej5-pzmap-sis-sub2','epsc')

step(myr4)
title(strcat('Respuesta al Escalón Unitario - Caso Kp=',num2str(kp,3)))
ylabel('Amplitud')
xlabel('Tiempo')
saveas(gcf,'img/ej5-step-sis-sub2','epsc')

kp=50
myr5=myr(kp)
pzmap(myr5)
title(strcat('Diagrama de Polos y Ceros - Caso Kp=',num2str(kp,3)))
ylabel('Eje Imaginario')
xlabel('Eje Real')
saveas(gcf,'img/ej5-pzmap-sis-sobre2','epsc')

step(myr5)
title(strcat('Respuesta al Escalón Unitario - Caso Kp=',num2str(kp,3)))
ylabel('Amplitud')
xlabel('Tiempo')
saveas(gcf,'img/ej5-step-sis-sobre2','epsc')

exit

function y = myr(Kp)
  s=tf('s');
  K=1.15;
  T=8.5;
  a=0.6;
  y=K*Kp/(s^2 + (1+a)/(a*T)*s + (1+K*Kp)/(a*T^2))
end