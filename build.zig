const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const opt = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(
        .{
            .name = "caz",
            .root_module = b.createModule(
                .{
                    .optimize = opt,
                    .target = target,
                    .root_source_file = b.path("src/main.zig"),
                },
            ),
        },
    );

    b.installArtifact(exe);

    const runStep = b.step("run", "run da app");
    const runCmd = b.addRunArtifact(exe);
    runStep.dependOn(&runCmd.step);
}
