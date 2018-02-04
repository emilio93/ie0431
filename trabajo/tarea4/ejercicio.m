% Emilio Rojas
% 3 2 2018

% Ultimos 4 dígitos del carne
carne = [5 6 8 0];

%
% Pasos iniciales
%
c=carne;
[p q m n]=checkCarne(carne);
disp(strcat('p:',num2str(p)))
disp(strcat('q:',num2str(q)))
disp(strcat('m:',num2str(m)))
disp(strcat('n:',num2str(n)))

s=tf('s');

ps=(m/4)/((p*s+1)*(q*s+1)*(m*s+1)*(n*s+1))

kp=1;
ti=max([p,q,m,n]);
td=min([p,q,m,n]);
disp(strcat('ti:',num2str(ti)))
disp(strcat('td:',num2str(td)))
cs=kp*(1+1/(ti*s))*(1+td*s)

ls=minreal(ps*cs)

disp('Generando LGR...')
kvec=0:1/200:10;
figure
rlocusplot(ls)
saveas(gcf,'rlocusplot1.eps','epsc');
figure
disp('********************************************')
disp('Regla 11: Cruce con el eje imaginario')
disp(' ')
raices=regla11(ls)

disp('********************************************')
disp('Regla 12: Cálculo de la ganancia en un punto del LGR')
disp(' ')

%s1 = input('elija s1 ej 1+1i: ');
%s1
disp('K para cortes con eje imaginario')
[z,ganancia]=zero(ls);
for i=1:1:numel(raices)
  if imag(raices(i)) ~= 0; continue; end
  if i>1 && raices(i)==-raices(i-1); continue; end
  s1=raices(i)*1i;
  disp(strcat('Para w_',num2str(i),'=',num2str(raices(i))))
  kpu=regla12(ls,s1)/ganancia
end

%
% Parte a
%

  kpmin=0.34*kpu;
  kpmax=0.78*kpu;
  lsmax=kpmax*ps*cs;
  lsmin=kpmin*ps*cs;

  figure
  bodeplot(lsmax)
  saveas(gcf,'bodeplot1max.eps','epsc');

  figure
  bodeplot(lsmin)
  saveas(gcf,'bodeplot1min.eps','epsc');

  figure
  bodeplot(lsmax)
  hold on
  bodeplot(lsmin)
  saveas(gcf,'bodeplot1mix.eps','epsc');
  hold off

%
% Parte b
%

  [margen_de_ganancia,margen_de_fase,frecuencia_de_mg,frecuencia_de_mf] = margin(ls);

  margen_de_ganancia_db=20*log(margen_de_ganancia)
  margen_de_fase_grados=rad2deg(margen_de_fase)

%
% Parte c
%

  hold off
  figure
  fc_graf_polar_L(lsmin)
  saveas(gcf,'partec_lsmin.eps','epsc');

  hold off
  figure
  fc_graf_polar_L(lsmax)
  saveas(gcf,'partec_lsmax.eps','epsc');

  hold off
  figure
  fc_graf_polar_L(lsmax)
  fc_graf_polar_L(lsmin)
  saveas(gcf,'partec_lsmix.eps','epsc');

%
% Parte d
%

sensibilidad_max=1/(1+lsmax);
[mag_sensibilidad_max,fase_sensibilidad_max,wout]=bode(sensibilidad_max);
Ms_max=max(mag_sensibilidad_max)

sensibilidad_min=1/(1+lsmin);
[mag_sensibilidad_min,fase_sensibilidad_min,wout]=bode(sensibilidad_min);
Ms_min=max(mag_sensibilidad_min)

%
% Parte e
%

kp_max=maxima_sensibilidad(ls,2, ps,ti,td,p,q,m,n)
cs=kp_max*(1+1/(ti*s))*(1+td*s);
ls_opt_max=minreal(ps*cs)
hold off
figure
fc_graf_polar_L(ls_opt_max)
saveas(gcf,'parte_e_ls_opt_max.eps','epsc');

kp_min=maxima_sensibilidad(ls,1.4, ps,ti,td,p,q,m,n)
cs=kp_min*(1+1/(ti*s))*(1+td*s)
ls_opt_min=minreal(ps*cs)
hold off
figure
fc_graf_polar_L(ls_opt_min)
saveas(gcf,'parte_e_ls_opt_min.eps','epsc');

%
% Parte f
%

% serie                                   estandar
% k'p (1 + 1/(t'i s)) (1 + t'd s)       = kp(1 + 1/(Ti s) + Td s)
% k'p (1 + t'd/t'i + 1/(t'i s) + t'd s) = kp(1 + 1/(Ti s) + Td s)
% k'p*(1 + t'd/t'i) (1 + 1/(t'i (1 + t'd/t'i) s) + t'd/(1 + t'd/t'i) s) = kp(1 + 1/(Ti s) + Td s)
% 
% kp=k'p*(1 + t'd/t'i)
% ti=t'i (1 + t'd/t'i)
% td=t'd/(1 + t'd/t'i)
%
%

ti_estandard=ti * (1 + td/ti)
td_estandard=td/(1 + td/ti)

kp_estandard=kp_max*(1 + td/ti)
hold off
figure
fc_fragility_rings(kp_estandard,(ti*(1+td/ti)),td/(1+td/ti),ps)
saveas(gcf,'parte_f_max.eps','epsc');

kp_estandard=kp_min*(1 + td/ti)
hold off
figure
fc_fragility_rings(kp_estandard,ti_estandard,td_estandard,ps)
saveas(gcf,'parte_f_min.eps','epsc');


% ***********************************************
%
% Bloque de funciones
%
% ***********************************************

function ms = maxima_sensibilidad(ls,val, ps,ti,td,p,q,m,n)
  epsilon=0.00000000001;
  err=epsilon+1;
  s=tf('s');
  kp=1;
  direccion=1;
  paso=5;
  cnt=0;
  [z,ganancia]=zero(ls)
  while abs(err)>epsilon

    dir_ant=direccion;
    if(err>0); kp=kp-paso; direccion=0;
    else; kp=kp+paso; direccion=1;
    end
    paso=paso/2;
    cnt=cnt+1;

    cs=kp*(1+1/(ti*s))*(1+td*s);
    ls=minreal(ps*cs);
    sensibilidad=1/(1+ls);
    [mag_sensibilidad,fase_sensibilidad,wout]=bode(sensibilidad);
    ms=max(mag_sensibilidad);
    err=ms-val;
    

  end
  ms
  ms=kp;
end

function [p q m n] = checkCarne(carne)
  newCarne=zeros(1,numel(carne));
  count=1;
  for i=carne
    if(i==0);i=6;end;
    while (ismember(i,newCarne))
      i=i+1; 
      if i>9;i=1;end;
    end
    newCarne(count)=i;
    count=count+1;
  end
  p=newCarne(1);
  q=newCarne(2);
  m=newCarne(3);
  n=newCarne(4);
end

function sol = regla11(ls)

  [num_ls,den_ls]=tfdata(tf(ls));
  nmax = max(numel(num_ls{1}),numel(den_ls{1}));

  flag = 0;
  l11 = zeros(1,nmax);
  l12 = zeros(1,nmax);

  for i = numel(num_ls{1}):-1:1
    if rem(i-numel(num_ls{1}),2) ~= 0
      if flag>1; l11(i+1) = -num_ls{1}(i);
      else; l11(i+1) = num_ls{1}(i);
      end
    else
      if flag>1; l12(i) = -num_ls{1}(i);
      else; l12(i) = num_ls{1}(i);
      end
    end
    flag=flag+1;
    if flag>3; flag=0; end
  end

  flag=0;
  l21 = zeros(1,nmax);
  l22 = zeros(1,nmax);

  for i = numel(den_ls{1}):-1:1
    if rem(i-numel(den_ls{1}),2) ~= 0
      if flag>1; l21(i+1) = -den_ls{1}(i);
      else; l21(i+1) = den_ls{1}(i);
      end
    else
      if flag>1; l22(i) = -den_ls{1}(i);
      else; l22(i) = den_ls{1}(i);
      end
    end
    flag=flag+1;
    if flag>3; flag=0; end
  end

  syms x;
  sols = solve(poly2sym(l11,x)*poly2sym(l22)==poly2sym(l12)*poly2sym(l21));
  for i=sols; sol=double(i); end
end

function k = regla12(ls, s1)
  polegain=1;
  zerogain=1;
  polo=pole(ls);
  cero=zero(ls);
  for i = 1:1:numel(polo)
    polegain=polegain*abs(s1-polo(i));
  end
  for i = 1:1:numel(cero)
      zerogain=zerogain*abs(s1-cero(i));
  end
  k = polegain/zerogain;
end