const std = @import("std");
const os = std.os;
const print = std.debug.print;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var buf: [100]u8 = undefined;
    var sum: u32 = 0;
    while (try r.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var elf: u8 = line[0];
        var me: u8 = line[2];
        //  outcome of the round: 0 if you lost, 3 if the round was a draw, and 6 if you won
        switch (elf) {
            // rock
            'A' => switch (me) {
                // lose
                'X' => sum += 3 + 0,
                // draw
                'Y' => sum += 1 + 3,
                // win
                'Z' => sum += 2 + 6,
                else => {},
            },
            // paper
            'B' => switch (me) {
                'X' => sum += 1 + 0,
                'Y' => sum += 2 + 3,
                'Z' => sum += 3 + 6,
                else => {},
            },
            // scissors
            'C' => switch (me) {
                'X' => sum += 2 + 0,
                'Y' => sum += 3 + 3,
                'Z' => sum += 1 + 6,
                else => {},
            },
            else => {},
        }
    }
    print("{d}\n", .{sum});
}
