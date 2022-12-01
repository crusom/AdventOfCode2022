const std = @import("std");
const os = std.os;
const print = std.debug.print;

fn arr_move_items(arr: []u32, indx: usize, new_val: u32) void {
    var prev_val: u32 = arr[indx];
    var i: usize = indx + 1;
    arr[indx] = new_val;
    while (i < arr.len) : (i += 1) {
        var tmp: u32 = arr[i];
        arr[i] = prev_val;
        prev_val = tmp;
    }
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buf_read = std.io.bufferedReader(file.reader());
    var r = buf_read.reader();

    var buf: [100]u8 = undefined;
    var num: u32 = 0;
    var sum: u32 = 0;
    var max_sums: [3]u32 = .{0} ** 3;
    while (try r.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            for (max_sums) |*val, i| {
                if (sum > val.*) {
                    // kinda overthought, but could't find a suiltable std function
                    arr_move_items(&max_sums, i, sum);
                    break;
                }
            }
            sum = 0;
        } else {
            num = try std.fmt.parseInt(u32, line, 10);
            sum += num;
        }
    }
    print("sum of 3 max sums: {d}\n", .{max_sums[0] + max_sums[1] + max_sums[2]});
}
