include <nhf/algos/transform.scad>

module nhf_sweep(path) {
    assert(len(path)>=3, "Path is too short");

    for (i=[0:1:len(path)-3]) {
        hull() {
            translate(path[i])
                nhf_rotate_toward(path[i+1]-path[i])
                    linear_extrude(0.01) children();
            translate(path[i+1])
                nhf_rotate_toward(path[i+2]-path[i+1])
                    linear_extrude(0.01) children();
        }
    }
    hull() {
        translate(path[len(path)-2])
            nhf_rotate_toward(path[len(path)-1]-path[len(path)-2])
                linear_extrude(0.01) children();
        translate(path[len(path)-1])
            nhf_rotate_toward(path[len(path)-1]-path[len(path)-2])
                linear_extrude(0.01) children();
    }
}
