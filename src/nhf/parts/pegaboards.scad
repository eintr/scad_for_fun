include <nhf/parts/pegaboards/round_hole.scad>
include <nhf/parts/pegaboards/square_hole.scad>
include <nhf/parts/pegaboards/others.scad>

// nhf_part_pegaboard():
//
// Template of adaptor for pegboard
// 通用钳工孔板适配
//
// Parameters(All in mm):
//    dim: base board 3D dimension (default: [100,70,2])
//    boardtype: enum of:
//		"round_hole" (default)
//		"square_hole"
//    rounded: whether the base board is rounded (default: true)
//    board_thick: thickness of pegaboard(not base board) (default: 2)
//    center_distance: Hole center distance[x,y] (default: [26,26])
//    hole_size: size of hole
//      for boardtype==round_hole: [hole_d] (default: [5.5])
//      for boardtype==square_hole: [hole_x,hole_y] (default: [5.5,5.5])
//    rivet_at:
//      for boardtype==round_hole: rivet hole position (default: auto)
//      for boardtype==square_hole: No effect
//    center: whether position of base board is centered
//
// Example:
//nhf_tool_pegaboard(dim=[120,120,2]);
//nhf_tool_pegaboard(dim=[60,60,2], boardtype="round_hole",board_thick=2, hole_center_distance=[16,16], hole_size=[5,5],rivet_at=[1,2],rounded=true);
module nhf_part_pegaboard(dim=[100,70,2], boardtype="round_hole",board_thick=2, hole_center_distance=[26,26], hole_size=[5.5,5.5], rivet_at=[-1,-1], center=false,rounded=true) {
	if (boardtype=="round_hole") {
		hook__pegboard_round(
			l=dim.x, h=dim.y, th=dim.z,
			hole_d=hole_size.x,
            rivet_at = rivet_at,
			center_distance=hole_center_distance.x,
			center=center,
			rounded=rounded);
	} else if (boardtype=="square_hole") {
		hook__pegboard_square(
			l=dim.x, h=dim.y, th=dim.z,
			hole_x=hole_size.x, hole_y=hole_size.y,
			board_thick=board_thick,
			center_distance=hole_center_distance.x,
			rounded=rounded,
			center=center);
	} else {
		assert(false, "ERROR: Unknown boardtype given");
	}
}

