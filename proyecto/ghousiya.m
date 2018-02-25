%
% Universidad de Costa Rica
% Escuela de Ing Eléctrica
% IE0431 Sistemas de Control
%
% Emilio Javier Rojas Álvarez
% Moises Francisco Campos Zepeda
% Sara Daniela Diaz Marin
%

%
% Basado en 
% K. Ghousiya Begum
% A. Seshagiri Rao
% T.K. Radhakrishnan
%
% Enhanced IMC based PID controller design for 
% non-minimum phase
% (NMP) integrating processes with time delays
%

% limpiar area de trabajo
% y consola
clear
clc

%
%
% Parametro ajustable del PID
lambda=.85;


% variable compleja
s=tf('s');

% tiempo
    t_inicial=0;
    t_final=75;
    t_pasos=10000;
    t_paso=(t_final-t_inicial)/(t_pasos);

    t=t_inicial:t_paso:t_final;
    
    escalon=heaviside(t);
    


% Planta original
    %
    % G_m=
    %     k * (-p*s+1)
    %     ----------------------------
    %       ((-t1*s + 1)*(-t2*s + 1)) 
    % se modela como un SOMTM Inestable 
    %                    con un cero de 
    %                    fase no minima
    % G_m=
    %     k * exp(-theta*s) * (-p*s+1)
    %     ----------------------------
    %       ((-t1*s + 1)*(-t2*s + 1)) 
    % G_m=
    %     k * exp(-theta*s) * (-p*s+1)
    %     ----------------------------
    %       ((-s + 1/t1)*(-s + 1/t2)) 
    %
    % parametros de la planta original
    
%     k     = -2;
%     theta = 0;
%     p     = 0.25;
%     t2    = -0.5;
%     psm   = k*(-p*s+1)/(s*(-t2*s+1))
% 
%     k     = .547;
%     theta = 0.1;
%     p     = .418;
%     t2    = -1.06;
%     psm = k*(-p*s+1)*exp(-theta*s)/(s*(-t2*s+1))
    
    psm=0.547*(-.418*s+1)*exp(-0.1*s)/(s*(1.06*s+1))
    
    % modelo
    k     = -54.7;
    p     = 0.418;
    theta = 0.1;
    t1    = 100;
    t2    = -1.06;
    
    ps = k*(-p*s+1)*exp(-theta*s)/((t1*s-1)*(t2*s-1))

    
    psmlsim=lsim(psm, escalon, t);
    pslsim=lsim(ps, escalon, t);
    
    figure('rend','painters','pos',[0 0 800 800])
    plot(t,psmlsim)
    hold on
    plot(t,pslsim)
    legend('original','modelo');
    
    Gm = (k*t1)*(-p*s+1)*exp(-theta*s)/(-t1*t2*(-s+1/t1)*(-s+1/t2))
    
    k     = -2;
    theta = 0;
    p     = 0.25;
    t2    = -0.5;
    ps   = k*(-p*s+1)/(s*(-t2*s+1))
    
% Formula 10
    % Obteniendo valores de 
    % z1 z2 z3
    z3=(t1-t2)*(t1-p)*(t2-p);

    z1=   +t1*t2*(t1-t2)*(t1-p)*(t2-p);
    z1=z1 -exp(theta/t1) * (t1^2)*(t1+p)*(t2-p)*t2;
    z1=z1 +exp(theta/t2) * (t2^2)*(t2+p)*(t1-p)*t1;

    z2=   -(t1+t2)*(t1-t2)*(t1-p)*(t2-p);
    z2=z2 +exp(theta/t1) * (t1^2)*(t1+p)*(t2-p);
    z2=z2 -exp(theta/t2) * (t2^2)*(t2+p)*(t1-p);
    
    
    lambda=(theta+p)-3*(theta+p)
% Formula 16
    % Obteniendo valores de 
    % alfa1 alfa2
    xx= z3*(p/t1+1) * ((lambda/t1+1)^4) * exp(theta/t1);
    xx=xx/( (z1/((t1)^2) + z2/t1 + z3) * (1 + p/t1));
    
    yy=z3*(p/t2+1)*((lambda/t2+1)^4)*exp(theta/t2);
    yy=yy/((z1/t2^2 + z2/t2 + z3) * (1 - p/t2));
    

    alfa1=(xx/(t2^2) - yy/(t1^2)) - (1/(t2^2)-1/(t1^2));
    alfa1=alfa1/( 1/(t1 * t2^2) - 1/(t1^2 * t2));
    
    alfa2=(xx/t2 - yy/t1) - (1/t2-1/t1);
    alfa2=alfa2/( 1/(t1^2 * t2) - 1/(t1 * t2^2));

% Formula 11
    % Filtro F(s)
    % 
    % alfa2*s^2 + alfa1*s + 1
    % -----------------------
    %    (lambda*s + 1)^4
    %
    Fs=alfa2*s^2 + alfa1*s + 1;
    Fs=Fs/((lambda*s + 1)^4)

% Formula 12
    % Controlador imc
    Qcs = (t1*s-1)*(t2*s-1)*(z1*s^2+z2*s+z3)*(alfa2*s^2+alfa1*s+1);
    Qcs = Qcs/(k*z3*(p*s+1)*(lambda*s+1)^4);
    
% Formula 17
    Gc=Qcs/(1-Qcs*Gm);

% Formula 21
    % un pi...monton de formulas
    pm0=k;
    
    z4=z2 + alfa1*z3 - p*z3;
    
    z7=z1+alfa1*z2+alfa2*z3-p*z2-p*alfa1*z3;
    z6=z3*z4-theta*z3^2-p*z3^2;
    z5=2*z3*z7-theta*p*z3^2-theta*z3*z4;

    
    z11=alfa1*z1+alfa2*z2-p*z1-p*alfa1*z2-p*alfa2*z3;
    z10=p*z3*z7-p*theta*z3*z4+3*z3*z11-theta*z3*z7;
    z8=2*z10*(z3^2)-theta*(z3^2)*z5-2*p*theta*(z3^2)*z6-2*(p^2)*(z3^2)*z6;
    z9=((z3^2)*z5-theta*(z3^2)*z6-2*p*(z3^2)*z6);
    
    z13=      t1*t2*z3 - t1*z2 - alfa1*t2*z3 - t2*z2 - alfa1*t1*z3
    z13=z13 + z1 + alfa1*z2 + alfa2*z3;

    z12=alfa1*z3+z2-t1*z3-t2*z3;
    
    ppa0=(z4-theta*z3-p*z3)/z3;
    pppa0=(z5-theta*z6-2*p*z6)/(z3^2);
    ppppa0=(z8-theta*z9-4*p*z9)/(z3^4);
    
    d0=4*lambda-ppa0;
    dp0=(12*lambda^2-pppa0)/2;
    dpp0=(24*lambda^3-ppppa0)/3;
    
    ppm0=(k*p*z3-k*z12)/z3; 
    pppm0=(2*k*z12^2-2*k*z3*z13-2*k*p*z3*z12)/z3;
    
    J0   = 1/(pm0 * d0);
    Jp0  = -(ppm0*d0 + pm0*dp0)/((pm0*d0)^2);
    Jpp0 = Jp0 * ((pppm0*d0+2*ppm0*dp0+pm0*dpp0)/(ppm0*d0+pm0*dp0) + 2*Jp0/J0);
    
    kc=Jp0
    ti=Jp0/J0
    td=Jpp0/(2*Jp0)
    
%%%%%%%%%%
% Entradas
%
    kr=0.5; % valor inicial de la referencia
    kd=0.1; % valor inicial de la perturbacion

    pr=.15; % porcentaje de cambio en r
    pd=.10; % porcentaje de cambio en d

    t1=0;  % inicio de r
    t2=15; % inicio de d
    t3=30; % cambio en r
    t4=45; % cambio en d

    % Referencia
    r=kr*heaviside(t-t1) - kr*heaviside(t-t3) + (1+pr)*kr*heaviside(t-t3);
    % Disturbios
    d=kd*heaviside(t-t2) - kd*heaviside(t-t4) + (1+pd)*kd*heaviside(t-t4);

    kc=-0.8446
    ti=2.368 
    td=0.296
    
% Formula 22
    % set point filter
    Frs=(lambda*s+1)/(alfa2*s^2+alfa1*s+1)

    tf=0.001*td;

    Gc=kc*(1+1/(ti*s)+td*s/(tf*s+1));


    myr=ps*Gc/(1+ps*Gc);
    myd=ps/(1+ps*Gc);
    
    myrsim=lsim(myr,r,t);
    myrsim=myrsim+lsim(myd,d,t);
    
    figure('rend','painters','pos',[0 0 800 800])
    plot(t,r)
    hold on
    xlim([0 55])
    plot(t,d)
    plot(t,myrsim);
    
    ud = -Gc*ps/(1+Gc*ps);
    ur = Gc/(1+Gc*ps);
   
    uds=lsim(ud, r, t);
    uds=-(uds+lsim(ud, d, t));
    
    figure('rend','painters','pos',[0 0 800 800])
    plot(t,r)
    hold on
    xlim([0 55])
    plot(t,d)
    plot(t,uds);
    








