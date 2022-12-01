const std = @import("std");
const os = std.os;
const print = std.debug.print;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var buf: [100]u8 = undefined;
    var num: u32 = 0;
    var sum: u32 = 0;
    var max_sum: u32 = 0;
    while (try r.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            if (sum > max_sum)
                max_sum = sum;

            sum = 0;
        } else {
            num = try std.fmt.parseInt(u32, line, 10);
            sum += num;
        }
    }
    print("max sum: {d}\n", .{max_sum});
}
