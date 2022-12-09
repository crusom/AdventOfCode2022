const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var arr: [100][100]u8 = undefined;
    // thats how you can zero init a 2d array if you wonder
    // var right_map: [100][100]u8 = [_][100]u8{[_]u8{0} ** 100} ** 100;

    var max: usize = 0;
    var i: usize = 0;

    while (try r.readUntilDelimiterOrEof(&arr[i], '\n')) |_| {
        i += 1;
    }

    // ok fuck it, bruteforce

    i = 1;
    while (i < 98) : (i += 1) {
        var j: usize = 1;
        while (j < 98) : (j += 1) {
            var p = arr[i][j];
            var d: usize = 1;
            var left: usize = 1;
            var right: usize = 1;
            var up: usize = 1;
            var down: usize = 1;

            while (j - d > 0 and p > arr[i][j - d]) : (d += 1) {
                left += 1;
            }
            d = 1;
            while (j + d < 98 and p > arr[i][j + d]) : (d += 1) {
                right += 1;
            }
            d = 1;

            while (i - d > 0 and p > arr[i - d][j]) : (d += 1) {
                up += 1;
            }
            d = 1;
            while (i + d < 98 and p > arr[i + d][j]) : (d += 1) {
                down += 1;
            }

            var mul = left * right * up * down;
            if (mul > max)
                max = mul;
        }
    }
    print("{d}\n", .{max});
}
