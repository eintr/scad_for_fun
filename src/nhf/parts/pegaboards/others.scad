
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
