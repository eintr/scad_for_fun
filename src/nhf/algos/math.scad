function distance(p,p0) = norm(p-p0);
function distance2(p,p0=[0,0]) = distance(p,p0);
function distance3(p,p0=[0,0,0]) = distance(p,p0);

/******** Bezier ********/
function interpolate_bezier3(points, axis, t) = let (t1=1-t) t1^3*points[0][axis] + 3*t*t1^2*points[1][axis] + 3*t^2*t1*points[2][axis] + t^3*points[3][axis];

function bezier4(points, axis, i, segments) = interpolate_bezier3(points, axis, i/(segments-1));

function bezier_2D(points, segments=20) = [
	for (i = [0:1:segments-1]) [
		bezier4(points, 0, i, segments),
		bezier4(points, 1, i, segments)
	]
];

function bezier_3D(points, segments=20) = [
	for (i = [0:1:segments-1]) [
		bezier4(points, 0, i, segments),
		bezier4(points, 1, i, segments),
		bezier4(points, 2, i, segments)
	]
];

function bezier_line(points, segments=20) = len(points[0])==3?
	(bezier_3D(points, segments=segments))
	:
	(len(points[0])==2?
		(bezier_2D(points, segments=segments))
		:
		(assert(false,"bezier_line points must be in 2D or 3D."))
	);

//for (p = bezier_line([[0,0,0],[50,50,50],[75,10,-50],[100,0,0]],segments=80))
//	translate(p)
//		circle(d=1);

