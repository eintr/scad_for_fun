function nhf_curve_spiral_ln(alpha=0,beta=1,r0=10,r1=90) = [
		for (r=r0,th=alpha;r<=r1;th=th+$fa,r=r0+alpha+beta*th)
			[r*cos(th),r*sin(th)]
	];
