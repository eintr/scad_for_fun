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
module hook__pegboard_square(l=70, h=70, th=2,hole_x=10,hole_y=10,board_thick=2,center_distance=38) {
    e=0.5;
    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-center_distance/2)/center_distance)];
    offset=[(l-((stps.x-1)*center_distance+10))/2, (h-((stps.y-1)*center_distance+10))/2];
    difference() {
        board(l,h,th=th,r=th,$fn=30);
        for (x=[0:stps.x-1],y=[0:stps.y-1])
            translate([offset.x+(hole_x-e)/2+x*center_distance,offset.y+hole_y+2+y*center_distance,0]) cylinder(h=4,d=4.1,$fn=20,center=true);
    }
    translate([0,0,th])
            for (x=[0:stps.x-1],y=[0:stps.y-1])
                translate([offset.x+x*center_distance,offset.y+y*center_distance,0]) hook();
    
    module hook() {
        union() {
            translate([0,0,board_thick]) difference() {
                union() {
                    difference() {
                        cube([hole_x-e,hole_y-e,board_thick+3]);
                        rotate([45,0,0]) cube([hole_x-e,hole_y-e,hole_y]);
                    }    
                    translate([0,(hole_y-e)/2,-board_thick]) cube([hole_x-e,(hole_y-e)/2,board_thick]);
                }
                translate([0,4.55,-0.25]) rotate([0,90,0]) cylinder(h=hole_x,d=1,$fn=40);
            }
        }
    }
}

module hole__pegboard_round(l=70, h=70, th=2,hole_d=6,board_thick=1,center_distance=16) {
    e=0.5;
    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-center_distance/2)/center_distance)];
    offset=[(l-((stps.x-1)*center_distance+5))/2, (h-((stps.y-1)*center_distance+15.5))/2];
    difference() {
        translate([0,0,0]) board(l,h,th=th+2.5,r=th+2.5,$fn=30);
        for (x=[0:stps.x-1],y=[0:stps.y-1])
            translate([offset.x+(hole_d-e)/2+x*center_distance,offset.y+hole_d+2+y*center_distance,0]) hole();
    }
    module hole() {
        translate([0,0,-0.1]) cylinder(d=hole_d+0.5,h=th+3,$fn=90);
        translate([0,0,th]) cylinder(d=10,h=4,$fn=90);
    }
}

module hook__pegboard_round(l=70, h=70, th=2,hole_d=5.5,board_thick=1,center_distance=16) {
    e=0.5;
    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-center_distance/2)/center_distance)];
    offset=[(l-((stps.x-1)*center_distance+5))/2, (h-((stps.y-1)*center_distance+20))/2];

    board(l,h,th=th,r=th+2.5,$fn=30);
    for (x=[0:stps.x-1],y=[1:stps.y-1])
        translate([offset.x+(hole_d-e)/2+x*center_distance,offset.y+hole_d+2+y*center_distance,th]) stick();
    for (x=[0:stps.x-1],y=0)
        translate([offset.x+(hole_d-e)/2+x*center_distance,offset.y+hole_d+2+y*center_distance,th]) hook();
    module hook() {
        translate([0,-10,0]) {
            $fn=90;
            rotate([90,0,90])  rotate_extrude(angle=90) translate([10,0,0]) circle(d=hole_d);
            translate([0,0,10]) sphere(d=hole_d);
        }
    }
    module stick() {
        cylinder(d=hole_d,h=board_thick+7,$fn=90);
    }
}
