fracube();

module fracube(s=81) {
    if (s<2) {
        cube([1,1,1]);
    } else {
        for (x=[0:2])
            for (y=[0:2])
                for (z=[0:2])
                    if (!((x==1&&y==1) || (x==1&&z==1) || (y==1&&z==1)))
                        translate([x*s/3,y*s/3,z*s/3]) fracube(s/3);
    }
}

