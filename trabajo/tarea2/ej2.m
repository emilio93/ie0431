

s=tf('s');

% Parte a
Kp=30
amax=(-Kp^2+54*Kp+360)/(36*Kp)
a=1

C=Kp*(s+a)/(s+1);
P=1/(s*(s+2)*(s+3));

L=C*P;
sys=1/(1+L)
p=pole(sys)
z=zero(sys);

% Parte b

% I
s=tf('s')
Kp = 20
L = Kp / (s * (s^2+s+1) * (s+5)^2 );
sys = 1 / (L+1)
p=pole(sys)
z=zero(sys);

Kp = 19.2736
L = Kp / (s * (s^2+s+1) * (s+5)^2 );
sys = 1 / (L+1)
p=pole(sys)
z=zero(sys);

Kp = 19
L = Kp / (s * (s^2+s+1) * (s+5)^2 );
sys = 1 / (L+1)
p=pole(sys)
z=zero(sys);

% II
L = 200 / (s * (s^3 + 6*s^2 + 11*s + 6) );
sys = 1 / (L+1)
p=pole(sys)
z=zero(sys);

% III
L = 128 / (s * (s^7 + 3*s^6 + 10*s^5 + 24*s^4 + 48*s^3 + 96*s^2 + 128*s + 192) );
sys = 1 / (L+1)
p=pole(sys)
z=zero(sys);
