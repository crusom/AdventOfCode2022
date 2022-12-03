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
        const compartment1 = line[0 .. line.len / 2];
        const compartment2 = line[line.len / 2 .. line.len];
        var codepoints: [80]u8 = .{0} ** 80;
        for (compartment1) |c| {
            codepoints[c - 'A'] = 1;
        }
        for (compartment2) |c| {
            if (codepoints[c - 'A'] == 1) {
                sum += switch (c) {
                    'A'...'Z' => c - 'A' + 27,
                    'a'...'z' => c - 'a' + 1,
                    else => unreachable,
                };
                break;
            }
        }
    }
    print("{d}\n", .{sum});
}
