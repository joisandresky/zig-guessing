const std = @import("std");

const MyError = error{
    LuTololYak,
    EmangLuTololSih,
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const now = std.time.nanoTimestamp();
    var rng = std.rand.DefaultPrng.init(@intCast(now));

    const target = rng.random().intRangeLessThan(i32, 1, 100);

    try stdout.print("I'm thinking of a number between 1 and 100\n", .{});

    var guess: i32 = 0;
    var attempt: i32 = 0;

    while (guess != target) {
        try stdout.print("Enter your guess (1-100): ", .{});

        const buf = try std.heap.page_allocator.alloc(u8, 64);
        const input = try std.io.getStdIn().reader().readUntilDelimiter(buf, '\n');
        defer std.heap.page_allocator.free(buf);

        guess = std.fmt.parseInt(i32, input, 10) catch {
            return MyError.LuTololYak;
        };

        attempt += 1;

        try stdout.print("You guessed {d}\n", .{guess});

        if (guess < target) {
            try stdout.print("Too Low!\n", .{});
        } else if (guess > target) {
            try stdout.print("Too High!\n", .{});
        } else {
            try stdout.print("Correct! You took {d} attempts\n", .{attempt});
        }
    }
}
