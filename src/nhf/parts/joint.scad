
module nhf_tools_joint(type="dovetail",part="pos",l=30,h=5,depth=10,e=0.1) {
    if (type=="dovetail") {
        if (part=="pos") {
            joint_dovetail_pos(l=l,h=h,depth=depth,e=e);
        } else if (part=="neg") {
            joint_dovetail_neg(l=l,h=h,depth=depth,e=e);
        }
    } else {
        assert(false, "Unsupported joint type!");
    }
}

module joint_dovetail_pos(l=30,h=5,depth=10,e=0.4) {
    r=2;
    linear_extrude(h-e)
        difference() {
            offset(r=r,$fn=30)
                offset(r=-r-e) {
                    polygon([
                        [0,0],
                        [-depth, depth],
                        [l-depth,depth],
                        [l-depth*2,0]]
                    );
                    translate([-depth,-10]) square([l,10]);
                }
            translate([-depth,-10]) square([l,10]);
        }
}

module joint_dovetail_neg(l=30,h=10,depth=10,e=0.1) {
    r=2;
    linear_extrude(h)
        difference() {
            offset(r=r,$fn=30)
                offset(r=-r) {
                    polygon([
                        [0,0],
                        [-depth, depth],
                        [l-depth,depth],
                        [l-depth*2,0]]
                    );
                    translate([-depth,-10]) square([l,10]);
                }
            translate([-depth,-10]) square([l,10]);
        }
}
