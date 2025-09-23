use <nhf/algos/list.scad>

module nhf_2d_spiral(type="ln", r0=10, r1=90, line_width=0.1) {
	function type_ln(alpha=0,beta=1) = [
		for (r=r0,th=alpha;r<=r1;th=th+$fa,r=r0+alpha+beta*th) [r*cos(th),r*sin(th)]
	];
	polygon(type_ln());
}

nhf_2d_spiral($fa=1);