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
                // rock 1
                'X' => sum += 1 + 3,
                // paper 2
                'Y' => sum += 2 + 6,
                // scissors 3
                'Z' => sum += 3 + 0,
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
                'X' => sum += 1 + 6,
                'Y' => sum += 2 + 0,
                'Z' => sum += 3 + 3,
                else => {},
            },
            else => {},
        }
    }
    print("{d}\n", .{sum});
}
