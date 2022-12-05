const std = @import("std");
const os = std.os;
const print = std.debug.print;
const Stack = @import("stack.zig").Stack;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var buf: [100]u8 = undefined;
    var stack_lines: [9][100]u8 = undefined;
    var stacks: [9]Stack(u8, 100) = undefined;
    inline for (stacks) |_, index| {
        stacks[index] = Stack(u8, 100){};
    }

    var i: usize = 0;
    while (i < 8) : (i += 1) {
        _ = try r.readUntilDelimiterOrEof(&stack_lines[i], '\n');
    }

    i = 8;
    while (i > 0) : (i -= 1) {
        var elem_num: usize = 0;
        while (elem_num < 9) : (elem_num += 1) {
            if (stack_lines[i - 1][elem_num * 4 + 1] != ' ')
                try stacks[elem_num].push(stack_lines[i - 1][elem_num * 4 + 1]);
        }
    }

    // skip 2 lines
    _ = try r.readUntilDelimiterOrEof(&buf, '\n');
    _ = try r.readUntilDelimiterOrEof(&buf, '\n');

    while (try r.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var iter = std.mem.tokenize(u8, line, "move from to");
        var times = try std.fmt.parseUnsigned(usize, iter.next().?, 10);
        var from = try std.fmt.parseUnsigned(usize, iter.next().?, 10) - 1;
        var to = try std.fmt.parseUnsigned(usize, iter.next().?, 10) - 1;
        try stacks[to].take_in(try stacks[from].take_off(times));
    }
    for (stacks) |*stack| {
        var c = try stack.*.pop();
        print("{c}", .{c});
    }
}
