const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var instructions = @embedFile("input");
    var inst: u8 = undefined;
    var cycles: usize = 0;
    var x: isize = 1;
    var add: isize = 0;
    var i: usize = 0;

    var screen: [240]u8 = undefined;

    var iter = std.mem.split(u8, instructions, "\n");
    while (iter.next()) |line| {
        if (line.len == 0) break;
        inst = line[0];

        var cycles_mod = (cycles % 40);
        if (inst == 'a') {
            i = 0;
            while (i < 2) : (i += 1) {
                if (x - 1 == cycles_mod or x == cycles_mod or x + 1 == cycles_mod) {
                    screen[cycles] = 1;
                } else screen[cycles] = 0;
                cycles += 1;
                cycles_mod = (cycles % 40);
            }

            add = try std.fmt.parseInt(isize, line[5..], 10);
            x += add;
        } else {
            if (x - 1 == cycles_mod or x == cycles_mod or x + 1 == cycles_mod) {
                screen[cycles] = 1;
            } else screen[cycles] = 0;

            cycles += 1;
        }
    }

    i = 0;
    while (i < 6) : (i += 1) {
        for (screen[(i * 40)..(i * 40 + 40)]) |pixel| {
            if (pixel == 1) {
                print("{c}", .{'#'});
            } else print("{c}", .{'.'});
        }
        print("\n", .{});
    }
}
