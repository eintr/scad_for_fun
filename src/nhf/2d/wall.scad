use <nhf/algos/list.scad>

module nhf_2d_wall(width=4,line=[[0,0],[10,10]]) {
	assert(len(line[0])==2, "Only 2d vectors list is acceptable!");
	if (len(line)>=2) {
		p1=car(line);
		p2=car(cdr(line));
		hull() {
			translate(p1) circle(d=width);
			translate(p2) circle(d=width);
		}
		nhf_2d_wall(width=width, line=cdr(line));
	} else if (len(line)==1) {
		translate(line[0]) circle(d=width);
	}
}

nhf_2d_wall();