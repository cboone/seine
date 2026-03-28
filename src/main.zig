const std = @import("std");

pub fn run(writer: anytype) !void {
    try writer.writeAll("seine\n");
}

pub fn main() !void {
    const stdout = std.fs.File.stdout();
    try run(stdout.writer());
}

test "run writes banner" {
    var buf: [64]u8 = undefined;
    var stream = std.io.fixedBufferStream(&buf);
    try run(stream.writer());
    try std.testing.expectEqualStrings("seine\n", stream.getWritten());
}
