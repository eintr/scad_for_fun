/*
 * Join 2 parts together with a hinge.
 *      type:
 *          "simple":
 *      child[0]: located at [1,1,0]
 *      child[1]: located at [-1,1,0]
 */
module nhf_part_hinged_join(type="simple",d=8,l=16,gap=0.4) {
        nhf_hinge_simple(d=d,l=l,gap=gap);
        difference() {
            children(0);
            nhf_hinge_simple(part="neg_center",d=d,l=l,gap=gap);
        }
        difference() {
            children(1);
            nhf_hinge_simple(part="neg_side",d=d,l=l,gap=gap);
        }
}

// Example
nhf_part_hinged_join() {
    translate([-10-0.1,0,-10]) cube([10,5,20]);
    translate([0.1,0,-10]) cube([10,5,20]);
}

/****************************************************************/

module nhf_hinge_simple(part="main", d=5, l=10, gap=0.4)
{
    if (part=="main") {
        rotate([0,0,180]) {
            // center
            rotate([0,0,-90])
                union() {
                    cylinder(d=d-gap,h=l/3,center=true,$fs=d/100);
                    translate([0,0,l/3/2]) sphere(d=d-gap,$fs=d/100);
                    translate([0,0,-l/3/2]) sphere(d=d-gap,$fs=d/100);
                    hull() {
                        translate([0,d,0])
                            cube([0.01,0.1,l/3-gap],center=true);
                        cylinder(d=d-gap,h=l/3-gap,center=true,$fs=d/100);
                    }
                }
            // side
            rotate([0,0,90])
                union() {
                    translate([0,0,-l/3/2])
                        difference() {
                            hull() {
                                translate([0,0,-l/3/2]) cylinder(d=d,h=l/3,center=true,$fs=d/100);
                                translate([0,d,-l/3+gap]) cube([0.01,0.01,l/3-gap]);
                            }
                            sphere(d=d,$fs=d/100);
                        }
                    translate([0,0,l/3/2])
                        difference() {
                            hull() {
                                translate([0,0,l/3/2]) cylinder(d=d,h=l/3,center=true,$fs=d/100);
                                translate([0,d,0]) cube([0.01,0.01,l/3-gap]);
                            }
                            sphere(d=d,$fs=d/100);
                        }
                }
        }
    } else if (part=="neg_center") {
        cylinder(d=d+gap,h=l+gap,center=true,$fs=d/100);
        rotate([0,0,90])
            hull() {
                translate([0,0,l/3]) cylinder(d=d,h=l/3+gap,center=true,$fs=d/100);
                translate([0,d,l/3/2-gap/2]) cube([0.01,0.01,l/3+gap]);
            }
        rotate([0,0,90])
            hull() {
                translate([0,0,-l/3]) cylinder(d=d,h=l/3+gap,center=true,$fs=d/100);
                translate([0,d,-l/2-gap/2]) cube([0.01,0.01,l/3+gap]);
            }
    } else if (part=="neg_side") {
        cylinder(d=d,h=l,center=true,$fs=d/100);
        rotate([0,0,-90])
            hull() {
                translate([0,d,0])
                    cube([0.01,gap*2,l/3],center=true);
                cylinder(d=d,h=l/3,center=true,$fs=d/100);
            }
    } else {
        assert(false);
    }
}

module nhf_hinge(neg=false, part="down", axis="filament1.75", args=[], d=8,h=20) {
    if (neg) {
        if (part=="down") {
            union() {
                translate([0,0,(h-d)/2+4]) cylinder(d1=d,d2=0,h=d/2,$fn=30);
                translate([0,0,2]) cylinder(d=d,h=h-d+4,center=true,$fn=30);
                translate([0,0,-h/2]) cylinder(d1=0,d2=d,h=d/2,$fn=30);
            }
        } else if (part=="up") {
            union() {
                translate([0,0,(h-d)/2]) cylinder(d1=d,d2=0,h=d/2,$fn=30);
                translate([0,0,-2]) cylinder(d=d,h=h-d+4,center=true,$fn=30);
                translate([0,0,-h/2-4]) cylinder(d1=0,d2=d,h=d/2,$fn=30);
            }
        }
    } else {
        difference() {
            union() {
                if (part=="up") {
                    translate([0,0,(h-d)/2]) cylinder(d1=d,d2=0,h=d/2,$fn=30);
                    cylinder(d=d,h=(h-d)/2,$fn=30);
                } else {
                    translate([0,0,-(h-d)/2]) cylinder(d=d,h=(h-d)/2,$fn=30);
                    translate([0,0,-h/2]) cylinder(d1=0,d2=d,h=d/2,$fn=30);
                }
            }
            if (axis=="filament1.75") {
                assert(d>1.75+2,"nhf_hinge(): d is too small");
                if (part=="up") {
                    translate([0,0,-0.1]) cylinder(d=2.3,h=8,$fn=6);
                } else {
                    translate([0,0,-8+0.1]) cylinder(d=2.3,h=8,$fn=6);
                }
            } else if (axis=="bear" && part==0) {
                assert(d>1.75+2,"nhf_hinge(): d is too small");
                hull() {
                    children(0);
                    translate([0,0,-0.5]) children(0);
                }
            }
        }
        if (axis=="bear" && part==1) {
            translate([0,0,-0.2]) cylinder(d=args[0]+2,h=0.2,$fn=18);
            translate([0,0,-args[1]]) cylinder(d=args[0],h=args[1],$fn=18);
        }
    }
}

// Example:
//nhf_hinge(neg=true,part="down", axis="filament1.75", args=[2,3]);
//translate([10,0,0]) nhf_hinge(neg=false,part="down", axis="filament1.75", args=[2,3]);
//nhf_hinge(neg=false,part="up", axis="filament1.75", args=[2,3])
//    nhf_bear(din=2,dout=6,th=3,$fn=60);
//nhf_hinge(neg=false,part="down", axis="filament1.75", args=[2,3])
//    nhf_bear(din=2,dout=6,th=3,$fn=60);
//
//translate([0,0,-10]) mirror([0,0,1]) nhf_hinge(part=0, axis="bear")
//    nhf_bear(din=2,dout=6,th=3,$fn=60);