const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "webinterface",
        .root_source_file = .{ .path = "main/main.c" },
        //.root_source_file = null,
    });

    exe.addCSourceFiles(&[_][]const u8{
        //"main/main.c",
        "main/webserver.c",
        "main/mongoose.c",
        "main/mqtt.c",
        "main/pin_interface.c",
        "main/utils.c",
    }, &[_][]const u8{
        "-Wall",
        "-Wextra",
        "-Werror=return-type",
    });
    exe.linkLibC();
    exe.defineCMacro("__linux__", "1");
    const p = std.Build.LazyPath.relative("include");
    exe.addIncludePath(p);

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run");
    run_step.dependOn(&run_exe.step);
}
