const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) {
        std.debug.print("usage: caz examplefile1.txt\n", .{});
        std.log.err("invalid number of args", .{});
        return;
    }

    const cwd = std.Io.Dir.cwd();

    const memBuff = try init.gpa.alloc(u8, 1024);
    defer init.gpa.free(memBuff);

    const contents = cwd.readFile(
        init.io,
        args[1],
        memBuff,
    ) catch |err| {
        std.log.err("{}", .{err});
        return;
    };

    std.log.info("reading of file sucessful ", .{});
    std.debug.print("{s}", .{contents});
}
