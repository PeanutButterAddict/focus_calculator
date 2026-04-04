const std = @import("std");
const focus_calculator = @import("focus_calculator");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    const allocator = gpa.allocator();
    var args_it = try std.process.argsWithAllocator(allocator);
    defer args_it.deinit();
    var i: u8 = 0;
    while (args_it.next()) |arg| : (i += 1) {
        std.debug.print("Index {d} => {s}\n", .{ i, arg });
    }
}
