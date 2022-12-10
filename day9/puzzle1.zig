const std = @import("std");
const print = std.debug.print;

inline fn abs(comptime T: type, v: T) T {
    const mask = v >> @sizeOf(T) * 8 - 1;
    return (v + mask) ^ mask;
}

const Pos = struct {
    const Self = @This();
    x: usize = 500,
    y: usize = 500,
    // like this
    // XXX
    // XtX
    // XXX
    fn is_around(self: Pos, other: Pos) bool {
        return (abs(i32, @intCast(i32, self.x) - @intCast(i32, other.x)) <= 1 and abs(i32, @intCast(i32, self.y) - @intCast(i32, other.y)) <= 1);
    }
    fn same_x(self: Pos, other: Pos) bool {
        return (self.x == other.x);
    }
    fn same_y(self: Pos, other: Pos) bool {
        return (self.y == other.y);
    }
};

var map: [1000][1000]bool = undefined;
//var map = std.mem.zeroes([1000][1000]bool);

pub fn main() !void {
    var series = @embedFile("input");
    var sum: usize = 0;
    var i: usize = 0;

    var h = Pos{};
    var t = Pos{};

    var iter = std.mem.split(u8, series, "\n");
    var dir: u8 = undefined;
    var steps: u8 = undefined;
    while (iter.next()) |line| {
        if (line.len == 0) break;
        dir = line[0];
        steps = try std.fmt.parseUnsigned(u8, line[2..], 10);
        i = 0;
        while (i < steps) : (i += 1) {
            switch (dir) {
                'R' => h.x += 1,
                'L' => h.x -= 1,
                'U' => h.y += 1,
                'D' => h.y -= 1,
                else => unreachable,
            }
            if (!t.is_around(h)) {
                if (h.x == t.x + 2 and h.same_y(t)) {
                    t.x += 1;
                } else if (h.x == t.x - 2 and h.same_y(t)) {
                    t.x -= 1;
                } else if (h.y == t.y + 2 and h.same_x(t)) {
                    t.y += 1;
                } else if (h.y == t.y - 2 and h.same_x(t)) {
                    t.y -= 1;
                } else {
                    if (h.x > t.x) {
                        if (h.y > t.y) {
                            t.x += 1;
                            t.y += 1;
                        } else {
                            t.x += 1;
                            t.y -= 1;
                        }
                    } else if (h.x < t.x) {
                        if (h.y > t.y) {
                            t.x -= 1;
                            t.y += 1;
                        } else {
                            t.x -= 1;
                            t.y -= 1;
                        }
                    } else unreachable;
                }
            }
            // wtf? in Debug and ReleaseSafe this comparison is calling memcpy and its a big bottleneck

            // > sudo perf record -e cycles ./puzzle1
            // > sudo perf report
            // Samples: 4K of event 'cycles', Event count (approx.): 3926380986
            // Overhead  Command  Shared Object      Symbol
            // 99.50%    puzzle1  puzzle1            [.] memcpy
            // 0.10%     puzzle1  puzzle1            [.] puzzle1.main
            // 1519455 cycles vs 3972309983 cycles

            // copies size of map (1000000) from data to stack
            // no idea why
            if (!map[t.x][t.y]) sum += 1;
            map[t.x][t.y] = true;
        }
    }
    print("{d}\n", .{sum});
}
