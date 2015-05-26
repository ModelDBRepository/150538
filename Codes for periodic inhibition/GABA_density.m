function y=GABA_density(mu,delta_2,xx)
% mu=0;
% delta_2=1;
% x=-5:0.1:5;
% xx=x/10+0.5;
y=1/(sqrt(delta_2)*sqrt(2*pi))*exp(-(10*(xx-0.5)-mu).^2/(2*delta_2));
% figure
% plot(xx,y);hold on;

