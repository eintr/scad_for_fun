use <nhf/algos/math.scad>
use <nhf/algos/list.scad>

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

module nhf_elbow(r=30,angle=90) {
	translate([-r,0,0])
		rotate([90,0,0])
			rotate_extrude(angle=angle)
				translate([r,0,0])
					projection()
						children();
}

/*******************************************************************************************************************************************/

//function cosv(v) = v.x/sqrt(v.x*v.x+v.y*v.y);
//function sinv(v) = v.y/sqrt(v.x*v.x+v.y*v.y);
//
//function cos_add(delta,theta) = cosv(delta)*cos(theta) - sinv(delta)*sin(theta);
//function sin_add(delta,theta) = sinv(delta)*cos(theta) + cosv(delta)*sin(theta);
//
//function delta_next(pol) = [car(cdr(pol)).x-car(pol).x, car(cdr(pol)).y-car(pol).y];
//
//function cos_2_sub_1_div_2(delta1,delta2) = 1/sqrt((1+cosv(delta2)*cosv(delta1)+sinv(delta2)*sinv(delta1))/2);
//function cos_2_add_1_div_2(delta1,delta2) = 1/sqrt((1+cosv(delta2)*cosv(delta1)-sinv(delta2)*sinv(delta1))/2);
//function sin_2_add_1_div_2(delta1,delta2) = 1/sqrt((1-cosv(delta2)*cosv(delta1)+sinv(delta2)*sinv(delta1))/2);
//
//function outlet_wall(pol=[],width=2,_result=[],_v0=[1,0]) = (pol==[])?_result:(
//    (_result==[])?( // The first point
//        outlet_wall(
//            pol=cdr(pol),
//            width=width,
//            _result=[
//                [
//                    car(pol).x+width*1.42421*cos_add(delta_next(pol),135),
//                    car(pol).y+width*1.42421*sin_add(delta_next(pol),135)
//                ],[
//                    car(pol).x+width*1.42421*cos_add(delta_next(pol),-135),
//                    car(pol).y+width*1.42421*sin_add(delta_next(pol),-135)
//                ]
//            ],
//            _v0=delta_next(pol))
//    ):(cdr(pol)==[])?(  // The last point
//        concat([[
//                car(pol).x+width*1.42421*cos_add(_v0,45),
//                car(pol).y+width*1.42421*sin_add(_v0,45)
//            ]],_result,[[
//                car(pol).x+width*1.42421*cos_add(_v0,-45),
//                car(pol).y+width*1.42421*sin_add(_v0,-45)
//            ]]
//        )
//    ):(
//        outlet_wall(
//            pol=cdr(pol),
//            width=width,
//            _result = concat([[
//                    car(pol).x + width/2*cos_2_sub_1_div_2(delta_next(pol),_v0) * -sin_2_add_1_div_2(delta_next(pol),_v0),
//                    car(pol).y + width/2*cos_2_sub_1_div_2(delta_next(pol),_v0) * cos_2_add_1_div_2(delta_next(pol),_v0)
//                ]],_result,[[
//                    car(pol).x - width/2*cos_2_sub_1_div_2(delta_next(pol),_v0) * -sin_2_add_1_div_2(delta_next(pol),_v0),
//                    car(pol).y - width/2*cos_2_sub_1_div_2(delta_next(pol),_v0) * cos_2_add_1_div_2(delta_next(pol),_v0)
//                ]]
//            ),
//            _v0=delta_next(pol)
//        )
//    )
//);

module cylinder_D_shaft(d=10,h=20, shaft_depth=2, shaft_h=10) {
    difference() {
        cylinder(d=d,h=h);
        translate([d/2-shaft_depth,-d/2,h-shaft_h]) cube([d,d,shaft_h+0.1]);
    }
}

