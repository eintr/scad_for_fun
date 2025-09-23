//use <nhf/shapes.scad>

module hook__pegboard_round(l=100, h=70, th=2,hole_d=5.5,board_thick=1,center_distance=16,rivet_at=[-1,-1],rounded=true,center=false) {
    assert(l>=10,"Length must be >=10");
    assert(h>=29,"Height must be >=29");
    
    e=0.5;
//    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-center_distance/2)/center_distance)];
    stps=[ceil((l-center_distance/2)/center_distance),ceil((h-hole_d-e)/center_distance)];
    echo(stps);
    offset=[(l-((stps.x-1)*center_distance+5))/2, h-(stps.y-1)*(center_distance)-hole_d/2-1];
    rivet_hole=[rivet_at.x<0?floor(stps.x/2):rivet_at.x,rivet_at.y<0?0:rivet_at.y];

    difference() {
        if (rounded) {
            board(l,h,th=th,r=th+2.5);
        } else {
            cube([l,h,th]);
        }
        translate([
                    offset.x+(hole_d-e)/2+rivet_hole.x*center_distance,
                    offset.y+rivet_hole.y*center_distance,
                    -0.5]) cylinder(d=hole_d+1,h=th+1);
    }
    for (x=[0:stps.x-1],y=[0:stps.y-2])
        if ((x!=rivet_hole.x) || (y!=rivet_hole.y))
            translate([
                offset.x+(hole_d-e)/2+x*center_distance,
                offset.y+y*center_distance,
                th]) stick();
    for (x=[0:stps.x-1],y=stps.y-1)
        if ((x!=rivet_hole.x) || (y!=rivet_hole.x))
            translate([offset.x+(hole_d-e)/2+x*center_distance,offset.y+y*center_distance,th]) hook();
    
    module hook() {
        translate([0,10,0]) mirror([0,1,0]) {
            $fn=90;
            rotate([90,0,90])  rotate_extrude(angle=90) translate([10,0,0]) circle(d=hole_d);
            translate([0,0,10]) sphere(d=hole_d);
        }
    }
    module stick() {
        cylinder(d=hole_d,h=board_thick+7-hole_d/2,$fn=9);
        translate([0,0,board_thick+7-hole_d/2]) sphere(d=hole_d,$fn=9);
    }
}
