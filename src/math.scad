
/* Calculate distance in space */
function distance2(v, v0=[0,0]) = sqrt((v.x-v0.x)*(v.x-v0.x) + (v.y-v0.y)*(v.y-v0.y));
function distance3(v, v0=[0,0,0]) = sqrt((v.x-v0.x)*(v.x-v0.x) + (v.y-v0.y)*(v.y-v0.y) + (v.z-v0.z)*(v.z-v0.z));