%test_fun_nyquist
%
%prueba de las funciones para dibujar el diagrama de Nyquist
% nyquist de Matlab, fc_nyquist y nyqlog de
% Trond Andresen/ Department of Engineering Cybernetics, 
% The Norwegian University of Science and Technology
%
clear
s=tf('s');
%
%funciones de transferencia de lazo abierto
l1=1/((s+1)*(2*s+1));
l2=0.1/(s*(s+1)*(2*s+1));
l3=5/(s*(s+1)*(2*s+1));
l4=0.1*(10*s+1)/(s^2*(s+1));
l5=2*(s+1)/(s^2*(10*s+1));
l6=5*(s+1)/(s*(s-1));
%
% nyquist
figure(1)
subplot(2,3,1),nyquist(l1)
subplot(2,3,2),nyquist(l2)
subplot(2,3,3),nyquist(l3)
subplot(2,3,4),nyquist(l4)
subplot(2,3,5),nyquist(l5)
subplot(2,3,6),nyquist(l6)
%
% fc_nyquist
figure(2)
subplot(2,3,1),fc_nyquist(l1)
subplot(2,3,2),fc_nyquist(l2)
subplot(2,3,3),fc_nyquist(l3)
subplot(2,3,4),fc_nyquist(l4)
subplot(2,3,5),fc_nyquist(l5)
subplot(2,3,6),fc_nyquist(l6)
%
% nyqlog
figure(3)
subplot(2,3,1),nyqlog(l1)
subplot(2,3,2),nyqlog(l2)
subplot(2,3,3),nyqlog(l3)
subplot(2,3,4),nyqlog(l4)
subplot(2,3,5),nyqlog(l5)
subplot(2,3,6),nyqlog(l6)
