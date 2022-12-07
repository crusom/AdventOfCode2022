const std = @import("std");
const print = std.debug.print;
const Stack = @import("stack.zig").Stack;

pub fn main() !void {
    //const file = try std.fs.cwd().openFile("example_input", .{});
    const file = try std.fs.cwd().openFile("input", .{});

    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var buf: [100]u8 = undefined;
    var stack = Stack(usize, 100){};
    var sum: usize = 0;

    while (try r.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line[0] == '$') {
            // cd
            if (line[2] == 'c') {
                if (line[5] == '.') {
                    var v: usize = try stack.pop();
                    if (v <= 100000) {
                        sum += v;
                    }
                    try stack.add_to_top(v);
                } else {
                    try stack.push(0);
                }
            }
            // ls, whatever
            else {}
        } else {
            if (line[0] >= '0' and line[0] <= '9') {
                var file_size: usize = 0;
                for (line) |c| switch (c) {
                    '0'...'9' => {
                        file_size *= 10;
                        file_size += c - '0';
                    },
                    else => break,
                };
                try stack.add_to_top(file_size);
            }
        }
    }
    print("{d}\n", .{sum});
}
