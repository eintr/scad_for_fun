
module nhf_tool_hinge(type="filament1.75", neg=false, part="down", args=[]) {
}

/****************************************************************/

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