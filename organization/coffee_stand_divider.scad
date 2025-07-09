l = 106;
w = 92;
d = 90;

hfac = 0.75;
wall = 3.2;

difference() {
    cube([l, w, d * hfac]);
    translate([-1, wall / 2, 0]) 
        cube([(l - wall) / 2 + 1, (w - wall), d]);
    translate([(l - wall) / 2 + wall, wall / 2, 0])
        cube([(l - wall) / 2 + 1, (w - wall), d]);
    translate([-1, -1, d * (1 - hfac)])
        cube([(l - wall) / 2 + 1, w + 2, d]);
    translate([(l - wall) / 2 + wall, -1, d * (1 - hfac)])
        cube([(l - wall) / 2 + 1, w + 2, d]);
        
}
