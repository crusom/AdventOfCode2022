const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var instructions = @embedFile("input");
    var sum: isize = 0;
    var inst: u8 = undefined;
    var cycles: usize = 1;
    var x: isize = 1;
    var looking: isize = 20;
    var add: isize = 0;

    var iter = std.mem.split(u8, instructions, "\n");
    while (iter.next()) |line| {
        if (line.len == 0) break;
        inst = line[0];

        if (inst == 'a') {
            if (cycles == looking or cycles + 1 == looking) {
                //  print("addx {d} {d}\n", .{ x * looking, cycles });
                sum += x * looking;
                looking += 40;
                if (looking > 220) break;
            }

            add = try std.fmt.parseInt(isize, line[5..], 10);
            x += add;
            cycles += 2;
        } else {
            if (cycles == looking) {
                //  print("nop {d}\n", .{x * looking});
                sum += x * looking;
                looking += 40;
                if (looking > 220) break;
            }

            cycles += 1;
        }
    }
    print("{d}\n", .{sum});
}
