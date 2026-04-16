// Gabriel Riqueto 
// Gabriel Oliveira
// Leonardo Mansur
// Sabrina Flores

// Parâmetros (mm)
outer_diameter = 25;
height = 10;
hole_diameter = 5;
teeth = 10;
tooth_width = 5;          // largura da base do dente
tooth_tip_width = 2.4;    // largura da ponta
tooth_depth = 4;
blend = 0.8;              // quanto o dente entra no corpo
round_r = 0.9;            // arredondamento dos dentes

module hill_tooth() {
    linear_extrude(height = height)
        offset(r = round_r)
            offset(delta = -round_r)
                polygon(points = [
                    [-blend, -tooth_width/2],                 // entra no corpo
                    [0.8,    -tooth_width/2],
                    [2.0,    -tooth_width*0.38],
                    [3.0,    -tooth_tip_width*0.60],
                    [tooth_depth, -tooth_tip_width/2],

                    [tooth_depth,  tooth_tip_width/2],
                    [3.0,     tooth_tip_width*0.60],
                    [2.0,     tooth_width*0.38],
                    [0.8,     tooth_width/2],
                    [-blend,  tooth_width/2]
                ]);
}

module gear() {
    difference() {
        union() {
            // Corpo principal
            cylinder(d = outer_diameter - tooth_depth, h = height, $fn = 120);

            // Dentes arredondados e conectados ao corpo
            for (i = [0 : teeth - 1]) {
                rotate([0, 0, i * 360 / teeth])
                    translate([(outer_diameter - tooth_depth)/2 - blend, 0, 0])
                        hill_tooth();
            }
        }

        // Furo central
        translate([0,0,-1])
            cylinder(d = hole_diameter, h = height + 2, $fn = 100);
    }
}

gear();