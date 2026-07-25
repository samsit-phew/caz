const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) {
        std.debug.print("usage: caz examplefile1.txt\n", .{});
        std.log.err("invalid number of args", .{});
        return;
    }
    const filePath = args[1];

    const cwd = std.Io.Dir.cwd();

    cwd.access(init.io, filePath, .{}) catch |e| switch (e) {
        error.FileNotFound => {
            std.log.err("file '{s}' not found", .{filePath});
            return;
        },
        else => {
            std.log.err("{}", .{e});
            return;
        },
    };

    const file = try cwd.openFile(init.io, filePath, .{});
    defer file.close(init.io);

    var memBuff: [2048]u8 = undefined;

    var reader = file.reader(init.io, &memBuff);
    var lines: usize = 0;
    std.debug.print("|{s:<36}\n|\n", .{filePath});
    while (try reader.interface.takeDelimiter('\n')) |line| {
        lines += 1;
        std.debug.print("| {d:>4} |  {s}\n", .{ lines, line });
    }
    std.debug.print("\n", .{});
    std.log.info(" lines read : {d}\n", .{lines});
}
