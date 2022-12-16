const std = @import("std");
const print = std.debug.print;

fn is_integer(c: u8) bool {
    return (c >= '0' and c <= '9');
}

const debug: bool = false;

//packet1 < packet2
fn compare(context: void, packet1: []const u8, packet2: []const u8) bool {
    _ = context;
    var p1_index: usize = 1;
    var p2_index: usize = 1;
    var p1_deep: usize = 0;
    var p2_deep: usize = 0;
    var p1_ended: bool = false;
    var p2_ended: bool = false;

    while (packet1[p1_index] != '\x00' and packet2[p2_index] != '\x00') {
        if (packet1[p1_index] == ',') p1_index += 1;
        if (packet2[p2_index] == ',') p2_index += 1;
        var p1 = packet1[p1_index];
        var p2 = packet2[p2_index];

        if (p1 == ']' or p2 == ']') {
            if (p1 == p2) {
                p1_index += 1;
                p2_index += 1;
                continue;
            }
            if (p1 == ']') {
                if (debug) {
                    print("right order\n", .{});
                }
                return true;
            } else if (p2 == ']') {
                if (debug)
                    print("not right order\n", .{});
                return false;
            }
            break;
        } else if (p1_ended) {
            return false;
        } else if (p2_ended) {
            return true;
        }
        if (debug)
            print("p1: {c} p2: {c}\n", .{ p1, p2 });

        if (is_integer(p1) and is_integer(p2)) {
            var p1_iter = std.mem.tokenize(u8, packet1[p1_index..], ",]");
            var p2_iter = std.mem.tokenize(u8, packet2[p2_index..], ",]");
            var p1_int: usize = std.fmt.parseUnsigned(usize, p1_iter.next().?, 10) catch unreachable;
            var p2_int: usize = std.fmt.parseUnsigned(usize, p2_iter.next().?, 10) catch unreachable;
            if (p1_int < p2_int) {
                if (debug)
                    print("right order\n", .{});
                return true;
            } else if (p1_int > p2_int) {
                if (debug)
                    print("not right order\n", .{});
                return false;
            } else {
                while (is_integer(packet1[p1_index])) p1_index += 1;
                while (is_integer(packet2[p2_index])) p2_index += 1;
                if (p1_deep > p2_deep) {
                    p1_ended = true;
                } else if (p2_deep > p1_deep) {
                    p2_ended = true;
                }

                continue;
            }
        } else if (p1 == '[' and p2 == '[') {
            p1_deep += 1;
            p2_deep += 1;

            p1_index += 1;
            p2_index += 1;
        } else {
            if (p1 == '[') {
                p1_deep += 1;
                p1_index += 1;
            } else {
                p2_deep += 1;
                p2_index += 1;
            }
        }
    }
    unreachable;
}

pub fn main() !void {
    comptime var file = @embedFile("input_without_newlines");
    comptime var len: usize = 0;
    comptime {
        comptime var iter = std.mem.split(u8, file, "\n");
        @setEvalBranchQuota(100000);
        while (iter.next()) |line| {
            if (line.len == 0 or line.len == 1) continue;
            len += 1;
        }
        len += 2;
    }

    var arr: [len][]const u8 = undefined;
    var iter = std.mem.split(u8, file, "\n");
    var index: usize = 0;
    while (iter.next()) |line| : (index += 1) {
        if (line.len == 0 or line.len == 1) continue;
        arr[index] = line;
    }

    arr[len - 2] = "[[2]]";
    arr[len - 1] = "[[6]]";

    std.sort.sort([]const u8, &arr, {}, compare);

    var n2: usize = 0;
    var n6: usize = 0;
    for (arr) |t, indice| {
        if (n2 == 0 and std.mem.indexOfDiff(u8, t, "[[2]]") == null) {
            n2 = indice + 1;
            if (n6 != 0)
                break;
        } else if (n6 == 0 and std.mem.indexOfDiff(u8, t, "[[6]]") == null) {
            n6 = indice + 1;
            if (n2 != 0)
                break;
        }
    }
    print("{d}\n", .{n2 * n6});
}
