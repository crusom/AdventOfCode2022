const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var buf: [10000]u8 align(@alignOf(u32)) = undefined;
    var codepoints: [0x80]u8 = .{0} ** 0x80;
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    _ = try file.readAll(&buf);
    var repetitive: usize = 0;
    var i: usize = 0;
    while (i < 14) : (i += 1) {
        codepoints[buf[i]] += 1;
        if (codepoints[buf[i]] > 1) {
            repetitive += 1;
        }
    }

    while (i < 4095) : (i += 1) {
        var c: u8 = buf[i];
        if (codepoints[buf[i - 14]] > 1)
            repetitive -= 1;

        codepoints[buf[i - 14]] -= 1;

        codepoints[c] += 1;
        if (codepoints[c] > 1) {
            repetitive += 1;
        }
        if (repetitive == 0) {
            print("{d}\n", .{i + 1});
            return;
        }
    }
}
