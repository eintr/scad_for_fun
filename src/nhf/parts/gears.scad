use <nhf/algos/list.scad>
use <nhf/algos/math.scad>

// Example:
// nhf_part_gear(z=28,m=1,b=10);
// z: number of teeth
// m: tooth width (mm)
// b: gear thick (mm)
// alphaP: presure angle (degree)
module nhf_part_gear(z=17, m=4, b=3, alphaP=20) {
	dref = m*z;               // Reference circle
	dbase = dref*cos(alphaP); // Base circle
	dtip = m*(z+2);           // Tip circle
	droot = dref-m*(2.5+2/z); // Root circle

	function find_theta(L,d) = distance2(head(L))>=d ? atan2(head(L).y, head(L).x) : find_theta(tail(L),d);

	function f_involute(r0, r1)  = [
		for (alpha=0; distance2([ r0*cos(alpha)+alpha*PI/180*r0*sin(alpha), r0*sin(alpha)-alpha*PI/180*r0*cos(alpha) ]) < r1; alpha=alpha+360/z/8)
			[
				r0*cos(alpha)+alpha*PI/180*r0*sin(alpha),
				r0*sin(alpha)-alpha*PI/180*r0*cos(alpha)
			]
	];

	module tooth_surface(b, rb, ra, poly) {
		translate([0,0,-b/2]) linear_extrude(height=b) polygon(poly);
	}

	module tooth0(b, z, m) {	// The first tooth
		d = z * m;
		da = m*(z+2);
		dbase = d*cos(alphaP);
		pol = concat([[0,0]],f_involute(r0=dbase/2, r1=da/2+(da/2-dbase/2)),[[0,d/2]]);
		beta = find_theta(pol, d/2);
		intersection() {
			tooth_surface(b,dbase/2,da/2,pol);
			rotate([180,0,360/z-(180/z-2*beta)]) tooth_surface(b,dbase/2,da/2,pol);
		}
	}

	intersection() {
		union() {
			cylinder(h=b, d=droot,center=true,$fn=z*8);
			for (i=[0:z-1])
				rotate([0,0,360/z*i/*-180/z*/])
					render() tooth0(b=b, z=z, m=m);
		};
		// Turn tip
		cylinder(h=b+0.01,d=dtip,center=true,$fn=z*8);
	}
	// Reference circle for preview
	if ($preview) color("gray")
		for (pos=[b/2, -b/2])
			translate([0,0,pos])
				rotate_extrude($fn=z*8) translate([dref/2,0]) circle(d=b/200,$fn=9);
}
