%{ 
Uncaging simulation
Anton Sabantsev 2022

TIRF angle in our setup is 76 deg

Refractive index n1 = 1.46 (quartz)

Refractive index n2 = 1.36 (20% glycerol in water)

Wavelength ld = 360 nm or 3.6e-7 m

Penetration depth d = wavelength/4pi(n1^2*sin^2(angle)-n2^2)^-1/2

Evanescent wave I(z) = I0*exp(-z/d)

Maximum laser power is 10mW which corresponds to 100W/cm2 or 1e6W/m2 power
density (PD)

Photon flux phi0(m-2s-1)=ld(m)*PD(W/m2)/h*c, where h = 6.62607004e-34 m2*kg/s; 
c = 299792458 m/s;

Extinction coefficient eps = 5000M^-1cm^-1 for DMNPE-ATP and 430M^-1cm^-1
for NPE-ATP

Absorption of the uncaging light by cATP is negligible

Interaction cross-section in cm2 sigma = eps*2300/6E23

Uncaing rate 18s-1 for DMNPE-ATP and 90s-1 for NPE-ATP

Quantum yield 0.07 for DMNPE-ATP and 0.63 for NPE-ATP
PMID: 17664946

ATP diffusion coefficient D =  3.7e−6 cm2/s in water at room temperature
PMID: 8898871

Kinamatic viscosity of 20% glyceros is 16.4 vs 9 for water

Dcorr = D*9/16.4;

Hexokinase Km for ATP 300uM
Km for glucose in <1mM, so 10% is by far saturating
PMID: 5251873

V = Vmax*[ATP]/(Km+[ATP])

1U hydrolyses 1umol ATP per min at RT

Vmax therefore is 17mM/(s*U/ul)
At 0.01U/ul Vmax = 170uM/s
At 0.001U/ul Vmax = 17uM/s

ATP concentration = A(z, t)

Differential equation for A(z, t), A*(z, t) and cA(z, t):
dA/dt = D*d2A/dx2 + kon*A* - Vmax*A/(A+Km); Diffusion + Uncaging -
Hydrolysis by HK.
dA*/dt = D*d2A*/dx2 + cA*I*sigma*QY - kon*A*; Diffusion + Excitation -
Uncaging
dcA/dt = D*d2cA/dx2 - cA*I*sigma*QY; Diffusion - Excitation

Initial conditions cA = cA0; A* = A = 0;
Boundary conditions dA/dx(0) = dA*/dx(0) = dcA/dx(0) = 0; cA(z0) = cA0; A(z0) = A*/(z0) = 0;

%}
% cage = 'NPE';
global Vmax Km cA0 D PD eps QY uncaging_rate t0 sigma d phi0
Vmax = 0.017; %uM/ms Hexokinase Vmax = 0.17 at 0.01U/ul HK
Km = 300; %Km for ATP in uM
cA0 = 10000; %starting caged ATP concentration in uM
D = 3.7e-6; %ATP diffusion coefficient in cm2/s
D = D*9/16.4; %Corrected diffusion coefficient in cm2/s
D = D*100000000000; %Diffusion coefficient in nm2/ms
cage = 'DMNPE';
PD = 1e6; %W/m2
switch cage
    case 'NPE'
        eps = 430; %M^-1cm^-1
        QY = 0.63;
        uncaging_rate = 90/1000; % ms-1
    case 'DMNPE'
        eps = 5000;
        QY = 0.07;
        uncaging_rate = 18/1000; % ms-1
end
t0 = 180; % Pulse duration in ms
sigma = eps*2300/6e23; % Absorption cross-section in cm2
h = 6.62607004e-34; % m2*kg/s
c = physconst('LightSpeed');
angle = deg2rad(76);
n1 = 1.46;
n2 = 1.36;
ld = 360; % Wavelength 360 nm
d = ld/(4*pi*(n1^2*sin(angle)^2-n2^2)^0.5); % Penetration depth nm
phi0=ld/1e9*PD/h/c/10000000; % cm-2*ms-1

xmesh = 0:200:20000;
tspan = 0:2:5000;

sol = pdepe(0,@equation,@icfun,@bcfun,xmesh,tspan); % Solving the differential equation



function [c,f,s] = equation(x,t,u,dudx) % The system of partial differential equations for (1) - ATP, (2) - ATP* and (3) - caged ATP
    global D Km Vmax uncaging_rate sigma QY phi0 d t0
    c = [1; 1; 1];
    f = [D*dudx(1); D*dudx(2); D*dudx(3)];
%     "Commited activated species version of equations
    if t < t0
        s = [uncaging_rate*u(2)-Vmax*u(1)/(Km + u(1)); sigma*QY*phi0*exp(-x/d)*u(3)-uncaging_rate*u(2); -sigma*QY*phi0*exp(-x/d)*u(3)];
    else
        s = [uncaging_rate*u(2)-Vmax*u(1)/(Km + u(1)); -uncaging_rate*u(2); 0];
    end
%     "Non-commited activated species" version of equations  
%     if t < t0
%         s = [uncaging_rate*u(2)-Vmax*u(1)/(Km + u(1)); sigma*phi0*exp(-x/d)*u(3)-uncaging_rate*u(2)/QY; -sigma*phi0*exp(-x/d)*u(3)+uncaging_rate*(1-QY)*u(2)/QY];
%     else
%         s = [uncaging_rate*u(2)-Vmax*u(1)/(Km + u(1)); -uncaging_rate*u(2)/QY; uncaging_rate*(1-QY)*u(2)/QY];
%     end
end

function  u0 = icfun(x) % The initial condition
    global cA0
    u0 = [0; 0; cA0];
end

function [pl,ql,pr,qr] = bcfun(xl,ul,xr,ur,t) % Boundary conditions
    global cA0
    qr = [0; 0; 0];
    pr = [ur(1); ur(2); ur(3) - cA0];
    pl = [0; 0; 0];
    ql = [1; 1; 1];
end

