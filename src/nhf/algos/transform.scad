function nhf_algo_2DtoXY0(list) = [ for (elm = list) [elm.x, elm.y, 0]];

module nhf_algo_transform_skew_z(t=[0,0]) {
    M = [
            [ 1  , 0  , 0  , 0   ],
            [ 0  , 1  , 0.7, 0   ],
            [ 0  , 0  , 1  , 0   ],
            [ 0  , 0  , 0  , 1   ] ] ;
    multmatrix(M);
}

/*
 * Rotate the Z-axis of children() towards given vector
 */
module nhf_rotate_toward(v) {
    assert(norm(v)>0,"Vector is too short!");
    u = v/norm(v);

    angle_deg = acos(u.z);

    rx = -u.y;
    ry = u.x;
    rz = 0;

    // 处理共线情况：当旋转轴长度接近 0 时（u 平行于 z）
    rlen = sqrt(rx*rx + ry*ry + rz*rz);
    if (rlen < 1e-9) {
        if (uz > 0) {
            angle_deg = 0;
            rx = 1; ry = 0; rz = 0;
        } else {
            angle_deg = 180;
            rx = 1; ry = 0; rz = 0;
        }
    }
    rotate(angle_deg, [rx, ry, rz])
        children();
}