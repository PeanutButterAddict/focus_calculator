const std = @import("std");
const focus_calculator = @import("focus_calculator");
const Allocator = std.mem.Allocator;

const Time = struct {
    hour: u16,
    minute: u16,

    fn initFromTotalMin(total_min: u16) Time {
        return .{
            .hour = total_min / 60,
            .minute = total_min % 60,
        };
    }

    fn initFromString(allocator: Allocator, string: []const u8) !Time {
        var str_it = std.mem.splitScalar(u8, string, ':');
        var strings = try std.ArrayList([]const u8).initCapacity(allocator, 2);
        defer strings.deinit(allocator);
        while (str_it.next()) |str| {
            try strings.append(allocator, str);
        }
        if (strings.items.len <= 0) {
            @panic("Why is the string empty?");
        }
        if (strings.items.len > 2) {
            @panic("Please keep Time in XX:XX format.");
        }
        return .{
            .hour = try std.fmt.parseUnsigned(u8, strings.items[0], 10),
            .minute = try std.fmt.parseUnsigned(u8, strings.items[1], 10),
        };
    }

    fn toTotalMinutes(self: Time) u16 {
        return self.hour * 60 + self.minute;
    }

    fn toString(self: Time) []const u8 {
        const buf: [100]u8 = undefined;
        return try std.fmt.bufPrint(buf, "{d}:{d}", .{ self.hour, self.minute });
    }
};

pub fn main() !void {
    // Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    const allocator = gpa.allocator();
    // Args array
    var args_it = try std.process.argsWithAllocator(allocator);
    defer args_it.deinit();
    _ = args_it.skip();
    var args = try std.ArrayList([]const u8).initCapacity(allocator, 3);
    while (args_it.next()) |arg| {
        const arg_non_sentinel: []const u8 = arg[0..arg.len];
        try args.append(allocator, arg_non_sentinel);
    }
    if (args.items.len < 2) {
        std.debug.print("Give at least 2 to 3 args for results. \n", .{});
        return;
    }
    if (args.items.len > 3) {
        std.debug.print("Not more than 3 args for results. \n", .{});
        return;
    }
    const start_time = try Time.initFromString(allocator, args.items[0]);
    const end_time = try Time.initFromString(allocator, args.items[1]);
    if (args.items.len <= 2) {
        const dist_time = Time.initFromTotalMin(end_time.toTotalMinutes() - start_time.toTotalMinutes());
        std.debug.print("Distraction: {d}:{d}, {d} mins \n", .{ dist_time.hour, dist_time.minute, dist_time.toTotalMinutes() });
        return;
    }
    // Calculate Distraction Time fom 3rd Arg
    var dist_str_it = std.mem.splitScalar(u8, args.items[2], ',');
    var dist_total_min: u16 = 0;
    while (dist_str_it.next()) |str| {
        dist_total_min += try std.fmt.parseUnsigned(u8, str, 10);
    }
    const dist_time = Time.initFromTotalMin(dist_total_min);
    const total_time = Time.initFromTotalMin(end_time.toTotalMinutes() - start_time.toTotalMinutes());
    if (dist_time.toTotalMinutes() > total_time.toTotalMinutes()) {
        std.debug.print("Total minutes in distraction time cannot be more than total time. \n", .{});
        return;
    }
    const focus_time = Time.initFromTotalMin(total_time.toTotalMinutes() - dist_time.toTotalMinutes());
    std.debug.print("Total: {d}:{d}, {d} mins, Distraction: {d}:{d}, {d} mins, Focus: {d}:{d}, {d} mins \n", .{ total_time.hour, total_time.minute, total_time.toTotalMinutes(), dist_time.hour, dist_time.minute, dist_time.toTotalMinutes(), focus_time.hour, focus_time.minute, focus_time.toTotalMinutes() });
}
