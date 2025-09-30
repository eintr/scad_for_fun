
/* Really need a 3D offset() to do this correctly. */
module nhf_derivate_shell_out(r=undef) {
    if (r!=undef) {
        difference() {
            minkowski(convexity=9) {
                sphere(r=r);
                children();
            }
            children();
        }
    }
}

difference() {
    nhf_derivate_shell_out(r=1,$fn=18) {
        cube([20,30,40]);
        cube([20,30,40],center=true);
    }
    translate([-20,10,-10]) cube([50,50,60]);
}