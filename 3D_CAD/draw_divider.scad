
$fn = 45;

depth = 1.48;
corner = 2.9;
// small
//width_top = 51.46;
//width_bot = 50.93;
//height = 27.50;
// large
width_top = 109.00;
width_bot = 107.00;
height = 45.55;

s = (width_top - width_bot) / 2;

difference() {
    hull() {
        translate([corner, corner, 0]) cylinder(r = corner, h = depth);
        translate([corner - s, height - corner, 0]) cylinder(r = corner, h = depth);
        translate([width_bot - corner, corner, 0]) cylinder(r = corner, h = depth);
        translate([width_top - corner - s, height - corner, 0]) cylinder(r = corner, h = depth);
    }
    translate([width_bot / 2, -2, 0]) cylinder(r = 4, h = depth);
}
