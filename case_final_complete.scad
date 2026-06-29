// ========================================================================
// IC-7300/9700 リモートシステム用 一体型ケーススクリプト
// Raspberry Pi 4B対応
// ========================================================================

$fn = 60;

// 0:組み立て, 1:分解, 2:下部のみ, 3:上部印刷用, 4:上部のみ
mode = 2;

// ケース寸法
case_w = 80;
case_l = 130;
case_h = 40;
wall_t = 2.5;
clearance = 0.5;
r_val = 2.0;
upper_thickness = 5.0;

// Raspberry Pi 4B 基準位置
raspi_x = wall_t + 12;
raspi_y = wall_t + 10;

// XL4015 基準位置
xl_x = wall_t + 18;
xl_y = wall_t + 89;

// 下部外側4隅の足
foot_h = 0.0;
foot_d = 10.0;
foot_inset = 9.0;

// インサートナット用ボス共通寸法
insert_boss_d = 7.5;
insert_boss_h = 8.0;
insert_hole_d = 4.8;
insert_hole_depth = 9.5;

// Raspberry Pi基板厚
raspi_board_t = 1.6;

// コネクタ開口底辺（ケース外底面基準）
// 底板厚2.5mm＋ボス8mm＋基板厚1.6mm
raspi_port_z = wall_t + insert_boss_h + raspi_board_t; // 12.1mm

// ========================================================================
// 表示切替
// ========================================================================
if (mode == 0) {
    lower_case();
    translate([0, 0, case_h - upper_thickness])
        upper_cover();

} else if (mode == 1) {
    lower_case();
    translate([0, 0, case_h - upper_thickness + 30])
        upper_cover();

} else if (mode == 2) {
    lower_case();

} else if (mode == 3) {
    translate([0, case_l, upper_thickness])
        rotate([180, 0, 0])
            upper_cover();

} else if (mode == 4) {
    upper_cover();
}

// ========================================================================
// 共通形状
// ========================================================================
module rounded_rect_2d(w, l, r) {
    translate([r, r])
        offset(r = r)
            square([w - r*2, l - r*2], center = false);
}

module lower_base_shape(x, y, z, r) {
    hull() {
        translate([r, r, r])
            sphere(r = r);

        translate([x-r, r, r])
            sphere(r = r);

        translate([r, y-r, r])
            sphere(r = r);

        translate([x-r, y-r, r])
            sphere(r = r);

        translate([r, r, z - 0.1])
            cylinder(r = r, h = 0.1);

        translate([x-r, r, z - 0.1])
            cylinder(r = r, h = 0.1);

        translate([r, y-r, z - 0.1])
            cylinder(r = r, h = 0.1);

        translate([x-r, y-r, z - 0.1])
            cylinder(r = r, h = 0.1);
    }
}

module upper_base_shape(x, y, z, r) {
    steps = 24;

    union() {
        linear_extrude(height = z - r)
            rounded_rect_2d(x, y, r);

        for (i = [0 : steps - 1]) {
            t1 = i / steps;
            t2 = (i + 1) / steps;
            dz1 = r * t1;
            dz2 = r * t2;
            inset = r - sqrt(r*r - dz1*dz1);

            translate([inset, inset, z - r + dz1])
                linear_extrude(height = dz2 - dz1)
                    rounded_rect_2d(
                        x - inset*2,
                        y - inset*2,
                        max(r - inset, 0.01)
                    );
        }
    }
}

// ========================================================================
// 下部外側足
// ========================================================================
module outside_feet() {
    // 足4個は削除済み
}

// ========================================================================
// 下ケース
// ========================================================================
module lower_case() {
    h_lower = case_h - upper_thickness;

    union() {
        outside_feet();

        translate([0, 0, foot_h]) {
            difference() {
                lower_base_shape(
                    case_w,
                    case_l,
                    h_lower,
                    r_val
                );

                // 内部くり抜き
                translate([wall_t, wall_t, wall_t])
                    cube([
                        case_w - wall_t*2,
                        case_l - wall_t*2,
                        case_h
                    ]);

                // 背面丸穴
                translate([
                    case_w / 2,
                    case_l + 1,
                    case_h / 2
                ])
                    rotate([90, 0, 0])
                        cylinder(
                            d = 13.0,
                            h = wall_t + 2
                        );

                // --------------------------------------------------------
                // Raspberry Pi 4B USB-A・RJ-45開口
                // 開口底辺はケース外底面から12.1mm
                // --------------------------------------------------------
                port_y = -1;

                usb_w = 12.0;
                usb_h = 16.0;

                // USB-A 2段ポート1
                translate([
                    raspi_x + 4.5 - clearance,
                    port_y,
                    raspi_port_z
                ])
                    cube([
                        usb_w + clearance*2,
                        wall_t + 2,
                        usb_h + clearance*2
                    ]);

                // USB-A 2段ポート2
                translate([
                    raspi_x + 18.5 - clearance,
                    port_y,
                    raspi_port_z
                ])
                    cube([
                        usb_w + clearance*2,
                        wall_t + 2,
                        usb_h + clearance*2
                    ]);

                // RJ-45
                rj45_w = 16.5;
                rj45_h = 13.5;

                translate([
                    raspi_x + 34.0 - clearance,
                    port_y,
                    raspi_port_z
                ])
                    cube([
                        rj45_w + clearance*2,
                        wall_t + 2,
                        rj45_h + clearance*2
                    ]);

                // 底面排熱スリット
                for (i = [0 : 5]) {
                    translate([
                        case_w/2 - 20,
                        wall_t + 20 + i*12,
                        -1
                    ])
                        cube([
                            40,
                            3,
                            wall_t + 2
                        ]);
                }
            }

            // ------------------------------------------------------------
            // Raspberry Pi 4B 取付ボス4個
            // ------------------------------------------------------------
            raspi_holes = [
                [0, 0],
                [0, 58],
                [49, 0],
                [49, 58]
            ];

            for (h = raspi_holes) {
                translate([
                    raspi_x + h[0],
                    raspi_y + h[1],
                    wall_t
                ])
                    difference() {
                        cylinder(
                            d = insert_boss_d,
                            h = insert_boss_h
                        );

                        translate([0, 0, -1])
                            cylinder(
                                d = insert_hole_d,
                                h = insert_hole_depth
                            );
                    }
            }

            // ------------------------------------------------------------
            // XL4015 取付ボス2個
            // ------------------------------------------------------------
            xl_holes = [
                [0, 15],
                [31, 0]
            ];

            for (h = xl_holes) {
                translate([
                    xl_x + h[0],
                    xl_y + h[1],
                    wall_t
                ])
                    difference() {
                        cylinder(
                            d = insert_boss_d,
                            h = insert_boss_h
                        );

                        translate([0, 0, -1])
                            cylinder(
                                d = insert_hole_d,
                                h = insert_hole_depth
                            );
                    }
            }

            // ------------------------------------------------------------
            // 上フタ固定用 四隅ボス
            // ------------------------------------------------------------
            boss_h = h_lower - wall_t;

            corner_positions = [
                [wall_t + 4, wall_t + 4, 0, 0],
                [case_w - wall_t - 4, wall_t + 4, 1, 0],
                [wall_t + 4, case_l - wall_t - 4, 0, 1],
                [case_w - wall_t - 4,
                 case_l - wall_t - 4, 1, 1]
            ];

            for (c = corner_positions) {
                translate([
                    c[0],
                    c[1],
                    wall_t
                ]) {
                    difference() {
                        union() {
                            cylinder(
                                d = insert_boss_d,
                                h = boss_h
                            );

                            bx = (c[2] == 0) ? -4 : 0;
                            by = (c[3] == 0) ? -4 : 0;

                            translate([bx, by, 0])
                                cube([
                                    4.0,
                                    4.0,
                                    boss_h
                                ]);
                        }

                        translate([
                            0,
                            0,
                            boss_h -
                            insert_hole_depth + 1
                        ])
                            cylinder(
                                d = insert_hole_d,
                                h = insert_hole_depth
                            );
                    }
                }
            }
        }
    }
}

// ========================================================================
// 上フタ
// ========================================================================
module upper_cover() {
    difference() {
        upper_base_shape(
            case_w,
            case_l,
            upper_thickness,
            r_val
        );

        // 上面排熱スリット
        slit_w = 1.5;
        slit_l = 22;

        for (i = [0 : 8]) {
            translate([
                case_w/2 - 15 - slit_l/2,
                wall_t + 15 + i*11,
                -1
            ])
                cube([
                    slit_l,
                    slit_w,
                    upper_thickness + 2
                ]);

            translate([
                case_w/2 + 15 - slit_l/2,
                wall_t + 15 + i*11,
                -1
            ])
                cube([
                    slit_l,
                    slit_w,
                    upper_thickness + 2
                ]);
        }

        // 四隅皿穴
        corner_offsets = [
            [wall_t + 4, wall_t + 4],
            [case_w - wall_t - 4, wall_t + 4],
            [wall_t + 4, case_l - wall_t - 4],
            [case_w - wall_t - 4,
             case_l - wall_t - 4]
        ];

        for (c = corner_offsets) {
            translate([
                c[0],
                c[1],
                -1
            ])
                cylinder(
                    d = 3.4,
                    h = upper_thickness + 2
                );

            translate([
                c[0],
                c[1],
                upper_thickness - 1.3
            ])
                cylinder(
                    d1 = 3.4,
                    d2 = 6.0,
                    h = 1.301
                );
        }
    }
}
