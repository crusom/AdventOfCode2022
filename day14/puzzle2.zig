const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var cords_file = @embedFile("input");
    //var cords_file = @embedFile("test_input");
    var iter = std.mem.split(u8, cords_file, "\n");
    var map: [1000][1000]u8 = undefined;
    for (map[0..][0..]) |*p| p.* = .{'.'} ** 1000;

    var floor: usize = 0;
    while (iter.next()) |line| {
        if (line.len == 0) continue;
        var prev_x: usize = 0;
        var prev_y: usize = 0;

        var cords_iter = std.mem.tokenize(u8, line[0..], " -> ");
        while (cords_iter.next()) |cords| {
            var x_and_y_iter = std.mem.tokenize(u8, cords[0..], ",");
            var x = try std.fmt.parseUnsigned(usize, x_and_y_iter.next().?, 10);
            var y = try std.fmt.parseUnsigned(usize, x_and_y_iter.next().?, 10);

            if (prev_x == 0 and prev_y == 0) {
                prev_x = x;
                prev_y = y;
            } else {
                var max_x = std.math.max(prev_x, x);
                var min_x = std.math.min(prev_x, x);
                var max_y = std.math.max(prev_y, y);
                var min_y = std.math.min(prev_y, y);
                for (map[min_y..(max_y + 1)]) |*p| {
                    for (p[min_x..(max_x + 1)]) |*b| {
                        b.* = '#';
                    }
                }
                if (max_y > floor)
                    floor = max_y;

                prev_x = x;
                prev_y = y;
            }
        }
    }
    for (map[floor + 2]) |*p| {
        p.* = '#';
    }

    var cur_x: usize = 500;
    var cur_y: usize = 0;
    var units_sand: usize = 0;
    while (true) {
        if (map[cur_y + 1][cur_x] == '.') {
            cur_y += 1;
        } else if (map[cur_y + 1][cur_x - 1] == '.') {
            cur_y += 1;
            cur_x -= 1;
        } else if (map[cur_y + 1][cur_x + 1] == '.') {
            cur_y += 1;
            cur_x += 1;
        } else {
            units_sand += 1;
            if (cur_y == 0 and cur_x == 500)
                break;
            map[cur_y][cur_x] = 'o';
            cur_x = 500;
            cur_y = 0;
        }
    }
    print("{d}\n", .{units_sand});
}
