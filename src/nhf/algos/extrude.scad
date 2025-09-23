
/* Example: Vase
module vase() {
    A = 100;
    fxy = function (r,theta) [r*(1+0.3*sin(theta*80))*sin(theta), r*(1+0.3*sin(theta*80))*cos(theta) ];
    difference() {
        nhf_algo_functional_extrude(height=300,f_scale=function (z) 1+sin(z*320)*0.3, f_twist=function (z) z*35) polygon([for (theta=[0:0.5:359]) fxy(A, theta)]);
        translate([0,0,15]) cylinder(h=HEIGHT*2,d=A*.6+30);
    }
}
vase();
*/

/* Example: Pillar *
module pillar() {
    nhf_algo_functional_extrude(height=300,steps=19,f_skew=[function(zn) 200*(zn*zn-zn), 0], f_scale=function (zn) 1+sin(zn*320)*0.3, f_twist=function (zn) zn*90) scale([0.5,1]) circle(r=50);
}
pillar();
*/

/* Example: Pillar *
module katana() {
    poly = [[0,2],[1,1],[0.5,-1.5],[-0.5,-1.5],[-1,1]];
    nhf_algo_functional_extrude(height=200,f_skew=[0, function(z) 20*(z*z-z)]) polygon(poly);
}

katana();
*/

/****************************************************************************************/

/*
 *  height: Extrusion height.
 *  steps:  Iteration steps.
 *  f_skew.x: Skew in X axis along with Z axis.
 *  f_skew.y: Skew in Y axis along with Z axis.
 *  f_scale:    Size scales along with Z axis.
 *  f_twist:    Twist in Z direction along with Z axis.
 */
module nhf_algo_functional_extrude(height, step=0, steps=100, f_skew=[f_constant(0),f_constant(0)], f_scale=f_constant(1), f_twist=f_constant(0)) {
	functional_extrude(height, step=step, steps=steps, f_skew=f_skew, f_scale=f_scale, f_twist=f_twist);
}

/****************************************************************************************/

module functional_extrude(height, step=0, steps=100, f_skew=[f_constant(0),f_constant(0)], f_scale=f_constant(1), f_twist=f_constant(0)) {
    if (is_num(f_skew.x)) {
        functional_extrude(height=height, step=step, steps=steps, f_skew=[f_constant(f_skew.x),f_skew.y],f_scale=f_scale, f_twist=f_twist) children();
    } else if (is_num(f_skew.y)) {
        functional_extrude(height=height, step=step, steps=steps, f_skew=[f_skew.x,f_constant(f_skew.y)],f_scale=f_scale, f_twist=f_twist) children();
    } else if (step<steps) {
        zn = step/(steps);
        union() {
            dx = (f_skew.x(zn+1/steps)-f_skew.x(zn));
            dy = (f_skew.y(zn+1/steps)-f_skew.y(zn));
            tx = dx/(height/steps);
            ty = dy/(height/steps);
            t = [
                [1, 0,  tx,  0],
                [0, 1,  ty,  0],
                [0, 0,  1,   0],
                [0, 0,  0,   1],
            ];
            translate([f_skew.x(zn),f_skew.y(zn),zn*height])
                multmatrix(t)
                    linear_extrude(height=height/steps, scale=f_scale(zn+1/steps)/f_scale(zn), twist=f_twist(zn)-f_twist(zn+1/steps))
                        scale([f_scale(zn),f_scale(zn),1])
                            rotate([0,0,f_twist(zn)])
                                children(0);
            functional_extrude(height=height, step=step+1, steps=steps, f_skew=f_skew, f_scale=f_scale, f_twist=f_twist) children(0);
        }
    }
}
function f_constant(c=1) = function (x) c;