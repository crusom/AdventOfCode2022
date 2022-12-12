const std = @import("std");
const expect = std.testing.expect;

const QueueError = error{
    FullQueue,
    EmptyQueue,
};

pub fn Queue(comptime T: type, comptime arg_size: usize) type {
    return struct {
        const Self = @This();
        size: usize = 0,
        array: [arg_size]T = undefined,
        head: usize = 0,
        tail: usize = 0,

        pub fn is_empty(self: *Self) bool {
            if (self.size == 0) return true;
            return false;
        }

        pub fn front(self: *Self) QueueError!T {
            if (self.size == 0) return error.EmptyQueue;
            return self.array[self.tail];
        }

        pub fn push(self: *Self, value: T) QueueError!void {
            if (self.size == self.array.len) return error.FullQueue;

            self.size += 1;
            self.array[self.head] = value;

            if (self.head == self.array.len - 1) {
                self.head = 0;
            } else self.head += 1;
        }

        pub fn pop(self: *Self) QueueError!T {
            if (self.is_empty()) return error.EmptyQueue;
            const ret = self.array[self.tail];

            if (self.tail == self.array.len - 1) {
                self.tail = 0;
            } else self.tail += 1;

            self.size -= 1;
            return ret;
        }
    };
}

test "queue test1" {
    var queue: Queue(u16, 100) = Queue(u16, 100){};
    try queue.push(1);
    try queue.push(2);
    try queue.push(3);
    try expect(try queue.pop() == 1);
    try expect(try queue.pop() == 2);
    try expect(try queue.pop() == 3);
    try expect(queue.pop() == QueueError.EmptyQueue);
}

test "queue test2" {
    var queue: Queue(u16, 100) = Queue(u16, 100){};
    try queue.push(1);
    try expect(try queue.pop() == 1);
    try queue.push(2);
    try expect(try queue.pop() == 2);
    try queue.push(3);
    try expect(try queue.pop() == 3);
    try expect(queue.is_empty() == true);
}
