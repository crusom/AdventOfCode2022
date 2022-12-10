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

pub fn main() !void {
    var series = @embedFile("input");
    var sum: usize = 0;
    var i: usize = 0;

    // knots[0] is head knots[9] is tail
    var knots: [10]Pos = undefined;
    inline for (knots) |_, index| {
        knots[index] = Pos{};
    }

    var iter = std.mem.split(u8, series, "\n");
    var dir: u8 = undefined;
    var steps: u8 = undefined;
    while (iter.next()) |line| {
        if (line.len == 0) break;
        dir = line[0];
        steps = try std.fmt.parseUnsigned(u8, line[2..], 10);
        i = 0;
        while (i < steps) : (i += 1) {
            var h: *Pos = &knots[0];
            switch (dir) {
                'R' => h.x += 1,
                'L' => h.x -= 1,
                'U' => h.y += 1,
                'D' => h.y -= 1,
                else => unreachable,
            }
            for (knots[1..]) |*t, index| {
                // we iterate from 1, but index is from 0 anyway, so
                h = &knots[index];
                if (!t.is_around(h.*)) {
                    if (h.x == t.x + 2 and h.same_y(t.*)) {
                        t.x += 1;
                    } else if (h.x == t.x - 2 and h.same_y(t.*)) {
                        t.x -= 1;
                    } else if (h.y == t.y + 2 and h.same_x(t.*)) {
                        t.y += 1;
                    } else if (h.y == t.y - 2 and h.same_x(t.*)) {
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
                if (index + 1 == 9) {
                    if (!map[t.x][t.y]) sum += 1;
                    map[t.x][t.y] = true;
                }
            }
        }
    }
    print("{d}\n", .{sum});
}
