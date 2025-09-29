
function nhf_curve_bezier4(points) = len(points[0])==3?
	(bezier_3D(points, segments=$fn))
	:
	(len(points[0])==2?
		(bezier_2D(points,$fn=($fn<len(points*2)?len(points*2):$fn)))
		:
		(assert(false,"bezier_line points must be in 2D or 3D."))
	);

/*******************************/

function interpolate_bezier3(points, axis, t) = let (t1=1-t) t1^3*points[0][axis] + 3*t*t1^2*points[1][axis] + 3*t^2*t1*points[2][axis] + t^3*points[3][axis];

function bezier4(points, axis, i, segments) = interpolate_bezier3(points, axis, i/(segments-1));

function bezier_2D(points) = [
	for (i = [0:1:$fn-1]) [
		bezier4(points, 0, i, $fn),
		bezier4(points, 1, i, $fn)
	]
];

function bezier_3D(points) = [
	for (i = [0:1:$fn-1]) [
		bezier4(points, 0, i, $fn),
		bezier4(points, 1, i, $fn),
		bezier4(points, 2, i, $fn)
	]
];