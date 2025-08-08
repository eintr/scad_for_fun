use <nhf/shapes.scad>

// hook__pegboard_square():
//
// Template of square-hole pegboard hook
// 方孔板挂钩模板
//
// Parameters(All in mm):
//    l: width
//    h: height
//    th: thickness(default: 2)
//    hole_x,hole_y: sizeof hole(default: 10)
//    board_thick: thickness of pegboard(default: 2)
//    center_distance: center distance between holes(default: 38)
module hook__pegboard_square(l=70, h=70, th=2,hole_x=10,hole_y=10,board_thick=2,center_distance=38,rounded=true,center=false) {
    assert(l>=10,"Length must be >=10");
    assert(h>=10,"Height must be >=10");
    e=0.5;
    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-center_distance/2)/center_distance)];
    offset=[(l-((stps.x-1)*center_distance+10))/2, (h-((stps.y-1)*center_distance+10))/2];
    difference() {
        if (rounded) {
            board(l,h,th=th,r=th,$fn=30);
        } else {
            cube([l,h,th]);
        }
        for (x=[0:stps.x-1],y=[0:stps.y-1])
            translate([offset.x+(hole_x-e)/2+x*center_distance,offset.y+hole_y+2+y*center_distance,0]) cylinder(h=th*3,d=4.1,$fn=20,center=true);
    }
    translate([0,0,th])
            for (x=[0:stps.x-1],y=[0:stps.y-1])
                translate([offset.x+x*center_distance,offset.y+y*center_distance,board_thick]) hook();

    module hook() {
        union() {
            difference() {
                union() {
                    difference() {
                        cube([hole_x-e,hole_y-e,board_thick+3]);
                        //rotate([45,0,0]) translate([-0.5,0,0]) cube([hole_x-e+1,hole_y-e,hole_y]);
                    }    
                    translate([0,(hole_y-e)/2,-board_thick]) cube([hole_x-e,(hole_y-e)/2,board_thick]);
                }
                translate([0,4.55,-0.25]) rotate([0,90,0]) cylinder(h=hole_x,d=1,$fn=40);
            }
        }
    }
}
//hook__pegboard_square();

module hole__pegboard_round(l=70, h=70, th=2,hole_d=6,board_thick=1,center_distance=16,center=false) {
    e=0.5;
    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-center_distance/2)/center_distance)];
    offset=[(l-((stps.x-1)*center_distance+5))/2, (h-((stps.y-1)*center_distance+15.5))/2];
    difference() {
        translate([0,0,0]) board(l,h,th=th+2.5,r=th+2.5);
        for (x=[0:stps.x-1],y=[0:stps.y-1])
            translate([offset.x+(hole_d-e)/2+x*center_distance,offset.y+hole_d+2+y*center_distance,0]) hole();
    }
    module hole() {
        translate([0,0,-0.1]) cylinder(d=hole_d+0.5,h=th+3);
        translate([0,0,th]) cylinder(d=10,h=4);
    }
}

module hook__pegboard_round(l=100, h=70, th=2,hole_d=5.5,board_thick=1,center_distance=16,rounded=true,center=false) {
    assert(l>=10,"Length must be >=10");
    assert(h>=29,"Height must be >=29");

    e=0.5;
//    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-center_distance/2)/center_distance)];
    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-hole_d-e)/center_distance)];
    echo(stps);
    offset=[(l-((stps.x-1)*center_distance+5))/2, h-(stps.y-1)*(center_distance)-hole_d/2-1];

    difference() {
        if (rounded) {
            board(l,h,th=th,r=th+2.5);
        } else {
            cube([l,h,th]);
        }
        translate([
                    offset.x+(hole_d-e)/2+floor(stps.x/2)*center_distance,
                    offset.y,
                    -0.5]) cylinder(d=hole_d+1,h=th+1);
    }
    for (x=[0:stps.x-1],y=[0:stps.y-2])
        if ((x!=floor(stps.x/2)) || (y!=0))
            translate([
                offset.x+(hole_d-e)/2+x*center_distance,
                offset.y+y*center_distance,
                th]) stick();
    for (x=[0:stps.x-1],y=stps.y-1)
        if ((x!=floor(stps.x/2)) || (y!=0))
            translate([offset.x+(hole_d-e)/2+x*center_distance,offset.y+y*center_distance,th]) hook();

    module hook() {
        translate([0,10,0]) mirror([0,1,0]) {
            $fn=90;
            rotate([90,0,90])  rotate_extrude(angle=90) translate([10,0,0]) circle(d=hole_d);
            translate([0,0,10]) sphere(d=hole_d);
        }
    }
    module stick() {
        cylinder(d=hole_d,h=board_thick+7-hole_d/2);
        translate([0,0,board_thick+7-hole_d/2]) sphere(d=hole_d);
    }
}

module nhf_tool_pegaboard(dim=[100,70,2], boardtype="round_hole",board_thick=2, center_distance=[26,26], hole=[5.5], center=false,rounded=true) {
	if (boardtype=="round_hole") {
		hook__pegboard_round(l=dim.x, h=dim.y, th=dim.z, hold_d=hole.x, center_distance=center_distance.x, center=center,rounded=rounded);
	} else if (boardtype=="square_hole") {
		hook__pegboard_square(l=dim.x, h=dim.y, th=dim.z, hole_x=hole.x, hole_y=hole.y, board_thick=board_thick,center_distance=center_distance.x, rounded=rounded, center=center);
	}
}

//nhf_tool_pegaboard(dim=[120,120,2]);

module board__pegboard_Skadis(l=175, h=175, th=2,hole_d=5.5,center=false) {
    assert(l>=10,"Length must be >=10");
    assert(h>=15,"Height must be >=15");
    e=0.5;

    center_distance=40;
    hole_x=5;
    hole_y=14.75;
    board_thick=4.5;

    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-center_distance/2)/center_distance)];
    offset=[(l-((stps.x-1)*center_distance+5))/2, (h-((stps.y-1.75)*center_distance+20))/2];

    difference() {
        board(l,h,th=th,r=th+2.5,$fn=30);
        for (x=[0:stps.x],y=[0:stps.y])
            translate([center_distance/4+x*center_distance, center_distance/4+y*center_distance]) {
                neg_hole();
                translate([center_distance/2,center_distance/2,0]) neg_hole();
            }
    }
    module neg_hole() {
        board(5,14.75,r=2.5,th=13,$fn=90);
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
