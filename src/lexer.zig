const std = @import("std");

pub const LexemeList = std.ArrayListUnmanaged(Lexeme);
pub const Lexeme = union(enum) {
    /// A non-keyword value
    value: []const u8,
    /// Index of the assignment operator (:)
    assignment: u32,
    /// Index of the seperator (,)
    seperator: u32,
    /// Index of the start of the inputs (()
    input_start: u32,
    /// Index of the end of the inputs ())
    input_end: u32,
    /// Index of the start of a list ([)
    list_start: u32,
    /// Index of the start of a list (])
    list_end: u32,
    /// Index of the start of a structure ({)
    struct_start: u32,
    /// Index of the start of a structure (})
    struct_end: u32,
};

pub const LexerResult = struct {
    code: []const u8,
    lexemes: std.ArrayListUnmanaged(Lexeme),
};

pub const LexerError = error {
    IllegalWhitespace,
} | std.mem.Allocator.Error;

pub fn lexize(allocator: std.mem.Allocator, code: []const u8) LexerError!LexerResult {
    var result = LexerResult{
        .code = code,
        .lexemes = LexemeList.initCapacity(allocator, 2),
    };

    var index: u32 = 0;
    while (index < code.len) {
        result = try parseNextLexeme(allocator, &index, result);
    }

    return result;
}

fn parseNextLexeme(allocator: std.mem.Allocator, index: *u32, result: *LexerResult) LexerError!void {
    if (std.ascii.isWhitespace(result.code[index.*])) return LexerError.IllegalWhitespace;

    switch (result.code[index.*]) {
        ':' => try result.lexemes.append(allocator, .{ .assignment = index.* }),
        ',' => try result.lexemes.append(allocator, .{ .seperator = index.* }),
        '(' => try result.lexemes.append(allocator, .{ .input_start = index.* }),
        ')' => try result.lexemes.append(allocator, .{ .input_end = index.* }),
        '[' => try result.lexemes.append(allocator, .{ .list_start = index.* }),
        ']' => try result.lexemes.append(allocator, .{ .list_end = index.* }),
        '{' => try result.lexemes.append(allocator, .{ .struct_start = index.* }),
        '}' => try result.lexemes.append(allocator, .{ .struct_end = index.* }),
        else => {
            const start_index = index.*;
            while (index.* < result.code.len and 
                std.ascii.isAlphanumeric(result.code[index.*])) index.* += 1;
            try result.lexemes.append(allocator, .{ .value = result.code[start_index..index.*] });
        },
    }

    while (std.ascii.isWhitespace(result.code[index.*])) index.* += 1;
}
