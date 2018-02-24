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
lambda=1;

% variable compleja
s=tf('s');

% tiempo
    t_inicial=0;
    t_final=4;
    t_pasos=100;
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
    k     = -2;
    theta = 0;
    p     = 0.25;
    t1    = 1000; % se escoge t1 alto para aproximar
                  % a respuesta integrante en el 
                  % modelo
    t2    = -0.5;
    
    ps = k*(-p*s+1)/(s*(-t2*s+1))
    psm = (k*t1)*(-p*s+1)*exp(-theta*s)/(-t1*t2*(-s+1/t1)*(-s+1/t2))
    
%     figure('rend','painters','pos',[0 0 800 800])
%     lsim(ps, escalon, t)
%     hold on
%     lsim(psm, escalon, t)
%     legend('original','modelo');

% Formula 10
    % Obteniendo valores de 
    % z1 z2 z3
    z3=(t1-t2)*(t1-p)*(t2-p);

    z1=   +t1*t2*(t1-t2)*(t1-p)*(t2-p);
    z1=z1 -exp(theta/t1)*(t1^2)*(t1+p)*(t2-p)*t2;
    z1=z1 +exp(theta/t2)*(t2^2)*(t2+p)*(t1-p)*t1;

    z2=   -(t1+t2)*(t1-t2)*(t1-p)*(t2-p);
    z2=z2 +exp(theta/t1)*(t1^2)*(t1+p)*(t2-p);
    z2=z2 -exp(theta/t2)*(t2^2)*(t2+p)*(t1-p);
    
% Formula 16
    % Obteniendo valores de 
    % alfa1 alfa2
    xx= z3*(p/t1+1) * ((lambda/t1+1)^4) * exp(theta/t1);
    xx=xx/( (z1/((t1)^2) + z2/t1 + z3) * (1 + p/t1));
    
    yy=z3*(p/t2+1)*((lambda/t2+1)^4)*exp(theta/t2);
    yy=yy/((z1/t2^2 + z2/t2 + z3) * (1 - p/t2));
    
    1/(t1^2 * t2^2)
    1/(t1^2 * t2^2)
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

% Formula 12
    % Controlador imc
    Qcs = (t1*s-1)*(t2*s-1)*(z1*s^2+z2*s+z3)*(alfa2*s^2+alfa1*s+1);
    Qcs = Qcs/(k*z3*(p*s+1)*(lambda*s+1)^4)

% Formula 21
    % un pi...monton de formulas
    


















