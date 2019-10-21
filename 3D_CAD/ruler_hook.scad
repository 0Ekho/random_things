$fn = 90;
xov = 0.0002; // overlap of some parts to prevent openscad from leaving "infinitly" thin walls

h_d = 7;
h_l = 8;
h_t = 2;

c_w = 20;
c_h = 30;
c_d = 15;
c_c = 5.4;

s_a = 65;

difference() {
    union() {
        cube([c_d, c_h, c_w]);
        translate([-h_l, c_h - h_d, c_w / 2]) rotate([0, 90, 0]) cylinder(d = h_d, h = h_l);
        translate([-h_l, c_h - h_d + h_t, c_w / 2]) rotate([0, 90, 0]) cylinder(d = h_d - h_t, h = h_t);
    }
    translate([(c_d - c_c) / 2, 0, 0]) cube([c_c, c_h - (c_d - c_c) / 2, c_w]);
    translate([-(h_l) - h_d * sin(s_a), (c_h - h_d + h_t) - h_d * sin(90 - s_a), 0]) rotate([0, 0, -s_a]) cube([h_d, h_d, c_w]);
}
