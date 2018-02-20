clear 
clc

s=tf('s');
t=0:1/10:2500;

k=2.5;
l=3.5;

tc=[l*(1-0.15)
    l*(1-0.30)
    l*(1-0.60)];

kp=[(2*tc(1)+l)/(k*(tc(1)+l)^2)
    (2*tc(2)+l)/(k*(tc(2)+l)^2)
    (2*tc(3)+l)/(k*(tc(3)+l)^2)];

ti=[(tc(1)^2) / (1/(kp(1)*k)-l)
    (tc(2)^2) / (1/(kp(2)*k)-l)
    (tc(3)^2) / (1/(kp(3)*k)-l)];

beta=[tc(1) / (2*tc(1)+l)
      tc(2) / (2*tc(2)+l)
      tc(3) / (2*tc(3)+l)];

ps=k*exp(-l*s)/s;

cys=[kp*(ti(1)*s+1) / (ti(1)*s)
     kp*(ti(2)*s+1) / (ti(2)*s)
     kp*(ti(3)*s+1) / (ti(3)*s)];

crs=[kp(1)*(beta(1)*ti(1)*s+1)/(ti(1)*s)
     kp(2)*(beta(2)*ti(2)*s+1)/(ti(2)*s)
     kp(3)*(beta(3)*ti(3)*s+1)/(ti(3)*s)];

 cs=[crs(1)-cys(1)
     crs(2)-cys(2)
     crs(3)-cys(3)];
 
%
% FT de salida respecto a disturbios esperada
%
    kyd=[ti(1)/kp(1)
         ti(2)/kp(2)
         ti(3)/kp(3)];

    mydt=[kyd(1) * s * exp(-l*s) / (tc(1) * s + 1)^2
          kyd(2) * s * exp(-l*s) / (tc(2) * s + 1)^2
          kyd(3) * s * exp(-l*s) / (tc(3) * s + 1)^2];

%
% FT con controlador implementado
%
    myd = [ps / (1+ps*cys(1))
           ps / (1+ps*cys(2))
           ps / (1+ps*cys(3))];

    myr = [(ps*crs(1)) / (1+ps*cys(1))
           (ps*crs(2)) / (1+ps*cys(2))
           (ps*crs(3)) / (1+ps*cys(3))];
%
% Salida del controlador u
%

ud = [-cys(1)*ps/(1+cys(1)*ps)
      -cys(2)*ps/(1+cys(2)*ps)
      -cys(3)*ps/(1+cys(3)*ps)];
  
ur = [crs(1)/(1+cys(1)*ps)
      crs(2)/(1+cys(2)*ps)
      crs(3)/(1+cys(3)*ps)];

%%%%%%%%%%
% Entradas
%
    kr=1; % valor inicial de la referencia
    kd=0.01; % valor inicial de la perturbacion

    pr=.15; % porcentaje de cambio en r
    pd=.10; % porcentaje de cambio en d

    t1=20;  % inicio de r
    t2=300; % inicio de d
    t3=600; % cambio en r
    t4=1000; % cambio en d

    % Referencia
    r=kr*heaviside(t-t1) - kr*heaviside(t-t3) + (1+pr)*kr*heaviside(t-t3);
    % Disturbios
    d=kd*heaviside(t-t2) - kd*heaviside(t-t4) + (1+pd)*kd*heaviside(t-t4);

%%%%%%%%%%%%%%
% Simulaciones
%
    % target
    x=lsim(myr,r,t);
    x=x+lsim(mydt,d,t);

    % diseño
    y=lsim(myr,r,t);
    y=y+lsim(myd,d,t);
    
    uds=lsim(ur, r, t);
    uds=uds+lsim(ud, d, t);
%%%%%%%%%%
% Imagenes
%
    % Respuesta deseada
    figure('rend','painters','pos',[5 5 600 400])
    title('Respuesta deseada ante cambios en referencia y perturbaciones')
    hold on
    plot(t,y)
    plot(t,r,'k-.')
    plot(t,d,'k--')
    xlim([0 650])
    legend('15%','30%','60%', 'referencia', 'disturbios', 'Location','southeast')
    saveas(gcf, '1-yst.eps','epsc')
    
    % Respuesta obtenida
    figure('rend','painters','pos',[5 5 600 400])
    title('Respuesta ante cambios en referencia y perturbaciones')
    hold on
    plot(t,x)
    plot(t,r,'k-.')
    plot(t,d,'k--')
    xlim([0 650])
    legend('15%','30%','60%', 'referencia', 'disturbios', 'Location','southeast')
    saveas(gcf, '1-ys.eps','epsc')
    
    % Salida del controlador
    figure('rend','painters','pos',[5 5 600 400])
    title('Salida del controlador ')
    hold on
    plot(t,uds)
    plot(t,r/10,'k-.')
    plot(t,d/10,'k--')
    xlim([0 650])
    legend('15%','30%','60%', 'referencia', 'disturbios', 'Location','southwest')
    saveas(gcf, '1-us.eps','epsc')
