include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/metric_screws.scad>
use <BOSL/masks.scad>

spokeHeight=1;
spokeWidth=1.5;
numberOfSpokes=11;

innerDiameter=10.5;
// outer - inner
wallThickness=13.9-innerDiameter;
wheelDiameter=23.2;
wheelWidth=6.3;

// elevation of axis
wheelOffset=wheelWidth/2;
innerLength=12.3-wheelOffset;

fillet_mask=0.5;

$fn=120;

module spoke() {
    translate([(wheelDiameter-innerDiameter)/2,0,0]) {
        rot([0,180,0]) {
           right_triangle(size=[(wheelDiameter-innerDiameter)/2-wallThickness/2, spokeWidth, wheelWidth/2], orient=ORIENT_Y);
            down(spokeHeight) cube(size=[wheelDiameter-innerDiameter-wallThickness*2, spokeWidth, spokeHeight]);
        }
    }
}

module axis() {
    union()translate([0,0,wheelOffset]) {
        difference() {
            difference() {
                cylinder(d=innerDiameter+wallThickness, h=innerLength);
                cylinder(d=innerDiameter,h=innerLength);
            }
            up(innerLength) {
                chamfer_hole_mask(d=innerDiameter,chamfer=.5);
            }
        }
        arc_of(d=innerDiameter-wallThickness/4,n=numberOfSpokes) {
            spoke();
        }
    }
}

module wheel() {
    difference(){
        cylinder(d=wheelDiameter, h=wheelWidth);
        cylinder(d=wheelDiameter-wallThickness, h=wheelWidth);
        up(wheelWidth) {
            fillet_cylinder_mask(r=wheelDiameter/2);
            fillet_hole_mask(r=(wheelDiameter-wallThickness)/2);
        }
        rotate([0, 180, 0]) {
            fillet_cylinder_mask(r=wheelDiameter/2);
            fillet_hole_mask(r=(wheelDiameter-wallThickness)/2);
        }
    } // difference
}

// compose object
wheel();
axis();
