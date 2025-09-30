use <nhf/algos/math.scad>
use <nhf/algos/list.scad>

/*
 * Negtive plate
 *  nhf_shape_neg_plate(type, dim, arg)
 *      dim: [X,Y,Z]
 *      type:
 *          "louver": louvered grille
 *              arg[0]: grille size
 *              arg[1]: gap size
 *          "hive": hive shaped grille
 *              arg[0]: hole diameter
 *              arg[1]: grille width
 */
module nhf_shape_neg_plate(type="louver", dim=[100,100,4], arg=undef) {
	if (type=="louver") {
		param_blade = arg==undef?2:arg[0];
		param_spacing = arg==undef?1.5:arg[1];
		nhf_neg_louver(dim=dim,blade=param_blade,spacing=param_spacing);
	} else if (type=="hive") {
		param_hole_d = arg==undef?35:arg[0];
		param_hole_gap = arg==undef?3:arg[1];
		neg_hive(dim=dim, hole_d=param_hole_d, th=param_hole_gap);
	}
}

/*
 * Negtive plate
 *  nhf_shape_neg_plate(type, dim, arg)
 *      dim: [X,Y,Z]
 *      type:
 *          "louver": louvered grille
 *              arg[0]: grille size
 *              arg[1]: gap size
 *          "hive": hive shaped grille
 *              arg[0]: hole diameter
 *              arg[1]: grille width
 */
module nhf_shape_neg_shaft(type="D",d=10,h=20, center=false, arg=undef) {
    if (type=="D") {
        nhf_neg_DShaft(d=d,h=h,D=(arg==undef?2:arg[0]),H=(arg==undef?h:arg[1]),center=center);
    } else {
        assert(true, "Unknown type");
    }
}

nhf_shape_neg_plate(dim=[110,100,10],arg=[1,5]);
/************************************************************************/

module nhf_neg_DShaft(d=10,D=2,h=20,H=20,center=false) {
    assert(D<=d,"D is too great");
    assert(H<=h,"H is too great");
    difference() {
        cylinder(d=d,h=h,center=center);
        translate([d/2-D+(center==true?d/2:0),center==true?0:-d/2,h-H]) cube([d,d,h+1],center=center);
    }
}

module nhf_neg_saving(dim=[110,100,10],th=3,O=[0,0,0]) {
    assert(dim.x>th*2,"th is too big");
    if (dim.x>dim.y) {
        nhf_neg_saving(dim=[dim.x/2-th/2,dim.y,dim.z],th=th,O=O);
        nhf_neg_saving(dim=[dim.x/2-th/2,dim.y,dim.z],th=th,O=O+[dim.x/2+th/2,0,0]);
    } else {
        linear_extrude(height=dim.z,convexity=3) {
        polygon([
            [O.x+th/2/sin(atan2(dim.y,dim.x)),O.y],
            [O.x+dim.x,O.y],
            [O.x+dim.x,O.y+dim.y-th/2/cos(atan2(dim.y,dim.x))]
        ]);
        polygon([
            [O.x,O.y+th/2/cos(atan2(dim.y,dim.x))],
            [O.x+dim.x-th/2/sin(atan2(dim.y,dim.x)),O.y+dim.y],
            [O.x,O.y+dim.y]
        ]);
        //polygon([
        //    [O.x,O.y+dim.y-th/2/cos(atan2(dim.y,dim.x))],
        //    [O.x,O.y],
        //    [O.x,O.y-dim.y-th/2/cos(45)]
        //]);
        }
    }
}

module nhf_neg_louver(dim=[100,100,4],blade=2,spacing=1.5) {
    assert(spacing>0,"spacing must >0");
    intersection() {
        cube(dim);
        mirror([0,0,1])
            rotate([-90,0,0])
                linear_extrude(dim.y,convexity=10) 
                    for (x=[-(blade+spacing):blade+spacing:dim.x+blade+spacing])
                        translate([x,0])
                            polygon([
                                [0,0],
                                [spacing,0],
                                [spacing+dim.z/2,dim.z/2],
                                [spacing,dim.z],
                                [0,dim.z],
                            [dim.z/2,dim.z/2]]);
    }
}

module neg_hive(dim=[500,500,10],hole_d=35, th=3) {
    assert(th>0,"th must >0");
    natural_th=(1-sqrt(3)/2)*hole_d;
    adjust=th-natural_th;
    intersection() {
        cube(dim);
        for (x=[0:hole_d+adjust:dim.x+hole_d],y=[0:(hole_d+adjust)*sqrt(3):dim.y+hole_d]) {
            translate([x,y,-1])
                rotate([0,0,30]) cylinder(d=hole_d,h=30,$fn=6);
            translate([x+(hole_d+adjust)/2,y+(hole_d+adjust)*(sqrt(3)/2),-1])
                rotate([0,0,30]) cylinder(d=hole_d,h=30,$fn=6);//
        }
    }
}

module nhf_neg_cone_hive(d=100,h=100,hole_d=2, th=0.5, center=false) {
    assert(th>0,"th must >0");
    hole_d_x = hole_d * cos(30);
    n=ceil(d*3.1416/(hole_d_x+th));
    step_theta=360/n;
    step_z = 2*(d*3.1416)/n*cos(30);
    
    for (z=[0:step_z:h+step_z],th=[0:step_theta:360]) {
        translate([0,0,z])
            rotate([0,90,th])
                cylinder(d1=0,d2=hole_d,h=d/2+0.1,$fn=6);
        translate([0,0,z+step_z/2])
            rotate([0,90,th+step_theta/2])
                cylinder(d1=0,d2=hole_d,h=d/2+0.1,$fn=6);
    }
}

