function nhf_curve_involute(theta0=0, r0=10, r1=40)  = [
	for (theta=0; norm([ r0*cos(theta+theta0)+theta*PI/180*r0*sin(theta+theta0), r0*sin(theta+theta0)-theta*PI/180*r0*cos(theta+theta0) ]) < r1; theta=theta+360/$fn)
	[
		r0*cos(theta+theta0)+theta*PI/180*r0*sin(theta+theta0),
		r0*sin(theta+theta0)-theta*PI/180*r0*cos(theta+theta0)
	]
];

echo (nhf_curve_involute());