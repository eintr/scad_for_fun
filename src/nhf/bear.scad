
module nhf_bear(din=10,dout=30,th=9) {
    color("gray")
        difference() {
            cylinder(d=dout,h=th);
            translate([0,0,-0.5]) cylinder(d=din,h=th+1);
        }
}

module bear_6200() {
    nhf_bear(din=10,dout=30,th=9);
}
