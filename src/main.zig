const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 3) {
        std.debug.print("usage: caz examplefile1.txt <sizeoffile>\n", .{});
        std.log.err("invalid number of args", .{});
        return;
    }
    const filePath = args[1];
    var assumedSize = try std.fmt.parseInt(u16, args[2], 10);

    if (assumedSize > 15360) {
        assumedSize = 15360;
        std.log.info("memory is expensive dwag it ramappoclypse lowering the mem use to 15360bytes", .{});
    }

    const cwd = std.Io.Dir.cwd();

    const memBuff = try init.gpa.alloc(u8, assumedSize);
    defer init.gpa.free(memBuff);

    const contents = cwd.readFile(
        init.io,
        filePath,
        memBuff,
    ) catch |err| {
        std.log.err("{}", .{err});
        return;
    };

    std.log.info("reading of file sucessful ", .{});
    std.debug.print("{s}", .{contents});
}
