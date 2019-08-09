
$fn = 45;

// NOTE: height includes bottom, so height 5 bottom 2 gives 3mm hole depth

// screw vial
//bottom = 2;
//height = 20 + bottom;
//vial = 15 + 0.2;
//rack = 0;

// 1075 culture tube
bottom = 2;
height = 4 + bottom;
top_height = 3;
vial = 10 + 0.2;
rack = 1;

wall = 2;
//v_w = 8;
//v_d = 4;
v_w = 12;
v_d = 8;

sup_w = 4;
sup_d = 4;
sup_o = 1;
// height of support, ie spacing between top and bottom half;
sup_h = 45;

fudge = 1/cos(180/$fn);
vialf = (vial / 2 * fudge) * 2;

module shell(w, d, height) {
        hull() {
            curve = vialf / 2;
            translate([curve, curve, 0]) cylinder(r = curve, h = height);
            translate([w - curve, curve, 0]) cylinder(r = curve, h = height);
            translate([w - curve, d - curve, 0]) cylinder(r = curve, h = height);
            translate([curve, d - curve, 0]) cylinder(r = curve, h = height);
        }
}

module tray(height, bottom) {
    difference() {
        shell((vialf + wall) * v_w + wall, (vialf + wall) * v_d + wall, height);
        for (x = [1:v_w]) {
            for (y = [1:v_d]) {
                translate([(wall + vialf) * x - vialf / 2, (wall + vialf) * y - vialf / 2, bottom]) cylinder(d = vialf, h = height);
            }
        }
    }
}

module tray_slots(sw, sd, height, bottom) {
    union() {
        difference() {
            shell((vialf + wall) * v_w + wall + (sup_w + wall) * 2, (vialf + wall) * v_d + wall, height);
            translate([sup_w + wall, 0, 0]) shell((vialf + wall) * v_w + wall, (vialf + wall) * v_d + wall, height);
            translate([wall, vial / 2, 0]) cube([sup_w, sup_d, height]);
            translate([wall, (vialf + wall) * v_d - sup_d - vial / 2 + wall, 0]) cube([sup_w, sup_d, height]);
            translate([(vialf + wall) * v_w + wall + sup_w + wall, vial / 2, 0]) cube([sup_w, sup_d, height]);
            translate([(vialf + wall) * v_w + wall + sup_w + wall, (vialf + wall) * v_d - sup_d - vial / 2 + wall, 0]) cube([sup_w, sup_d, height]);
        }
        translate([sup_w + wall, 0, 0]) tray(height, bottom);
    }
}

if (rack == 1) {
    tray_slots(sup_w, sup_d, height, bottom);
} else if (rack == 2) {
    tray_slots(sup_w, sup_d, top_height, 0);
} else if (rack == 3) {
    union() {
        translate([sup_o, sup_o, 0]) cube([sup_w, sup_d, height - bottom]);
        translate([0, 0, height - bottom]) cube([sup_w + sup_o * 2, sup_d + sup_o * 2, sup_h]);
        translate([sup_o, sup_o, height - bottom + sup_h]) cube([sup_w, sup_d, top_height]);
    }
} else {
    tray(height, bottom);
}
