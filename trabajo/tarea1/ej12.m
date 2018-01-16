
clear
s=tf('s');
ti = 0;
tf = 50;
steps = 1000;
t=ti:(tf-ti)/steps:tf;

A=5;
g=9.81;
Kvs=0.001;
H0=2.5;
Xvsmin=0.4;
Xvs=0.5;
p=1475;

rands = rand(1000,1);
Xvs_t = Xvsmin + arrayfun(@(x) x/5,rands) ;
plot(Xvs_t);

escalon = 

%H_t;


%G = K1/(T*s+1)H_t + K2/(T*s+1)Xvs_t;