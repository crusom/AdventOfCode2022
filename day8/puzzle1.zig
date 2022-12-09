const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var arr: [100][100]u8 = undefined;
    var map: [100][100]u8 = undefined;
    var up_edge: [99]u8 = .{0} ** 99;
    var left_edge: [99]u8 = .{0} ** 99;
    var down_edge: [99]u8 = .{0} ** 99;
    var right_edge: [99]u8 = .{0} ** 99;

    var sum: usize = 0;
    var i: usize = 0;

    while (try r.readUntilDelimiterOrEof(&arr[i], '\n')) |_| {
        i += 1;
    }

    i = 0;
    while (i < 99) : (i += 1) {
        up_edge[i] = arr[0][i];
        left_edge[i] = arr[i][0];
        down_edge[i] = arr[98][i];
        right_edge[i] = arr[i][98];
    }

    i = 0;
    while (i < 98) : (i += 1) {
        var j: usize = 1;
        while (j < 98) : (j += 1) {
            var p = arr[i][j];
            map[i][j] = 0;
            if (up_edge[j] < p) {
                up_edge[j] = p;
                map[i][j] = 1;
            }
            if (left_edge[i] < p) {
                left_edge[i] = p;
                map[i][j] = 1;
            }
        }
    }

    i = 97;
    while (i > 0) : (i -= 1) {
        var j: usize = 97;
        while (j > 0) : (j -= 1) {
            var p = arr[i][j];
            if (down_edge[j] < p) {
                down_edge[j] = p;
                map[i][j] = 1;
            }
            if (right_edge[i] < p) {
                right_edge[i] = p;
                map[i][j] = 1;
            }
            if (map[i][j] != 0)
                sum += 1;
        }
    }
    // include the borders
    sum += (99 * 4) - 4;
    print("{d}\n", .{sum});
}
