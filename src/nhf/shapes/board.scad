
module nhf_shape_board(dim=[20,20,20],r=5,center=false) {
    nhf_board(dim=dim,r=r,center=center);
}

/*******************************************************************************/

module board(x,y,r=5,th=1,center=false) { // Deprecated, use nhf_board().
    hull() {
        for (pos_x=[(center?-x/2:0)+r,(center?x/2:x)-r])
            for (pos_y=[(center?-y/2:0)+r,(center?y/2:y)-r])
                translate([pos_x, pos_y, 0]) cylinder(r=r,h=th);
    }
}

module nhf_board(dim=[20,20,20],r=5,center=false) {
    assert(dim.x>=2*r && dim.y>=2*r, "dim.x or dim.y is too small");
    translate(center ? [0,0,-dim.z/2] : [dim.x/2,dim.y/2,0])
        hull() {
            for (pos_x=[-dim.x/2+r,dim.x/2-r], pos_y=[-dim.y/2+r,dim.y/2-r])
                    translate([pos_x, pos_y, 0]) cylinder(r=r,h=dim.z);
        }
}
//nhf_board([50,30,40],center=true);

module board_round(dim=[200,300,100],rxy=12,rz=6) {
    assert(dim.x>rxy*2+rz*2 && dim.y>rxy*2+rz*2, "dim is too small");
    assert(rxy>=rz, "rxy must ge than d");
	assert(dim.z>=rz*2, "dim.z must ge than d");
    translate([rxy,rxy,rz])
        hull()
			for(z=[0,dim.z-rz*2]) {
				for (p=[[0,0,180],[dim.x-rxy*2,0,-90],[dim.x-rxy*2,dim.y-rxy*2,0],[0,dim.y-rxy*2,90]]) {
					translate([p.x,p.y,z]) rotate([0,0,p.z]) rotate_extrude(angle=90) translate([rxy-rz,0,0]) circle(r=rz);
				}
			}
}

module cube_round(dim=[200,300,100],rxy=12,rz=6,center=false) {
	if (center) {
		translate(-[dim.x/2,dim.y/2,dim.z/2]) board_round(dim=dim,rxy=rxy,rz=rz);
	} else {
		board_round(dim=dim,rxy=rxy,rz=rz);
	}
}

/*******************************************************************************************************************************************/

module block(dim=[10,10,10], r=[3,3,3]) {
    assert(r.x<=dim.y/2 && r.x<=dim.z/2 && r.y<=dim.z/2 && r.y<=dim.x/2 && r.z<=dim.x/2 && r.z<=dim.y/2, "Size must ge than 2r");
    translate(r) minkowski() {
        cube([dim.x-r.x*2,dim.y-r.y*2,dim.z-r.z*2]);
        resize([r.x*2,r.y*2,r.z*2]) sphere(10);
    }
}

module nhf_block_minkowski(dim=[10,10,10], r=[3,3,3]) {
	block(dim=dim, r=r);
}
