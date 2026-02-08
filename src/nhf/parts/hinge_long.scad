use <nhf/import.scad>

module nhf_hinge_long(part="main", d=5, l=20, l_unit=undef, gap=0.2) {
	function even_positive(x) = x%2==0?1:-1;
	module unit(dir) {
		difference() {
			hull() {
				cylinder(d=d-gap*2,h=l0,center=true,$fs=d/100);
				translate([dir*d,0,gap/2])
					cube([0.01,0.1,l0-gap*2],center=true);
			}
			translate([0,0,-l0/2]) cylinder(d=d*2,h=gap,$fs=d/100);
			translate([0,0,-l0/2]) cylinder(d1=d,d2=d/2,h=l0/4+gap,$fs=d/100);
		}
		translate([0,0,l0/2]) cylinder(d1=d-gap*2,d2=(d-gap)/2,h=l0/4,$fs=d/100);
	}
	module neg_unit(dir) {
		hull() {
			cylinder(d=d,h=l0+gap,center=true,$fs=d/100);
			translate([dir*(d+gap),0,0]) cube([0.1,0.1,l0+gap],center=true);
		}
	}
	
	assert(l>=l0*4, "l is too short");
	l0 = l_unit==undef?(l-l0)/5:l_unit;
	n=floor((l-l0)/2/l0);
    if (part=="main") {
		// center unit
		union() {
			cylinder(d=d-gap*2,h=l0,center=true,$fs=d/100);
			translate([0,0,l0/2]) cylinder(d1=d-gap*2,d2=(d-gap*2)/2,h=l0/4,$fs=d/100);
			translate([0,0,-l0*3/4]) cylinder(d1=(d-gap*2)/2,d2=(d-gap*2),h=l0/4,$fs=d/100);;
			hull() {
				translate([-d,0,0])
					cube([0.01,0.1,l0-gap*2],center=true);
				cylinder(d=d-gap*2,h=l0-gap*2,center=true,$fs=d/100);
			}
		}
		// other units
		for (h=[0:n-1]) {
			translate([0,0,l0+h*l0]) unit(even_positive(h));
			mirror([0,0,1]) translate([0,0,l0+h*l0]) unit(even_positive(h));
		}
    } else if (part=="neg_center") {
        cylinder(d=d+gap*2,h=l-l0/2+gap*2,center=true,$fs=d/100);
//		hull() {
//			cylinder(d=d+gap*2,h=l0,center=true,$fs=d/100);
//			translate([d,0,0]) cube([0.1,0.1,l0],center=true);
//		}
		for (h=[0:2:n-1]) {
			translate([0,0,l0+h*l0]) neg_unit(-1);
			mirror([0,0,1]) translate([0,0,l0+h*l0]) neg_unit(-1);
		}
    } else if (part=="neg_side") {
        cylinder(d=d+gap*2,h=l-l0/2+gap*2,center=true,$fs=d/100);
		hull() {
			cylinder(d=d+gap*2,h=l0,center=true,$fs=d/100);
			translate([d,0,0]) cube([0.1,0.1,l0],center=true);
		}
		for (h=[1:2:n-1]) {
			translate([0,0,l0+h*l0]) neg_unit(1);
			mirror([0,0,1]) translate([0,0,l0+h*l0]) neg_unit(1);
		}
    } else {
        assert(false, "Unknown part parameter value");
    }
}

nhf_hinge_long(d=10, l_unit=10, l=100);
difference() {
	translate([0.1,0,-50]) cube([15,8,100]);
	nhf_hinge_long(part="neg_side", d=10, l_unit=10, l=100);
}
difference() {
	translate([-15-0.1,0,-50]) cube([15,8,100]);
	nhf_hinge_long(part="neg_center", d=10, l_unit=10, l=100);
}