const std = @import("std");
const print = std.debug.print;
const Queue = @import("queue.zig").Queue;

const Pos = struct {
    const Self = @This();
    x: usize = 0,
    y: usize = 0,
    c: u8 = 0,
    dist: usize = 0,
    fn is_equal(self: Self, other: Pos) bool {
        return (self.x == other.x and self.y == other.y);
    }
};

pub fn main() !void {
    comptime var file = @embedFile("input");
    comptime var iter = std.mem.split(u8, file, "\n");
    comptime var map: [41]*const [64]u8 = undefined;
    comptime var e_pos: Pos = undefined;
    comptime var s_pos: Pos = undefined;
    comptime {
        var index: usize = 0;
        @setEvalBranchQuota(10000);
        while (iter.next()) |line| : (index += 1) {
            if (line.len == 0) break;
            map[index] = line[0..64];
            for (line) |c, x| {
                if (c == 'E')
                    e_pos = Pos{ .x = x, .y = index, .c = 'z' };
                if (c == 'S')
                    s_pos = Pos{ .x = x, .y = index, .c = 'a' };
            }
        }
    }

    var row_num = [_]isize{ -1, 0, 0, 1 };
    var col_num = [_]isize{ 0, -1, 1, 0 };
    var visited = std.mem.zeroes([41][64]bool);
    visited[s_pos.y][s_pos.x] = true;

    var queue = Queue(Pos, 100000){};
    var cur_pos = s_pos;
    try queue.push(cur_pos);

    while (!queue.is_empty()) {
        cur_pos = try queue.pop();

        if (cur_pos.is_equal(e_pos)) {
            print("{d}\n", .{cur_pos.dist});
            break;
        }

        for (row_num) |_, i| {
            if (cur_pos.x == 63 and row_num[i] == 1) continue;
            if (cur_pos.x == 0 and row_num[i] == -1) continue;
            if (cur_pos.y == 40 and col_num[i] == 1) continue;
            if (cur_pos.y == 0 and col_num[i] == -1) continue;
            var x = @intCast(usize, @intCast(isize, cur_pos.x) + row_num[i]);
            var y = @intCast(usize, @intCast(isize, cur_pos.y) + col_num[i]);

            // whatever
            if (x == e_pos.x and y == e_pos.y) {
                if ('z' != cur_pos.c)
                    continue;
            }

            if (map[y][x] - 1 <= cur_pos.c and !visited[y][x]) {
                visited[y][x] = true;
                var adj = Pos{ .x = x, .y = y, .c = map[y][x], .dist = cur_pos.dist + 1 };
                try queue.push(adj);
            }
        }
    }
}
