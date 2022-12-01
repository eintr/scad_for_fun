use <list.scad>
use <math.scad>

$fn=100;

// Example:
//gear(z=9,m=2,b=10);

module gear(z=17, m=4, b=3) {
    d = m*z;
    db= m*(z-2);
    da = m*(z+2);

    poly_tooth = f_involute(r0=db/2, r1=da/2);
    beta = find_theta(poly_tooth,d/2);

    difference() {
        difference() {
            union() {
                // Fixme: 暂时拿基圆当作齿根圆
                cylinder(h=b, d=db,center=true);
                // 画齿
                for (i=[0:1:z-1])
                    rotate([0,0,360/z*i])
                        tooth0(b=b, rb=db/2, z=z, m=m);
            };
            // 车齿顶
            difference() {
                cylinder(h=b+0.001,d=da*2,center=true);
                cylinder(h=b+0.001,d=da,center=true);
            };
        };
        // 车分度圆划痕
        union() {
            translate([0,0,b/2]) difference() {
                cylinder(h=b/200,d=d+b/200,center=true);
                cylinder(h=b/200,d=d-b/200,center=true);
            }
            translate([0,0,-b/2]) difference() {
                cylinder(h=b/200,d=d+b/200,center=true);
                cylinder(h=b/200,d=d-b/200,center=true);
            }
        }
    }
}

module tooth0(b, rb, z, m) {
    d = z * m;
    da = m*(z+2);
    pol = concat(f_involute(r0=rb, r1=da/2+(da/2-rb)),[[0,d/2]]);
    beta = find_theta(pol, d/2);
    intersection() {
        tooth_surface(b,rb,da/2,pol);
        rotate([180,0,360/z-(180/z-2*beta)]) tooth_surface(b,rb,da/2,pol);
    }
}

module tooth_surface(b, rb, ra, poly) {
    translate([0,0,-b/2]) linear_extrude(height=b) polygon(poly);
}

function f_involute(r0, r1)  = [
for (alpha=0; distance2([ r0*cos(alpha)+alpha*PI/180*r0*sin(alpha), r0*sin(alpha)-alpha*PI/180*r0*cos(alpha) ]) < r1; alpha=alpha+.3)
    [
        r0*cos(alpha)+alpha*PI/180*r0*sin(alpha),
        r0*sin(alpha)-alpha*PI/180*r0*cos(alpha)
    ]
];

function find_theta(L,d) = distance2(head(L))>=d ? atan2(head(L).y, head(L).x) : find_theta(tail(L),d);
