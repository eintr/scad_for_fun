
nhf_shape_geometry_icosahedron();

// 正二十面体 (Icosahedron) 示例 —— OpenSCAD
// edge: 边长
module nhf_shape_geometry_icosahedron(edge=20) {
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

