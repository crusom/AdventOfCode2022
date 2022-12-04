const std = @import("std");
const os = std.os;
const print = std.debug.print;

fn find(arr: []u8, delimiter: u8) usize {
    var i: usize = 0;
    while (arr[i] != delimiter) : (i += 1) {}
    return i;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var buf: [100]u8 = undefined;
    var sum: u32 = 0;
    // THIS CODE IS DISGUISTING, please dont look at it...
    // it was my first try, before i realised i could do it just by a simple iteration...
    // anyway, i will be smarter in the future
    while (try r.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var delimiter1 = find(line, '-');
        var elf1_range1 = line[0..delimiter1];
        delimiter1 += 1;

        var delimiter2 = find(line, ',');
        var elf1_range2 = line[delimiter1..delimiter2];
        delimiter1 = delimiter2 + 1;

        delimiter2 = find(line[delimiter1..], '-') + delimiter1;
        var elf2_range1 = line[delimiter1..delimiter2];
        delimiter1 = delimiter2 + 1;

        var elf2_range2 = line[delimiter1..];

        if ((try std.fmt.parseInt(u32, elf1_range2, 10) >= try std.fmt.parseInt(u32, elf2_range2, 10) and try std.fmt.parseInt(u32, elf1_range1, 10) <= try std.fmt.parseInt(u32, elf2_range1, 10)) or (try std.fmt.parseInt(u32, elf2_range2, 10) >= try std.fmt.parseInt(u32, elf1_range2, 10) and try std.fmt.parseInt(u32, elf2_range1, 10) <= try std.fmt.parseInt(u32, elf1_range1, 10)))
            sum += 1;
    }
    print("{d}\n", .{sum});
}
