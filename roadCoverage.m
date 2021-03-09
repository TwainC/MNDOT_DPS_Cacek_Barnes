%% Road Coverage

w = 10; %[ft] Road width
l = 1008; %[ft] Road length
d = 3; %[ft] Displacement from Sensor A to C
throw = 7; %[ft] Displacement in half a wavelength for each sensor 
vA = 5/12; %[ft/s] Sweeping arm speed
vV = 3; %[ft/s] Vehicle velocity
wJ = 1; %[ft] Joint zone width (2 zones, wJ[ft] each)
wT = 2; %[ft] Transition zone width (2 zones, wT[ft] each)
wM = w - 2*wJ - 2*wT; %[ft] Mat zone width (1 zone, wM[ft])
time = l/vV; %[s] Time to travel length of the road
xi = 6; %[ft] Inital lateral position of center sensor
dt = 0.01; %[s] Time step size
dx = vA*dt; %[ft] Change in x step size
dy = vV*dt; %[ft] Change in y step size
defZone = 0.5; %[ft] Radius of deffective zones
corL = 5; %[ft] Correlation Length
R = defZone + corL; %[ft] radius of effective correlation zone
T = 2*(w-3)/vA; %[s] Period of wavelength of collection
wavL = T*vV; %[ft] Wavelength

t = 0:dt:time;
y = vV*t;
xA = zeros(1,length(t));
xB = zeros(1,length(t));
xC = zeros(1,length(t));

xA(1) = xi - 1.5;
xB(1) = xi;
xC(1) = xi + 1.5;



for i = 2:length(t)
    if (xA(i-1)+dx) < 0 || (xC(i-1)+dx)  > w
        dx = -dx;
    end
    
    xA(i) = xA(i-1) + dx;
    xB(i) = xB(i-1) + dx;
    xC(i) = xC(i-1) + dx;
end

x = [xA;xB;xC];

xSect = zeros(size(x));

totA = l/(w-d) * (d*(w-d)+2*vA*R*(w-d)/vV - (R*vA/vV)^2);

jCov = 2*wJ/21;
tCov = (7-wM+2*wT)/21;
mCov = (2*(7-wJ-wT)+wM)/21;


xSect(x(:,:) < 2*wJ+2*wT+wM) = 5;
xSect(x(:,:) < wJ+2*wT+wM) = 4;
xSect(x(:,:) < wJ+wT+wM) = 3;
xSect(x(:,:) < wJ+wT) = 2;
xSect(x(:,:) < wJ) = 1;

jA = l*wJ;
tA = l*wT;
mA = l*wM;

dv = sqrt(dx^2 + dy^2);

%pjC = (sum(xSect == 1,'all')*abs(dx)*2*R-l/wavL*2*R/dy*dx/2*R)/jA;
pjC = jCov/2*totA/jA;
ptC = tCov/2*totA/tA;
pmC = mCov*totA/mA;
pC = totA/(2*jA+2*tA+mA);

NJ = sum([xA;xB;xC] < wJ,'all') + sum([xA;xB;xC] > wJ+2*wT+wM,'all');
NM = sum(([xA;xB;xC] >= wJ+wT & [xA;xB;xC] <= wJ+wT+wM),'all');
NT = 3*length(t) - NJ - NM;

tJ = (NJ-1)*dt;
tT = (NT-1)*dt;
tM = (NM-1)*dt;

pJ = tJ/(3*time);
pT = tT/(3*time);
pM = tM/(3*time);

h(1) = plot(xA,y,'--r');
hold on
plot(xA,y+R,'-r');
plot(xA,y-R,'-r');
h(2) = plot(xB,y,'--b');
plot(xB,y+R,'-b');
plot(xB,y-R,'-b');
h(3) = plot(xC,y,'--g');
plot(xC,y+R,'-g');
plot(xC,y-R,'-g');
h(5) = xline(wJ,'-r','LineWidth',2);
h(4) = xline(0,'-k','LineWidth',2);
h(6) = xline(wT+wJ,'-b','LineWidth',2);
xline(wT+wJ+wM,'-b','LineWidth',2);
xline(2*wT+wJ+wM,'-r','LineWidth',2);
xline(2*wT+2*wJ+wM,'-k','LineWidth',2);
text(w/8,0.1*l,sprintf("Sensor time in joint zone = %.2f[s], %.2f[%%] of time",tJ,pJ*100));
text(w*5/12,0.1*l,sprintf("Sensor time in transiton zone = %.2f[s], %.2f[%%] of time",tT,pT*100));
text(3*w/4,0.1*l,sprintf("Sensor time in mat zone = %.2f[s], %.2f[%%] of time",tM,pM*100));
title("Gator/Arm GPR Collection Path - Dots are time steps (i.e., they are not measurements)");
xlabel("Lateral Distance From Centerline [ft]");
ylabel("Longitudinal Distance of Road [ft]");
legend(h,"Sensor A", "Sensor B", "Sensor C","Shoulder/Centerline Boundary","Joint-Transtition Boundary","Transition-Mat Boundary");
hold off
