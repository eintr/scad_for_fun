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

module nhf_sweep2(path) {
    assert(len(path)>=3, "Path is too short");

    hull() {
        translate(path[0])
            nhf_rotate_toward(path[1]-path[0])
                linear_extrude(0.01) children();
        translate(path[1])
            nhf_rotate_toward(path[2]-path[0])
                linear_extrude(0.01) children();
    }
    for (i=[1:1:len(path)-3]) {
        hull() {
            translate(path[i])
                nhf_rotate_toward(path[i+1]-path[i-1])
                    linear_extrude(0.01) children();
            translate(path[i+1])
                nhf_rotate_toward(path[i+2]-path[i])
                    linear_extrude(0.01) children();
        }
    }
    hull() {
        translate(path[len(path)-2])
            nhf_rotate_toward((path[len(path)-1]-path[len(path)-3]))
                linear_extrude(0.01) children();
        translate(path[len(path)-1])
            nhf_rotate_toward(path[len(path)-1]-path[len(path)-2])
                linear_extrude(0.01) children();
    }
}

//nhf_sweep2([[10,10,10],[0,10,0],[0,-10,0],[20,20,-20]])    circle(d=10);