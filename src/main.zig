const std = @import("std");

pub fn main() !void {
    const stdout = std.fs.File.stdout();
    try stdout.writeAll("seine\n");
}

test "main runs without error" {
    try std.testing.expect(true);
}
