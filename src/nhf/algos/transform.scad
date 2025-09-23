module nhf_algo_transform_skew_z(t=[0,0]) {
    M = [
            [ 1  , 0  , 0  , 0   ],
            [ 0  , 1  , 0.7, 0   ],
            [ 0  , 0  , 1  , 0   ],
            [ 0  , 0  , 0  , 1   ] ] ;
    multmatrix(M);
}
