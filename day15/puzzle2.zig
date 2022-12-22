const std = @import("std");
const min = std.math.min;
const max = std.math.max;
const absInt = std.math.absInt;

const print = std.debug.print;

const RangeError = error{
    NotFound,
};

const Range = struct {
    x1: isize,
    x2: isize,
    //         x1     x2
    // --------[------]-------------
    //   x1      x2
    // ---[-------]-----------------
    // or
    //   x1      x2
    // ---[-------]-----------------
    //         x1     x2
    // --------[------]-------------

    fn partially_includes(self: Range, other: Range) bool {
        if ((self.x1 <= other.x1 and self.x2 >= other.x1) or (other.x1 <= self.x1 and other.x2 >= self.x1))
            return true;
        return false;
    }
};

const Sensor = struct {
    x: isize,
    y: isize,
    dist: isize,

    fn get_range(self: Sensor, row: isize) RangeError!Range {
        if (self.y <= row and self.y + self.dist >= row) {
            var s_x1 = self.x - (self.y + self.dist - row);
            var s_x2 = self.x + (self.y + self.dist - row);
            return Range{ .x1 = min(s_x1, s_x2), .x2 = max(s_x1, s_x2) };
        } else if (self.y >= row and self.y - self.dist <= row) {
            var s_x1 = self.x - (row - (self.y - self.dist));
            var s_x2 = self.x + (row - (self.y - self.dist));
            return Range{ .x1 = min(s_x1, s_x2), .x2 = max(s_x1, s_x2) };
        }
        return RangeError.NotFound;
    }
};

const max_row = 4000000;
//const max_row = 20;

pub fn main() !void {
    var file = @embedFile("input");
    //var file = @embedFile("test_input");
    var iter = std.mem.split(u8, file, "\n");

    var buffer: [10000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    var allocator = fba.allocator();
    var sensors: std.ArrayList(Sensor) = std.ArrayList(Sensor).init(allocator);
    defer sensors.deinit();

    while (iter.next()) |line| {
        if (line.len == 0) continue;
        // if it works, then it works
        var delimiter_bytes: []const u8 = "Sensor at x=, y=: closest beacon is at x=, y=";
        var iter_cords = std.mem.tokenize(u8, line, delimiter_bytes);
        var s_x = try std.fmt.parseInt(isize, iter_cords.next().?, 10);
        var s_y = try std.fmt.parseInt(isize, iter_cords.next().?, 10);
        var b_x = try std.fmt.parseInt(isize, iter_cords.next().?, 10);
        var b_y = try std.fmt.parseInt(isize, iter_cords.next().?, 10);
        try sensors.append(Sensor{ .x = s_x, .y = s_y, .dist = try absInt(s_x - b_x) + try absInt(s_y - b_y) });
    }

    var list: std.ArrayList(Range) = std.ArrayList(Range).init(allocator);
    defer list.deinit();

    var i: isize = 0;
    while (i <= max_row) : (i += 1) {
        list.clearRetainingCapacity();

        var r: Range = undefined;
        var flag_first = false;

        for (sensors.items[0..]) |s| {
            if (!flag_first) {
                r = s.get_range(i) catch continue;
                try list.append(r);
                flag_first = true;
                continue;
            }

            r = s.get_range(i) catch continue;
            var found = false;
            for (list.items) |*l| {
                if (l.partially_includes(r)) {
                    l.x1 = min(l.x1, r.x1);
                    l.x2 = max(l.x2, r.x2);
                    found = true;
                }
            }

            if (!found)
                try list.append(r);
        }

        if (list.items.len == 1) continue;

        var l = list.items[0];
        var can_break = false;
        for (list.items[1..]) |_| {
            for (list.items[1..]) |*l2| {
                if (l2.partially_includes(l)) {
                    l.x1 = min(l.x1, l2.x1);
                    l.x2 = max(l.x2, l2.x2);
                }
                if (l.x1 <= 0 and l.x2 >= max_row) {
                    can_break = true;
                    break;
                }
            }
            if (can_break)
                break;
        }

        if (l.x1 > 0 or l.x2 < max_row) {
            print("{d}\n", .{(l.x2 + 1) * max_row + i});
            break;
        }
    }
}
