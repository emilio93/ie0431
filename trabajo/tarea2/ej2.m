

s=tf('s');
Kp = 900;
L = 1 / (s * (s^2+s+1) * (s+5)^2 )
sys = 1 / (L+1)

p=pole(sys)
z=zero(sys)

figure
%pzmap(sys)
%plot(z,'o')
%hold on
plot(p,'x')

title('Diagrama de polos y ceros')
%legend('Ceros','Polos', 'Location','northwest')
ylabel('Eje Imaginario')
xlabel('Eje Real')
saveas(gcf, 'img/ej2-1.eps','epsc');

L = 200 / (s * (s^3 + 6*s^2 + 11*s + 6) )
sys = 1 / (L+1)

p=pole(sys)
z=zero(sys)


L = 128 / (s * (s^7 + 3*s^6 + 10*s^5 + 24*s^4 + 48*s^3 + 96*s^2 + 128*s + 192) )
sys = 1 / (L+1)

p=pole(sys)
z=zero(sys)