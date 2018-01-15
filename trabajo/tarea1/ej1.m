%
% Universidad de Costa Rica
% Escuela de Ing Eléctrica
% IE0431 Sistemas de Control
% Emilio Javier Rojas Álvarez

A=5;

Hmin=2.5;   Htyp=3;     Hmax=3.5;
Xvsmin=0.4; Xvstyp=0.5; Xvsmax=0.6;

% Caracteristicas estáticas segun distorsión Xvs
y1=qe_h(Xvsmin);
y2=qe_h(Xvstyp);
y3=qe_h(Xvsmax);

% Valores de nivel analizados
ymin=Hmin+0*qe_vec();
ytyp=Htyp+0*qe_vec();
ymax=Hmax+0*qe_vec();

% Valores de cuadales minimos, tipico y máximo según
% la distorsión Xvs y nivel H
Qemin=qe_h_val(Xvsmin,Hmin)
Qetyp=qe_h_val(Xvstyp,Htyp)
Qemax=qe_h_val(Xvsmax,Hmax)

figure

plot(qe_vec(),y1,qe_vec(),y2,qe_vec(),y3,qe_vec(),ymin,qe_vec(),ytyp,qe_vec(),ymax)
title('Característica Estática')
ylabel('Nivel [m]')
xlabel('Caudal de Entrada [m^{3}/s]')
legend('h_{X_{VS}min}(q_e)','h_{X_{VS}typ}(q_e)', 'h_{X_{VS}max}(q_e)','Location','northeastoutside','Orientation','vertical')

ylim([2.4,3.6])
xlim([0.07,0.14])
saveas(gcf,'ej1-caracteristicaestaticazoom','epsc')

ylim([0,3.6])
xlim([0,0.14])
saveas(gcf,'ej1-caracteristicaestatica','epsc')


%
% Bloque de derivadas
%

y1der=qe_der(Xvsmin);
y2der=qe_der(Xvstyp);
y3der=qe_der(Xvsmax);

ydermin=qe_der_val(Xvsmin,Qemax)
ydermin=qe_der_val(Xvsmin,Qemax)+0*qe_vec();

ydertyp=qe_der_val(Xvstyp,Qetyp)
ydertyp=qe_der_val(Xvstyp,Qetyp)+0*qe_vec();

ydermax=qe_der_val(Xvsmax,Qemin)
ydermax=qe_der_val(Xvsmax,Qemin)+0*qe_vec();

figure

plot(qe_vec(),y1der,qe_vec(),y2der,qe_vec(),y3der,qe_vec(),ydermin,qe_vec(),ydertyp,qe_vec(),ydermax)
xlim([Qemin,Qemax])

title('Derivada Característica Estática')
legend('dh_{X_{VS}min}(q_e)/dq_e','dh_{X_{VS}typ}(q_e)/dq_e', 'dh_{X_{VS}max}(q_e)/dq_e','Location','northeastoutside','Orientation','vertical')
saveas(gcf,'ej1-dercaracteristicaestatica','epsc')

exit

%
% Bloque de funciones
%

% Vector qe
function qe = qe_vec()
  rangemin=0;%0.07;
  rangemax=0.14;
  steps=10000;
  qe=rangemin:(rangemax-rangemin)/steps:rangemax;
end

%% Q_e(h) en terminos de Xvs
%
% h=(qe/{xvs*kvs})^2/(pg)
% =>
% qe=xvs*kvs*sqrt(p*g*h)
function y = qe_h(x_vs)
  [g,Kvs,p] = consts();
  y = (qe_vec()/(x_vs*Kvs)).^2/(p*g);
end

%% Q_e(h) evaluado en h
%
function qe = qe_h_val(x_vs,h)
  [g,Kvs,p] = consts();
  qe=x_vs*Kvs*sqrt(p*g*h);
end

function qe = qe_der(x_vs)
  [g,Kvs,p] = consts();
  qe=(2*qe_vec())/(p*g*(x_vs*Kvs)^2);
end

function derqe = qe_der_val(x_vs,qe_val)
  [g,Kvs,p] = consts();
  derqe=(2*qe_val)/(p*g*(x_vs*Kvs)^2);
end

function [g,Kvs,p] = consts()
  g=9.81;
  Kvs=0.001;
  p=1475;
end