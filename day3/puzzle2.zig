const std = @import("std");
const os = std.os;
const print = std.debug.print;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var buf: [100]u8 = undefined;
    var codepoints: [80]u8 = .{0} ** 80;
    var sum: u32 = 0;
    var index: usize = 1;
    while (try r.readUntilDelimiterOrEof(&buf, '\n')) |line| : (index += 1) {
        if (index % 3 == 0) {
            for (line) |c| {
                if (codepoints[c - 'A'] == 2) {
                    print("{c}\n", .{c});
                    sum += switch (c) {
                        'A'...'Z' => c - 'A' + 27,
                        'a'...'z' => c - 'a' + 1,
                        else => unreachable,
                    };
                    @memset(&codepoints, 0, codepoints.len);
                    break;
                }
            }
        } else {
            var already_checked: [80]bool = .{false} ** 80;
            for (line) |c| {
                if (already_checked[c - 'A'] == false) {
                    codepoints[c - 'A'] += 1;
                    already_checked[c - 'A'] = true;
                }
            }
        }
    }
    print("{d}\n", .{sum});
}
