const std = @import("std");
const print = std.debug.print;

fn is_integer(c: u8) bool {
    return (c >= '0' and c <= '9');
}

pub fn main() !void {
    const debug: bool = false;
    var file = @embedFile("input");
    //var file = @embedFile("test_input");

    var iter = std.mem.split(u8, file, "\n");
    var sum: usize = 0;

    var packet1: []const u8 = undefined;
    var packet2: []const u8 = undefined;
    var packet_n: usize = 0;
    var line_i: usize = 1;

    while (iter.next()) |line| {
        line_i += 1;
        if (line.len == 0) {
            packet_n = 0;
            continue;
        }
        if (packet_n == 0) {
            packet1 = line;
            packet_n = 1;
            continue;
        } else {
            packet2 = line;
        }

        var p1_index: usize = 1;
        var p2_index: usize = 1;
        var is_list: bool = false;
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
                    sum += (line_i / 3);
                    if (debug) {
                        //print("{d}\n", .{line_i / 3});
                        print("right order\n", .{});
                    }
                } else if (p2 == ']') {
                    if (debug)
                        print("not right order\n", .{});
                }

                break;
            } else if (p1_ended) {
                break;
            } else if (p2_ended) {
                sum += (line_i / 3);
                break;
            }
            if (debug)
                print("p1: {c} p2: {c}\n", .{ p1, p2 });

            if (is_integer(p1) and is_integer(p2)) {
                var p1_iter = std.mem.tokenize(u8, packet1[p1_index..], ",]");
                var p2_iter = std.mem.tokenize(u8, packet2[p2_index..], ",]");
                var p1_int = try std.fmt.parseUnsigned(usize, p1_iter.next().?, 10);
                var p2_int = try std.fmt.parseUnsigned(usize, p2_iter.next().?, 10);
                if (p1_int < p2_int) {
                    sum += (line_i / 3);
                    //print("{d}\n", .{line_i / 3});
                    if (debug)
                        print("right order\n", .{});
                    break;
                } else if (p1_int > p2_int) {
                    if (debug)
                        print("not right order\n", .{});
                    break;
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
                is_list = true;
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
    }
    print("{d}\n", .{sum});
}
