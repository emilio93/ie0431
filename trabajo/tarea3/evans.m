s=tf('s');
kp=1;

% 1
% ps=7/((s+1)*(s+4)*(s+7));
% cs=(s^2+8*s+52)/(8*s);

% 2
% ps = 2/((s+1)*(s+2)*(s+3)*(s+4))
% cs = kp*(s^2+s+4)/(2*s)

% 3
%ps = 10/((s+1)*(s^2+4*s+8))
%cs=kp*(s^2+10*s+34)/(10*s)

% 4
% ps = (s^2+4*s+13)/((s+12)*(s^2+8*s+16.25))
% cs=kp*(s+1)/s

% 5
% ps = (s^2+4*s+13)/((s+12)*(s^2+8*s+16.25))
% cs= kp*(1.5*s^2+3*s+4)/(3*s)

% 6
% ps=(s^2+4*s+13)/((s+12)*(s^2+8*s+16.25));
% cs=kp*(1.5*s^2+3*s+4)/(3*s);

% L(s)
ls=ps*cs

% Polinomio Característico
pc=1+ls

psLTX=tf2latex(ps)
csLTX=tf2latex(cs)
lsLTX=tf2latex(ls)
pcLTX=tf2latex(pc)

kvec=0:1/1000:500;
rlocusplot(ls,kvec)

disp('********************************************')
disp('Regla 1: Simetría en eje real')
disp(' ')

disp('********************************************')
disp('Regla 2: Inico y final del LRG: Inicia en polos, termina en ceros')
disp(' ')

% Lazo abierto
[polos,ceros]=pzmap(ls)

disp('********************************************')
disp('Regla 3: Número de ramas(cantidad de polos menos cantidad de ceros, n-m):')
disp(' ')

% cantidad de polos(n) y ceros(m)
n=numel(polos);
m=numel(ceros);
disp(strcat('n-m=', num2str(numel(polos)), '-', num2str(numel(ceros)), '=', num2str(n-m)))

disp('********************************************')
disp('Regla 4: LGR sobre el eje real. Ver LGR.')
disp(' ')

disp('********************************************')
disp('Regla 5: Angulo de las asíntotas.')
disp(' ')
if (n-m-1>=0)
    for k=0:1:n-m-1
        disp(strcat("Angulo a_",num2str(k)))
        (2*k+1)*180/(n-m)
    end
else
    disp('    n-m-1<0 entonces regla no aplica')
end

disp('********************************************')
disp('Regla 6: Intersección de asíntotas con el eje real')
disp(' ')
if (n-m>=2)
    disp('Interseccion sigma_a')
    (sum(polos)-sum(ceros))/(n-m)
else
    disp('    n-m<2 entonces regla no aplica')
end

disp('********************************************')
disp('Regla 7: Centroide de las raices')
disp(' ')
if (n-m>=2)
    disp('Interseccion sigma_r')
    sum(polos)/(n)
else
    disp('    n-m<2 entonces regla no aplica')
end

disp('********************************************')
disp('Regla 8: Puntos de salida o entrada al eje real')
disp(' ')

[num_ls,den_ls]=tfdata(tf(ls));
celldisp(num_ls)
celldisp(den_ls)

pc
[num_pc,den_pc]=tfdata(tf(pc));
celldisp(num_pc)
celldisp(den_pc)

disp('Ahora, 1+L(s)=0 => den(L(s)) + num(L(s)) = 0')
disp('Si num(L(s)) = Kp*f(s) => Kp= -den(s)/num(s)')

syms x
f=poly2sym(den_ls,x)/poly2sym(num_ls,x)
latex(f)
derivada=diff(f)

derivada=simplify(derivada)
[a,b]=numden(derivada);
latex(a)
latex(factor(a))

raices=solve(derivada==0,x)

disp('Las raices son:')
for i = 1:numel(raices)
    sym2poly(raices(i))
end

disp('********************************************')
disp('Regla 9: Angulos de salida o entrada al eje real')
disp(' ')
regla9();

disp('********************************************')
disp('Regla 10: Ángulo de partida/llegada de un polo/a un cero complejo')
disp(' ')
regla10(polos, ceros);

disp('********************************************')
disp('Regla 11: Cruce con el eje imaginario')
disp(' ')

ls

flag = 0;
flag2 = 0;
nmax = max(numel(num_ls{1}),numel(den_ls{1}));
l11 = zeros(1,nmax);
l12 = zeros(1,nmax);

for i = numel(num_ls{1}):-1:1
    if rem(i-numel(num_ls{1}),2) ~= 0
        if flag>1
            l11(i+1) = -num_ls{1}(i);
        else
            l11(i+1) = num_ls{1}(i);
        end
    else
        if flag>1
            l12(i) = -num_ls{1}(i);
        else
            l12(i) = num_ls{1}(i);
        end
    end
    flag=flag+1;
    if flag>3
        flag=0;
    end
end


flag=0;
l21 = zeros(1,nmax);
l22 = zeros(1,nmax);
for i = numel(den_ls{1}):-1:1
    if rem(i-numel(den_ls{1}),2) ~= 0
        if flag>1
            l21(i+1) = -den_ls{1}(i);
        else
            l21(i+1) = den_ls{1}(i);
        end
    else
        if flag>1
            l22(i) = -den_ls{1}(i);
        else
            l22(i) = den_ls{1}(i);
        end
    end
    flag=flag+1;
    if flag>3
        flag=0;
    end
end
l11
l12
l21
l22

syms x;
sols = solve(poly2sym(l11,x)*poly2sym(l22)==poly2sym(l12)*poly2sym(l21))
for i=sols
    sol=double(i)
end


disp('********************************************')
disp('Regla 12: Calculo de la ganancia en un punto del LGR')
disp(' ')
s1 = input('elija s1 ej 1+1i: ');

polegain=1;
zerogain=1;
for i = 1:numel(polos)
    a = abs(s1-polos(i));
    polegain = polegain * a;
    
end
for i = 1:numel(ceros)    
    a = abs(s1-ceros(i));
    zerogain = zerogain * a;
end
ganancia = polegain/zerogain

function txt = tf2latex(sys)
   [num,den] = tfdata(sys);
   syms s;
   txt=latex(poly2sym(cell2mat(num),s)/poly2sym(cell2mat(den),s));
end

function regla9()
   respuesta = input('cantidad de polos en sección de interés(numero <2 para continuar)');
   if (respuesta>=2)
       for i = 0:1:respuesta-1
           disp(strcat('a_c',num2str(i),'=',num2str((2*i+1)*180/respuesta)))
       end
       regla9();
   end
end

function [ang_p, ang_c] = regla10(polos, ceros)
    for i = 1:numel(polos)
        if (imag(polos(i))~=0)
            disp(strcat('Ángulo de partida del polo complejo: ', num2str(polos(i))))
            
            r10a=wrapTo360(rad2deg(regla10_aux(polos(i),polos,ceros)))
            disp(num2str(r10a))
        end
    end
    for i = 1:numel(ceros)
        if (imag(ceros(i))~=0)
            disp(strcat('Ángulo de llegada del cero: ', num2str(ceros(i))))
            
            r10a=wrapTo360(rad2deg(regla10_aux(ceros(i),polos,ceros)))
            disp(num2str(r10a))
        end
    end
end

function angulo = regla10_aux(pos, polos,ceros)
    %disp(strcat('Posicion:',num2str(pos)))
    acumulado=0;
    for j = 1:numel(polos)
        if (pos~=polos(j))
            %disp(strcat('sumando angulo con polo',num2str(polos(j))))
            %rad2deg(angle(-pos+polos(j)))
            
            acumulado = acumulado + angle(-pos+polos(j));
            
        end
    end
    for j2 = 1:numel(ceros)
        if (pos~=ceros(j2))
            %disp(strcat('sumando angulo con cero',num2str(ceros(j2))))
            %rad2deg(angle(-pos+ceros(j2)))
            acumulado = acumulado + angle(-pos+ceros(j2));
        end
    end
    angulo = acumulado;
end
