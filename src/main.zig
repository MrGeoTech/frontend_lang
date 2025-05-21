const std = @import("std");
const arguments = @import("arguments.zig");

pub const BuildMode = enum {
    debug,
    release,
};

pub const BuildConfig = struct {
    name: []const u8,
    version: std.SemanticVersion,
    fel_version: std.SemanticVersion,

    pub fn fromFile(file: std.fs.File) !void {
        _ = file;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    
    const allocator = gpa.allocator();

    const action = try arguments.getAction(allocator);

    switch (action) {
        .build_debug => |dir| try build(dir, .debug),
        .build_release => |dir| try build(dir, .release),
        else => return error.NotImplemented,
    }
}

fn build(dir: std.fs.Dir, build_mode: BuildMode) !void {
    _ = build_mode;
    const build_file = try dir.openFile("build.fel", .{});
    defer build_file.close();
}
