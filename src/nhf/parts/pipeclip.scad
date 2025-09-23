module nhf_tool_pipeclip(din=10,th=1.5,h=30) {
	module outl(r=5,h=h) {
		rotate_extrude(angle=90,$fn=60) translate([r,0]) square([th,h]);
	}
	rotate_extrude(angle=270,$fn=180) translate([din/2,0]) square([th,h]);
	translate([0,-din*3/4-th,0]) outl(r=din/4);
	translate([din*3/4+th,0,0]) rotate([0,0,180]) outl(r=din/4);
}

nhf_tool_pipeclip();