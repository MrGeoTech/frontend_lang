const std = @import("std");

pub const Action = union(enum) {
    build_debug: std.fs.Dir,
    build_release: std.fs.Dir,
    test_run: std.fs.Dir,
    lsp: std.fs.Dir,
    fmt: std.fs.Dir,
};

pub const ArgumentParseError = error{
    NoActionProvided,
    InvalidAction,
} || std.process.ArgIterator.InitError || std.fs.Dir.OpenError;

pub fn getAction(allocator: std.mem.Allocator) ArgumentParseError!Action {
    var args_iterator = try std.process.argsWithAllocator(allocator);
    defer args_iterator.deinit();

    std.debug.assert(args_iterator.skip());
    const action = args_iterator.next() orelse return ArgumentParseError.NoActionProvided;

    return if (std.mem.eql(u8, "build_debug", action))
        .{
            .build_debug = if (args_iterator.next()) |dir|
                try std.fs.cwd().openDir(dir, .{ .iterate = true })
            else
                std.fs.cwd(),
        }
    else if (std.mem.eql(u8, "build_release", action))
        .{
            .build_release = if (args_iterator.next()) |dir|
                try std.fs.cwd().openDir(dir, .{ .iterate = true })
            else
                std.fs.cwd(),
        }
    else if (std.mem.eql(u8, "test_run", action))
        .{
            .test_run = if (args_iterator.next()) |dir|
                try std.fs.cwd().openDir(dir, .{ .iterate = true })
            else
                std.fs.cwd(),
        }
    else if (std.mem.eql(u8, "lsp", action))
        .{
            .lsp = if (args_iterator.next()) |dir|
                try std.fs.cwd().openDir(dir, .{ .iterate = true })
            else
                std.fs.cwd(),
        }
    else if (std.mem.eql(u8, "fmt", action))
        .{
            .fmt = if (args_iterator.next()) |dir|
                try std.fs.cwd().openDir(dir, .{ .iterate = true })
            else
                std.fs.cwd(),
        }
    else
        ArgumentParseError.InvalidAction;
}
