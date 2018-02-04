function [] = fc_nyquist(en1,en2)
%V.M. Alfaro, 2002, 2003, 2004
%fc_nyquist dibuja en forma correcta la gráfica polar cuando
%la función de transferencia de lazo abierto presenta
%polos en el eje imaginario del plano complejo
%
%  fc_nyquist(sys)
%      sys -  función de transferencia de lazo abierto G(s)
%
%  fc_nyquist(num,den)
%      num -  coeficientes del polinomio del numerador de la función de transferencia
%      dem -  coeficientes del polinomio del denominador de la función de transferencia
%             G(s)= num(s)/dem(s)
%
%  además de la gráfica polar, fc_nyquist indica el número de polos (P)
%  de la función de transferencia de lazo abierto en el semiplano derecho,
%  el número de encierros del punto -1 en el sentido de las manecillas del reloj (N) y
%  el número (Z) de polos de lazo cerrado en el semiplano derecho
%
%Nota:
%fc_nyquist está basada en el programa lnyquist.m de la Universidad de Michigan
%disponible en http://www.engin.umich.edu/group/ctm/freq/nyq.html
%
lb=[' '; ' '];
nin=nargin;
if (nin==1)
	[num,den]=tfdata(en1,'v');
elseif (nin==2)
	num=en1;den=en2;
else
   error('Número de parámetros de entrada inválidos');
   return
end
%
w = freqint2(num,den,100);
[ny,nn] = size(num); nu = 1;
%
if nu*ny==0, im=[]; w=[]; if nargout~=0, reout=[]; end, return, end
%-----------------------------------------------------------------
%
tol = 1e-6;
z = roots(num);
p = roots(den);
%
if norm(p) == 0
   length_p = length(p);
   p = -tol*ones(length_p,1);
   den = den(1,1)*[1 tol];
   for ii = 2:length_p
      den = conv(den,[1 tol]);
   end
end
%
zp = [z;p];
nzp = length(zp);
ones_zp=ones(nzp,1);
Ipo = find((abs(real(p)) < tol) & (imag(p)>=0));
%
if  ~isempty(Ipo)
   po = p(Ipo);
   [y,ipo] = sort(imag(po));
   po = po(ipo);
   dpo = diff(po);
   idpo = find(abs(dpo)>tol);
   idpo = [1;idpo+1];
   po = po(idpo);
   nIpo = length(idpo);
   originflag = find(imag(po)==0);
%
   s = [];
   w = sqrt(-1)*w;
   for ii=1:nIpo
      [nrows,ncolumns]=size(w);
      if nrows == 1
         w = w.';  % if w is a row, make it a column
      end;
      if nIpo == 1
         r(ii) = .1;
      else
         pdiff = zp-po(ii)*ones_zp
         ipdiff = find(abs(pdiff)>tol)
         r(ii)=0.2*min(abs(pdiff(ipdiff)))
         r(ii)=min(r(ii),0.1)
      end;
      t = linspace(-pi/2,pi/2,25);
      if (ii == originflag)
         t = linspace(0,pi/2,25);
      end;
      s1 = po(ii)+r(ii)*(cos(t)+sqrt(-1)*sin(t));
      s1 = s1.';
%
      bottomvalue = po(ii)-sqrt(-1)*r(ii);
      if (ii ==  originflag)
         bottomvalue = 0;
      end;
      topvalue = po(ii)+sqrt(-1)*r(ii);
      nbegin = find(imag(w) < imag(bottomvalue));
      nnbegin = length(nbegin);
      if (nnbegin == 0)& (ii ~= originflag)
         sbegin = 0
      else sbegin = w(nbegin);
      end;
      nend = find(imag(w) > imag(topvalue));
      nnend = length(nend);
      if (nnend == 0)
         send = 0
      else send = w(nend);
      end
      w = [sbegin; s1; send];
   end
else
   w = sqrt(-1)*w;
end
%
%----------------------------------------------------------------
gt = freqresp(num,den,w);
nw = length(gt);
mag = abs(gt);
ang = angle(gt);
mag = log2(mag+1);
%
for n = 1:nw
   h(n,1) = mag(n,1)*(cos(ang(n,1))+sqrt(-1)*sin(ang(n,1)));
end;
%
gt = h;
ret=real(gt);
imt=imag(gt);
%
status = ishold;
plot(ret,imt,'b',ret,-imt,'r--')
%
%----------------------------------------------------------------
[numc,denc] = tfchk(num,den);
gw = [(ret + j*imt); numc(1)/denc(1); (flipud(ret) - j*flipud(imt))]; %
[Ngw,Mgw] = size(gw);
gwp1 = gw + ones(Ngw,Mgw);
initial_angle = rem(180/pi*angle(gwp1(1)) + 360, 360);
angle_gwp1 = rem(180/pi*angle(gwp1) - initial_angle + 720,360);
dagw = diff(angle_gwp1);
tolerance = 180;
Ipd = find(dagw < -tolerance);
Ind = find(dagw > tolerance);
Nacw = max(length(Ipd)) - max(length(Ind));
%
disp(lb);
disp('Función de transferencia de lazo abierto G(s)');
if (nin==1)
	Gs=en1
elseif (nin==2)
	Gs=tf(num,den)
end;
%
disp('Polos de lazo abierto en el semiplano derecho');
P = length(find(p>0));
fc_dispnum('  P = ',P);
disp('Encierros del punto -1 en el sentido de las manecillas del reloj')
N = -Nacw;
fc_dispnum('  N = ',N);
disp('Polos de lazo cerrado en el semiplano derecho')
Z = P + N;
fc_dispnum('  Z = ',Z);
%
%----------------------------------------------------------------
xamb=max(ret)-min(ret);
xp=xamb/2+min(ret)+xamb/10;
yamb=2*(max(imt)-min(imt));
yp=-min(imt)/2;
fc_plotnum(xp,yp,'P = ',P);
fc_plotnum(xp,yp-yamb/10,'N = ',N);
fc_plotnum(xp,yp-yamb/5,'Z = ',Z);
%
set(gca, 'YLimMode', 'auto')
limits = axis;
%
set(gca, 'YLimMode', 'auto')
set(gca, 'XLimMode', 'manual')
hold on
%
for k=1:size(gt,2),
   g = gt(:,k);
   re = ret(:,k);
   im = imt(:,k);
   sx = limits(2) - limits(1);
   [sy,sample]=max(abs(2*im));
   arrow=[-1;0;-1] + 0.75*sqrt(-1)*[1;0;-1];
   sample=sample+(sample==1);
   reim=diag(g(sample,:));
   d=diag(g(sample+1,:)-g(sample-1,:));
   d = real(d)*sy + sqrt(-1)*imag(d)*sx;
   rot=d./abs(d);
   arrow = ones(3,1)*rot'.*arrow;
   scalex = (max(real(arrow)) - min(real(arrow)))*sx/50;
   scaley = (max(imag(arrow)) - min(imag(arrow)))*sy/50;
   arrow = real(arrow)*scalex + sqrt(-1)*imag(arrow)*scaley;
   xy =ones(3,1)*reim' + arrow;
   xy2=ones(3,1)*reim' - arrow;
   [m,n]=size(g);
   hold on
   plot(real(xy),-imag(xy),'b-',real(xy2),imag(xy2),'r-')
end
title('Gráfica polar (diagrama de Nyquist) de G(jw)');
xlabel('Real G(jw)'), ylabel('Imaginario G(jw)')
limits = axis;
%
if limits(2) >= -1.5  & limits(1) <= -0.5
   line1 = (limits(2)-limits(1))/50;
   line2 = (limits(4)-limits(3))/50;
   plot([-1+line1, -1-line1], [0,0], 'k-', [-1, -1], [line2, -line2], 'k-')
end
%
plot([limits(1:2);0,0]',[0,0;limits(3:4)]','k:');
if ~status, hold off, end
return
