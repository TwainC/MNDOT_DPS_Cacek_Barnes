%% Percent Coverage of Road

w = 10; %[ft] Road width
l = 300; %[ft] Road length
d = 3; %[ft] Displacement from Sensor A to C
vA = 5/12; %[ft/s] Sweeping arm speed
vV = 2; %[ft/s] Vehicle velocity
wJ = 1; %[ft] Joint zone width (2 zones, wJ[ft] each)
wT = 2; %[ft] Transition zone width (2 zones, wT[ft] each)
wM = w - 2*wJ - 2*wT; %[ft] Mat zone width (1 zone, wM[ft])
defZone = 0.0; %[ft] Radius of defective zones
corL = 6.5; %[ft] Correlation Length
R = defZone + corL; %[ft] Length of effective correlation zone
T = 2*(w-3)/vA; %[s] Period of collection wavelength
wavL = T*vV; %[ft] Wavelength

%Area of total coverage [ft^2]:
totA = l/(w-d) * (d*(w-d)+2*vA*R*(w-d)/vV - (R*vA/vV)^2);

%Percent coverage of whole road [%]
pC = totA/(w*l) * 100;

%% Percent Coverage of Road Zones

%Calculate area of each zone for 1/4 wavelength:
jCov = wJ*(2*R + wJ*vV/vA)/2; 
if wJ + wT > d 
    tCov = wT * (2*R + wJ*vV/vA + (wJ+wT)*vV/vA)/2;
    mCov = (d + R*vA/vV - wJ - wT)*(3*R + d*vV/vA + (wJ+wT)*vV/vA)/2 ...
        + (wM/2 - (d + R*vA/vV - wJ - wT))*(2*R + d*vV/vA);
    
elseif wJ + wT > d + R*vA/vV
    tCov = (d + R*vA/vV - wJ)*((R+wJ*vA/vV)+(2*R+d(vV/vA)))/2 ...
        + (2*R + d*vV/vA)*(wJ+wT-(d+R*vA/vV));
    mCov = wM/2 * (2*R + d*vV/vA);
    
else
    tCov = wT * (2*R + wJ*vV/vA + (wJ+wT)*vV/vA)/2;
    mCov = (d + R*vA/vV - (wJ + wT))*(3*R + (wJ+wT)*vV/vA + d*vV/vA)/2 ...
        + (wM/2 + wJ + wT - (d + R*vA/vV))*(2*R + d*vV/vA);
end

%Calculate area of zones for full collection length
jCov = (4*l/wavL) * jCov; %Joint zone (both zones combined) coverage (area) [ft^2]
tCov = (4*l/wavL) * tCov; %Transition zone (both zones combined) coverage (area) [ft^2]
mCov = (4*l/wavL) * mCov; %Mat zone coverage (area) [ft^2]

jA = 2*l*wJ; %Joint zone total area [ft^2]
tA = 2*l*wT; %Transition zone total area [ft^2]
mA = l*wM; %Mat zone total area [ft^2]

pjC = jCov/jA * 100; %Percent coverage of joint zone [%]
ptC = tCov/tA * 100; %Percent coverage of transition zone [%]
pmC = mCov/mA * 100; %Percent coverage of mat zone [%]