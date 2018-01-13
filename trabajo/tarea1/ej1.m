%
% Universidad de Costa Rica
% Escuela de Ing Eléctrica
% IE0431 Sistemas de Control
% Emilio Javier Rojas Álvarez

A=5;
g=9.81;
Hmin=2.5;
Hmax=3.5;
Htyp=3;
Kvs=0.001;
Xvsmin=0.4;
Xvstyp=0.5;
Xvsmax=0.6;
p=1475;

% Vector qe
rangemin=0;%0.07;
rangemax=0.14;
steps=10000;
qe=rangemin:(rangemax-rangemin)/steps:rangemax;

y1=(qe/(Xvsmin*Kvs)).^2/(p*g);
y2=(qe/(Xvstyp*Kvs)).^2/(p*g);
y3=(qe/(Xvsmax*Kvs)).^2/(p*g);

ymin=Hmin+0*qe;
ytyp=Htyp+0*qe;
ymax=Hmax+0*qe;

% h=(qe/{xvs*kvs})^2/(pg)
% =>
% qe=xvs*kvs*sqrt(p*g*h)
Qemin=Xvsmin*Kvs*sqrt(p*g*Hmin)
Qemax=Xvsmax*Kvs*sqrt(p*g*Hmax)

figure
plot(qe,y1,qe,y2,qe,y3,qe,ymin,qe,ymax,qe,ytyp)


ylim([2.4,3.6])
xlim([0.07,0.14])
title('Característica Estática')
ylabel('Nivel')
xlabel('Caudal de Entrada')
legend('y_{x_{vs}min}=','y_{x_{vs}typ}', 'y_{x_{vs}max}','Location','northwest','Orientation','horizontal')
saveas(gcf,'ej1-caracteristicaestaticazoom','epsc')

ylim([0,3.6])
xlim([0,0.14])
title('Característica Estática')
ylabel('Nivel')
xlabel('Caudal de Entrada')
saveas(gcf,'ej1-caracteristicaestatica','epsc')
exit