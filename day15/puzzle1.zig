const std = @import("std");
const min = std.math.min;
const max = std.math.max;
const absInt = std.math.absInt;

const print = std.debug.print;

const Range = struct {
    x1: isize,
    x2: isize,

    fn partially_includes(self: Range, other: Range) bool {
        if (self.x1 <= other.x1 or self.x2 >= other.x2)
            return true;
        return false;
    }
};

const row: isize = 2000000;

pub fn main() !void {
    var file = @embedFile("input");
    //var file = @embedFile("test_input");
    var iter = std.mem.split(u8, file, "\n");

    var buffer: [10000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    var allocator = fba.allocator();
    var ranges: std.ArrayList(Range) = std.ArrayList(Range).init(allocator);
    defer ranges.deinit();

    while (iter.next()) |line| {
        if (line.len == 0) continue;
        // if it works, then it works
        var delimiter_bytes: []const u8 = "Sensor at x=, y=: closest beacon is at x=, y=";
        var iter_cords = std.mem.tokenize(u8, line, delimiter_bytes);
        var s_x = try std.fmt.parseInt(isize, iter_cords.next().?, 10);
        var s_y = try std.fmt.parseInt(isize, iter_cords.next().?, 10);
        var b_x = try std.fmt.parseInt(isize, iter_cords.next().?, 10);
        var b_y = try std.fmt.parseInt(isize, iter_cords.next().?, 10);
        //        print("{d} {d}, {d} {d}\n", .{ x1, y1, x2, y2 });
        var dist = try absInt(s_x - b_x) + try absInt(s_y - b_y);
        if (s_y <= row and s_y + dist >= row) {
            try ranges.append(Range{ .x1 = s_x - (s_y + dist - row), .x2 = s_x + (s_y + dist - row) });
        }
        if (s_y >= row and s_y - dist <= row) {
            try ranges.append(Range{ .x1 = s_x - (row - (s_y - dist)), .x2 = s_x + (row - (s_y - dist)) });
        }
    }

    var list: std.ArrayList(Range) = std.ArrayList(Range).init(allocator);
    defer ranges.deinit();

    try list.append(ranges.items[0]);
    for (ranges.items[1..]) |r| {
        for (list.items) |*l| {
            if (l.partially_includes(r)) {
                l.x1 = min(l.x1, r.x1);
                l.x2 = max(l.x2, r.x2);
            } else {
                try list.append(r);
            }
        }
    }

    for (list.items) |r| {
        print("{d} {d}\n", .{ r.x1, r.x2 });
        print("{d}\n", .{try absInt(r.x1) + r.x2});
    }
}
