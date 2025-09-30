use <nhf/convenient.scad>

nhf_part_shaft(d=20,end=[["exSpline",[14,7,5,7]]]);
translate([0,0,25])
    difference() {
        cylinder(d=30,h=18);
        nhf_part_neg_inspline(20,14,7,5,20);
    }

/*
 *  nhf_part_shaft(end, d, h)
 *      d: d
 *	    h: h
 *      end: Two end processing define
 *		end[0]: Top end
 *		end[1]: Bottom end
 *		end[][0].type: End type
 *			"D": D end
 *				end[]=["D",[Depth, Length]]
 *			"exSpline": external Spline end
 *				end[]=["exSpline",[RootDiameter, NrSplines, SplineWidth, Length]]
 *			"inSpline": internal Spline end
 *				end[]=["exSpline",[MajorDiameter, MinorDiameter, NrSplines, SplineWidth, Length]]
 */
module nhf_part_shaft(end=undef, d=10, h=20, center=false) {
    difference() {
        cylinder(d=d,h=h,center=center);
        for (pos=[0,1]) {
            if (end[pos]!=undef) {
                if (end[pos][0]=="D") {
                    D=ifdef(end[pos][1][0],d*.2);
                    H=ifdef(end[pos][1][1],h/2);
                    Z=pos==1?-0.1:h-H;
                    translate([d/2-D, -d/2, Z]) cube([d,d,H+0.1]);
                } else if (end[pos][0]=="exSpline") {
                    Droot=ifdef(end[pos][1][0],d*0.8);
                    Nrsplines=ifdef(end[pos][1][1],6);
                    Wspline=ifdef(end[pos][1][2],d/6);
                    H=ifdef(end[pos][1][3],h/2);
                    Z=pos==1?-0.002:h-H;
                    translate([0, 0, Z])
                        nhf_part_neg_exspline(d,Droot,Nrsplines,Wspline,H+0.01);
                } else if (end[pos][0]=="inSpline") {
                    Dmajor=ifdef(end[pos][1][0],d*0.8);
                    Dminor=ifdef(end[pos][1][1],d*0.7);
                    Nrsplines=ifdef(end[pos][1][2],6);
                    Wspline=ifdef(end[pos][1][3],d/6);
                    H=ifdef(end[pos][1][4],h/2);
                    Z=pos==1?-0.002:h-H;
                    translate([0, 0, Z])
                        nhf_part_neg_inspline(Dmajor,Dminor,Nrsplines,Wspline,H+0.01);
                } else {
                    assert(false,"Unspoorted end processing type");
                }
            }
        }
    }
}

module nhf_part_neg_exspline(d,Droot,Nrsplines,Wspline,H) {
    difference() {
        cylinder(d=d+3,h=H);
        cylinder(d=Droot,h=H);
        for (theta=[0:360/Nrsplines:360*(Nrsplines-1)/Nrsplines]) {
            intersection() {
                cylinder(d=d,h=H);
                rotate([0,0,theta])
                    translate([Droot/2,0,H/2-0.01]) cube([Droot,Wspline,H+1],center=true);
            }
        }
    }
}
 
module nhf_part_neg_inspline(d,Droot,Nrsplines,Wspline,H,e=0.2) {
    cylinder(d=Droot+e,h=H);
    for (theta=[0:360/Nrsplines:360*(Nrsplines-1)/Nrsplines]) {
        intersection() {
            cylinder(d=d+e,h=H+e);
            rotate([0,0,theta])
                translate([(Droot+e)/2,0,(H+e)/2-0.01]) cube([Droot+e,Wspline+e,H+e+1],center=true);
        }
    }
}
