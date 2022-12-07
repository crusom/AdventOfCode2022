const std = @import("std");
const print = std.debug.print;

inline fn haszero(v: u32) u32 {
    return ((v) -% 0x01010101) & ~(v) & 0x80808080;
}

inline fn hasvalue(x: u32, n: u8) u32 {
    return haszero((x) ^ (0x01010101 * (@as(u32, n))));
}

pub fn main() !void {
    var buf: [10000]u8 align(@alignOf(u32)) = undefined;
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    const stat = try file.stat();
    const size = stat.size;
    _ = try file.readAll(&buf);
    var ptr = @ptrCast([*]u32, &buf)[0 .. size / 4];
    var last_word: u32 = ptr[0];
    var distinct: usize = 0;
    for (ptr[1..]) |word, index| {
        comptime var i = 0;
        inline while (i < 4) : (i += 1) {
            last_word &= 0xffffff00;
            print("word: {x}\n", .{word});
            //var byte: u8 = @truncate(u8, (word & (0xff << (8 * (3 - i)))) >> (8 * (3 - i)));

            var byte: u8 = @truncate(u8, (word & (0xff << (8 * i))) >> (8 * i));
            print("byte: {x}\n", .{byte});
            print("last_word: {x}\n", .{last_word});
            if (hasvalue(last_word, byte) == 0) {
                distinct += 1;
                if (distinct == 4) {
                    print("{d}\n", .{(index + 1) * 4 + i});
                    return;
                }
                print("last_word: {x}\n", .{last_word});
            } else {
                distinct = 0;
            }
            last_word >>= 8;
            last_word += (@as(u32, byte) << 24);
            //last_word += byte;
        }
    }
}
