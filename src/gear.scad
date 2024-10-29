use <list.scad>
use <math.scad>

// Example:
//gear(z=28,m=1,b=10);
// z: 齿数
// m: 模数(mm)
// b: 厚度(mm)
module gear(z=17, m=4, b=3) {
    d = m*z;       // 分度圆
    db = d*cos(20);    // 基圆
    da = m*(z+2);   // 齿顶圆
    dr = d-m*(2.5+2/z);   // 齿根圆

    poly_tooth = f_involute(r0=db/2, r1=da/2);
//    beta = find_theta(poly_tooth,d/2);

    difference() {
        difference() {
            union() {
                cylinder(h=b, d=dr,center=true);
                // 画齿
                for (i=[0:1:z-1])
                    rotate([0,0,360/z*i/*-180/z*/])
                        tooth0(b=b, z=z, m=m);
            };
            // 车齿顶
            difference() {
                cylinder(h=b+0.01,d=da*2,center=true);
                cylinder(h=b+0.01,d=da,center=true);
            };
        };
        // 分度圆划痕
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

module tooth0(b, z, m) {
    d = z * m;
    da = m*(z+2);
    db = d*cos(20);
    pol = concat([[0,0]],f_involute(r0=db/2, r1=da/2+(da/2-db/2)),[[0,d/2]]);
    beta = find_theta(pol, d/2);
    intersection() {
        tooth_surface(b,db/2,da/2,pol);
        rotate([180,0,360/z-(180/z-2*beta)]) tooth_surface(b,db/2,da/2,pol);
    }
}

module tooth_surface(b, rb, ra, poly) {
    translate([0,0,-b/2]) linear_extrude(height=b) polygon(poly);
}

function f_involute(r0, r1)  = [
for (alpha=0; distance2([ r0*cos(alpha)+alpha*PI/180*r0*sin(alpha), r0*sin(alpha)-alpha*PI/180*r0*cos(alpha) ]) < r1; alpha=alpha+$fa/8)
    [
        r0*cos(alpha)+alpha*PI/180*r0*sin(alpha),
        r0*sin(alpha)-alpha*PI/180*r0*cos(alpha)
    ]
];

function find_theta(L,d) = distance2(head(L))>=d ? atan2(head(L).y, head(L).x) : find_theta(tail(L),d);
