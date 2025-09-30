use <nhf/convenient.scad>

nhf_part_shaft(d=150, H=21, end=[["exSpline"]]);
nhf_part_shaft(d=170, H=21, end=[["inSpline",[150]]]);

/*
 *  nhf_part_shaft(end, d, h, H)
 *      d: d
 *	    h: h
 *      H: End processing length
 *      end: Two end processing define, undef means no end processing and H is ignored.
 *		end[0]: Top end
 *		end[1]: Bottom end
 *		end[][0].type: End type
 *			"D": D end
 *				end[]=["D",[Depth, Length]]
 *			"exSpline": external Spline end
 *				end[]=["exSpline"] : Auto parameter according to GB/T 1144—2001
 *				end[]=["exSpline",[RootDiameter, NrSplines, SplineWidth]]
 *			"inSpline": internal Spline end
 *              end[]=["exSpline",[MajorDiameter]] : Auto parameter according to GB/T 1144—2001
 *				end[]=["exSpline",[MajorDiameter, MinorDiameter, NrSplines, SplineWidth]]
 */
module nhf_part_shaft(end=undef, d=20, h=20, D=16, H=10, center=false) {
    // According to GB/T 1144—2001
    function ref_gbt1144(D) =
        (D<14)?
            undef:
        (D<16)?
            [D,D-3,6,3]:
        (D<20)?
            [D,D-3,6,3.5]:
        (D<22)?
            [D,D-4,6,4]:
        (D<25)?
            [D,D-4,6,5]:
        (D<28)?
            [D,D-4,6,5]:
        (D<32)?
            [D,D-5,6,6]:
        (D<34)?
            [D,D-6,6,6]:
        (D<38)?
            [D,D-6,6,7]:
        (D<42)?
            [D,D-6,8,6]:
        (D<48)?
            [D,D-6,8,7]:
        (D<54)?
            [D,D-6,8,8]:
        (D<60)?
            [D,D-8,8,9]:
        (D<65)?
            [D,D-8,8,10]:
        (D<72)?
            [D,D-9,8,10]:
        (D<82)?
            [D,D-10,8,12]:
        (D<92)?
            [D,D-10,10,12]:
        (D<102)?
            [D,D-10,10,12]:
        (D<112)?
            [D,D-10,10,14]:
        (D<125)?
            [D,D-10,10,16]:
        (D==125)?
            [D,D-10,10,18]:[D,D-10,10,18];

    difference() {
        cylinder(d=d,h=h,center=center);
        for (pos=[0,1]) {
            if (end[pos]!=undef) {
                if (end[pos][0]=="D") {
                    D=ifdef(end[pos][1][0],d*.2);
                    Z=pos==1?-0.1:h-H;
                    translate([d/2-D, -d/2, Z]) cube([d,d,H+0.1]);
                } else if (end[pos][0]=="exSpline") {
                    assert(d>=14,"d is too small to use exSpline");
                    arg=firstDefined([end[pos][1],ref_gbt1144(d)]);
                    Droot=firstDefined([arg[1],d*0.8]);
                    Nrsplines=firstDefined([arg[2],6]);
                    Wspline=firstDefined([arg[3],d/6]);
                    Z=pos==1?-0.002:h-H;
                    translate([0, 0, Z])
                        nhf_part_neg_exspline(d,Droot,Nrsplines,Wspline,H+0.01);
                } else if (end[pos][0]=="inSpline") {
                    assert(end[pos][1][0]!=undef, "Major diamerter must be defined for inSpline!");
                    Dmajor=end[pos][1][0];
                    autoarg=ref_gbt1144(Dmajor);
                    Dminor=firstDefined([end[pos][1][1],autoarg[1]]);
                    Nrsplines=firstDefined([end[pos][1][2],autoarg[2]]);
                    Wspline=firstDefined([end[pos][1][3],autoarg[3]]);
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
