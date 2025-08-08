//motor_2032();
module motor_2032() {
    difference() {
        union() {
            cylinder(d=20.3,h=32,$fn=60);
            translate([0,0,32]) cylinder(d=8,h=1.5,$fn=60);
            translate([0,0,-2.4]) cylinder(d=6.3,h=2.4,$fn=60);
            cylinder(d=2,h=40,$fn=60);
        }
        translate([0,-20-15.5/2,19]) cube([40,40,40],center=true);
        translate([0,20+15.5/2,19]) cube([40,40,40],center=true);
        translate([13/2,0,32-4]) cylinder(d=1.4,h=5,$fn=60);
        translate([-13/2,0,32-4]) cylinder(d=1.4,h=5,$fn=60);
    }
    rotate([0,0,-10]) {
        translate([7.5,0,-4.3/2]) cube([2,0.5,4.3],center=true);
        translate([-7.5,0,-4.3/2]) cube([2,0.5,4.3],center=true);
    }
}

// motor_w_plate();
module motor_w_plate() {
    difference() {
        union() {
            translate([-24,-20,0]) cube([40,40,5]);
            translate([-24,-20,-60+5]) cube([5,40,60]);
        }
        translate([0,14,0]) hole();
        translate([0,-14,0]) hole();
        translate([0,14,-34]) hole();
        translate([0,-14,-34]) hole();
    }
    translate([0,0,-57.4]) cylinder(d=35.8,h=57.4,$fn=100);
    
    translate([0,0,5]) cylinder(d=21.5,h=20.5);
    translate([0,0,25.5]) cylinder(d=15.2,h=8,8,$fn=60);
    translate([0,0,25.5+8]) cylinder(d1=6.4,d2=3.8,h=6.2,$fn=6);

    rotate([0,0,90]) {
        translate([13.75,0,-60.4]) cube([0.5,3.8,6],center=true);
        translate([-13.75,0,-60.4]) cube([0.5,3.8,6],center=true);
    }
    module hole() {
        translate([-21.5,-2,-11]) rotate([0,90,0]) hull() {
            cylinder(d=4.1,h=6,center=true,$fn=60);
            translate([0,4,0]) cylinder(d=4.1,h=6,center=true,$fn=60);
        }
    }
}

module motor_300($fn=18) {
    cylinder(d=24.4,h=12.5);
    cylinder(d=2,h=21.5);
    translate([0,0,-1]) cylinder(d=6.1,h=1);
    translate([0,0,12.5]) cylinder(d=6.5,h=0.8);
}
