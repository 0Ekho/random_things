

// Bottom thickness
bottom = 2;
// Hole depth (bottom is not included, depth 20 bottom 2 gives 22mm tray height)
depth = 20;
// Vial diameter (make sure there is clearence, 15.2 seems OK for 15mm vial)
vial = 15.2;
// wall thickness, spacing
wall = 2;
// number of columns
columns = 8; // [32]
// number of rows
rows = 4; // [32]
// number of edges for circles, slow if high but can be nicer for larger holes
fn = 45;
// type of tray or part [0: normal tray, 1: rack bottom, 2: rack top, 3: rack supports, 4: rack s2]
ptype = 0; // [0, 1, 2, 3, 4]
/* [rack settings (ptype 1..3, 4)] */
// thickness of top section of rack (ptype 2)
top_height = 3;
// support x width (for ptype 1..3)
sup_w = 4;
// support y width (for ptype 1..4)
sup_d = 4;
// support "lip" size (for ptype 1..3)
sup_o = 1;
// height of support, spacing (for ptype 3..4);
sup_h = 45;

// Example values
//
// screw vial
//bottom = 2;
//depth = 20;
//vial = 15.2;
//ptype = 0;
//
// 1075 culture tube
//bottom = 2;
//depth = 4;
//vial = 10.2;
//ptype = 1,2,3;
//top_height = 3;
//sup_w = 4;
//sup_d = 4;
//sup_o = 1;
//sup_h = 45;

$fn = fn;
height = depth + bottom;
fudge = 1/cos(180/$fn);
vialf = (vial / 2 * fudge) * 2;

module shell(w, d, height) {
    if (ptype == 4) {
        cube([w, d, height]);
    } else {
        curve = vialf / 2;
        hull() {
            translate([curve, curve, 0]) cylinder(r = curve, h = height);
            translate([w - curve, curve, 0]) cylinder(r = curve, h = height);
            translate([w - curve, d - curve, 0]) cylinder(r = curve, h = height);
            translate([curve, d - curve, 0]) cylinder(r = curve, h = height);
        }
    }
}

module tray(height, bottom) {
    difference() {
        shell((vialf + wall) * columns + wall, (vialf + wall) * rows + wall, height);
        for (x = [1:columns]) {
            for (y = [1:rows]) {
                translate([(wall + vialf) * x - vialf / 2, (wall + vialf) * y - vialf / 2, bottom]) cylinder(d = vialf, h = height);
            }
        }
    }
}

module tray_slots(sw, sd, height, bottom) {
    union() {
        difference() {
            shell((vialf + wall) * columns + wall + (sup_w + wall) * 2, (vialf + wall) * rows + wall, height);
            translate([sup_w + wall, 0, 0]) shell((vialf + wall) * columns + wall, (vialf + wall) * rows + wall, height);
            translate([wall, vial / 2, 0]) cube([sup_w, sup_d, height]);
            translate([wall, (vialf + wall) * rows - sup_d - vial / 2 + wall, 0]) cube([sup_w, sup_d, height]);
            translate([(vialf + wall) * columns + wall + sup_w + wall, vial / 2, 0]) cube([sup_w, sup_d, height]);
            translate([(vialf + wall) * columns + wall + sup_w + wall, (vialf + wall) * rows - sup_d - vial / 2 + wall, 0]) cube([sup_w, sup_d, height]);
        }
        translate([sup_w + wall, 0, 0]) tray(height, bottom);
    }
}

if (ptype == 1) {
    tray_slots(sup_w, sup_d, height, bottom);
} else if (ptype == 2) {
    tray_slots(sup_w, sup_d, top_height, 0);
} else if (ptype == 3) {
    union() {
        translate([sup_o, sup_o, 0]) cube([sup_w, sup_d, depth]);
        translate([0, 0, depth]) cube([sup_w + sup_o * 2, sup_d + sup_o * 2, sup_h]);
        translate([sup_o, sup_o, depth + sup_h]) cube([sup_w, sup_d, top_height]);
    }
} else if (ptype == 4) {
    union() {
        translate([sup_w, 0, sup_h]) tray(depth, 0);
        cube([sup_w, (vialf + wall) * rows + wall, sup_h + depth]);
        translate([(vialf + wall) * columns + wall + sup_w, 0, 0]) cube([sup_w, (vialf + wall) * rows + wall, sup_h + depth]);
    }
} else {
    tray(height, bottom);
}
