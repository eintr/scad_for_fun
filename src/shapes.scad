use <nhf/math.scad>
use <nhf/list.scad>

function line_circle(d,cx=0,cy=0,deg0=0,deg1=360,_steps=20) = (deg1>deg0)?
    [for(step=0,deg=deg0;step<=_steps;step=step+1,deg=deg+(deg1-deg0)/_steps) [cx+(d/2)*cos(deg),cy+(d/2)*sin(deg)]]:
    [for(step=0,deg=deg0;step<=_steps;step=step+1,deg=deg-(deg0-deg1)/_steps) [cx+(d/2)*cos(deg),cy+(d/2)*sin(deg)]];

function line_involute(r0, r1=undef, theta=undef, gamma=0) = (theta!=undef)?
    [for (alpha=0; alpha < theta; alpha=alpha+.3)
        [
            r0*cos(alpha+gamma)+alpha*PI/180*r0*sin(alpha+gamma),
            r0*sin(alpha+gamma)-alpha*PI/180*r0*cos(alpha+gamma)
        ]
    ]
    :
    [for (alpha=0; distance2([ r0*cos(alpha)+alpha*PI/180*r0*sin(alpha), r0*sin(alpha)-alpha*PI/180*r0*cos(alpha) ]) < r1; alpha=alpha+.3)
        [
            r0*cos(alpha+gamma)+alpha*PI/180*r0*sin(alpha+gamma),
            r0*sin(alpha+gamma)-alpha*PI/180*r0*cos(alpha+gamma)
        ]
    ];

/*******************************************************************************************************************************************/

module ring(din,th=5,h=5,deg0=0,deg1=360) {
    dout=din+th*2;
    rotate([0,0,min(deg1,deg0)]) rotate_extrude(angle=abs(deg1-deg0)) translate([din/2,0]) square([th,h]);
}

/*******************************************************************************************************************************************/

module board(x,y,r=5,th=1,center=false) {
    hull() {
        for (pos_x=[(center?-x/2:0)+r,(center?x/2:x)-r])
            for (pos_y=[(center?-y/2:0)+r,(center?y/2:y)-r])
                translate([pos_x, pos_y, 0]) cylinder(r=r,h=th);
    }
}

module nhf_board(dim=[20,20,20],r=5,center=false) {
    hull() {
        for (pos_x=[(center?-dim.x/2:0)+r,(center?dim.x/2:dim.x)-r])
            for (pos_y=[(center?-dim.y/2:0)+r,(center?dim.y/2:dim.y)-r])
                translate([pos_x, pos_y, 0]) cylinder(r=r,h=dim.z);
    }
}

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

/*******************************************************************************************************************************************/

module nhf_elbow(r=30,angle=90) {
	translate([-r,0,0])
		rotate([90,0,0])
			rotate_extrude(angle=angle)
				translate([r,0,0])
					projection()
						children();
}

/*******************************************************************************************************************************************/

function cosv(v) = v.x/sqrt(v.x*v.x+v.y*v.y);
function sinv(v) = v.y/sqrt(v.x*v.x+v.y*v.y);

function cos_add(delta,theta) = cosv(delta)*cos(theta) - sinv(delta)*sin(theta);
function sin_add(delta,theta) = sinv(delta)*cos(theta) + cosv(delta)*sin(theta);

function delta_next(pol) = [car(cdr(pol)).x-car(pol).x, car(cdr(pol)).y-car(pol).y];

function cos_2_sub_1_div_2(delta1,delta2) = 1/sqrt((1+cosv(delta2)*cosv(delta1)+sinv(delta2)*sinv(delta1))/2);
function cos_2_add_1_div_2(delta1,delta2) = 1/sqrt((1+cosv(delta2)*cosv(delta1)-sinv(delta2)*sinv(delta1))/2);
function sin_2_add_1_div_2(delta1,delta2) = 1/sqrt((1-cosv(delta2)*cosv(delta1)+sinv(delta2)*sinv(delta1))/2);

function outlet_wall(pol=[],width=2,_result=[],_v0=[1,0]) = (pol==[])?_result:(
    (_result==[])?( // The first point
        outlet_wall(
            pol=cdr(pol),
            width=width,
            _result=[
                [
                    car(pol).x+width*1.42421*cos_add(delta_next(pol),135),
                    car(pol).y+width*1.42421*sin_add(delta_next(pol),135)
                ],[
                    car(pol).x+width*1.42421*cos_add(delta_next(pol),-135),
                    car(pol).y+width*1.42421*sin_add(delta_next(pol),-135)
                ]
            ],
            _v0=delta_next(pol))
    ):(cdr(pol)==[])?(  // The last point
        concat([[
                car(pol).x+width*1.42421*cos_add(_v0,45),
                car(pol).y+width*1.42421*sin_add(_v0,45)
            ]],_result,[[
                car(pol).x+width*1.42421*cos_add(_v0,-45),
                car(pol).y+width*1.42421*sin_add(_v0,-45)
            ]]
        )
    ):(
        outlet_wall(
            pol=cdr(pol),
            width=width,
            _result = concat([[
                    car(pol).x + width/2*cos_2_sub_1_div_2(delta_next(pol),_v0) * -sin_2_add_1_div_2(delta_next(pol),_v0),
                    car(pol).y + width/2*cos_2_sub_1_div_2(delta_next(pol),_v0) * cos_2_add_1_div_2(delta_next(pol),_v0)
                ]],_result,[[
                    car(pol).x - width/2*cos_2_sub_1_div_2(delta_next(pol),_v0) * -sin_2_add_1_div_2(delta_next(pol),_v0),
                    car(pol).y - width/2*cos_2_sub_1_div_2(delta_next(pol),_v0) * cos_2_add_1_div_2(delta_next(pol),_v0)
                ]]
            ),
            _v0=delta_next(pol)
        )
    )
);


module cylinder_D_shaft(d=10,h=20, shaft_depth=2, shaft_h=10) {
    difference() {
        cylinder(d=d,h=h);
        translate([d/2-shaft_depth,-d/2,h-shaft_h]) cube([d,d,shaft_h+0.1]);
    }
}

/*******************************************************************************************************************************************/

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

/*******************************************************************************************************************************************/

// 正二十面体 (Icosahedron) 示例 —— OpenSCAD

// 参数：边长
module nhf_icosahedron(edge=20) {
    function norm(v) = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
        // 黄金分割率
    phi = (1 + sqrt(5)) / 2;

    // 原始顶点坐标（未缩放），采用黄金分割构造法
    verts_unit = [
        [ 0,  1,  phi],
        [ 0, -1,  phi],
        [ 0,  1, -phi],
        [ 0, -1, -phi],
        [ 1,  phi,  0],
        [-1,  phi,  0],
        [ 1, -phi,  0],
        [-1, -phi,  0],
        [ phi,  0,  1],
        [ phi,  0, -1],
        [-phi,  0,  1],
        [-phi,  0, -1]
    ];

    // 面（每 3 个索引为一个三角面），索引从 0 开始
    faces = [
        [ 0,  1,  8], [ 0,  1, 10],
        [ 2,  3,  9], [ 2,  3, 11],
        [ 4,  5,  0], [ 4,  5,  2],
        [ 6,  7,  1], [ 6,  7,  3],
        [ 8,  9,  4], [ 8,  9,  6],
        [10, 11,  5], [10, 11,  7],
        [ 0,  4,  8], [ 0,  5, 10],
        [ 1,  6,  8], [ 1,  7, 10],
        [ 2,  4,  9], [ 2,  5, 11],
        [ 3,  6,  9], [ 3,  7, 11]
    ];

    // 计算单位向量长度，并算出缩放因子使得边长为 edge
    // 顶点之间实际的 unit-edge 可以通过两点距离算出，这里简化硬编码：
    unit_edge = norm(verts_unit[0] - verts_unit[1]);  // 理论上约 = 2.0
    scale_factor = edge / unit_edge;

    // 主函数：绘制 polyhedron
    polyhedron(
        points = [ for (v = verts_unit) [ v[0]*scale_factor, v[1]*scale_factor, v[2]*scale_factor ] ],
        faces  = faces
    );
}
