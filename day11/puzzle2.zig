const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var buffer: [10000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    var allocator = fba.allocator();

    var monkeys: [8]std.ArrayList(usize) = undefined;
    inline for (monkeys) |_, index| {
        monkeys[index] = std.ArrayList(usize).init(allocator);
        defer monkeys[index].deinit();
    }

    try monkeys[0].insertSlice(0, &[_]usize{ 94, 71, 66 });
    try monkeys[1].insertSlice(0, &[_]usize{70});
    try monkeys[2].insertSlice(0, &[_]usize{ 78, 94, 65, 56, 68, 62 });
    try monkeys[3].insertSlice(0, &[_]usize{ 67, 94, 94, 89 });
    try monkeys[4].insertSlice(0, &[_]usize{ 63, 98, 98, 65, 73, 61, 71 });
    try monkeys[5].insertSlice(0, &[_]usize{ 60, 61, 68, 62, 55 });
    try monkeys[6].insertSlice(0, &[_]usize{ 71, 50, 89, 72, 64, 69, 91, 93 });
    try monkeys[7].insertSlice(0, &[_]usize{ 50, 76 });
    var inspected: [8]usize = .{0} ** 8;

    // 9699690
    const modulo: usize = 3 * 17 * 2 * 19 * 11 * 5 * 13 * 7;
    var round: usize = 0;
    while (round < 10000) : (round += 1) {
        for (monkeys) |*monkey, index| {
            while (monkey.popOrNull()) |a| {
                inspected[index] += 1;
                var item = a;
                switch (index) {
                    0 => {
                        // item *= 5;
                        item = (item * 5) % modulo;
                        if (item % 3 == 0) {
                            try monkeys[7].insert(0, item);
                        } else try monkeys[4].insert(0, item);
                    },
                    1 => {
                        item += 6;
                        if (item % 17 == 0) {
                            try monkeys[3].insert(0, item);
                        } else try monkeys[0].insert(0, item);
                    },
                    2 => {
                        item += 5;
                        if (item % 2 == 0) {
                            try monkeys[3].insert(0, item);
                        } else try monkeys[1].insert(0, item);
                    },
                    3 => {
                        item += 2;
                        if (item % 19 == 0) {
                            try monkeys[7].insert(0, item);
                        } else try monkeys[0].insert(0, item);
                    },
                    4 => {
                        //item *= 7;
                        item = (item * 7) % modulo;
                        if (item % 11 == 0) {
                            try monkeys[5].insert(0, item);
                        } else try monkeys[6].insert(0, item);
                    },
                    5 => {
                        item += 7;
                        if (item % 5 == 0) {
                            try monkeys[2].insert(0, item);
                        } else try monkeys[1].insert(0, item);
                    },
                    6 => {
                        item += 1;
                        if (item % 13 == 0) {
                            try monkeys[5].insert(0, item);
                        } else try monkeys[2].insert(0, item);
                    },
                    7 => {
                        //item *= item;
                        item = (item * item) % modulo;
                        if (item % 7 == 0) {
                            try monkeys[4].insert(0, item);
                        } else try monkeys[6].insert(0, item);
                    },
                    else => unreachable,
                }
            }
        }
        //        print("after round: {d}\n", .{round});
        //        for (monkeys) |*monkey, index| {
        //            print("monkey {d}: ", .{index});
        //            for (monkey.items) |item| {
        //                print("{d}, ", .{item});
        //            }
        //            print("\n", .{});
        //        }
    }

    for (inspected) |ins, i| {
        print("Monkey {d} inspected items {d}\n", .{ i, ins });
    }
}
