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
        cube([l,h,th]);
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
