const std = @import("std");
const FileSource = std.Build.FileSource;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const tests = b.option(bool, "Tests", "Build tests [default: false]") orelse false;

    const config = b.addConfigHeader(.{
        .style = .{
            .cmake = .{ .path = "sigc++config.h.cmake" },
        },
        .include_path = "sigc++config.h",
    }, .{
        .SIGCXX_DISABLE_DEPRECATED = null,
        .SIGC_DLL = if (target.isWindows()) {} else null,
        ._ALLOW_KEYWORD_MACROS = if (target.getAbi() == .msvc) "1" else null,
    });
    const lib = b.addStaticLibrary(.{
        .name = "sigc++",
        .target = target,
        .optimize = optimize,
    });
    lib.addConfigHeader(config);
    lib.addIncludePath(".");
    lib.addCSourceFiles(&.{
        "sigc++/connection.cc",
        "sigc++/functors/slot_base.cc",
        "sigc++/signal_base.cc",
        "sigc++/trackable.cc",
    }, cxxFlags);
    lib.linkLibCpp();
    lib.installHeadersDirectoryOptions(.{
        .source_dir = FileSource.relative("sigc++"),
        .install_dir = .header,
        .install_subdir = "sigc++",
        .exclude_extensions = &.{
            "am",
            "gitignore",
            "build",
            "cc",
            "txt",
        },
    });

    b.installArtifact(lib);

    if (tests) {
        buildTest(b, .{
            .path = "examples/hello_world.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "examples/member_method.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_accum_iter.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_bind.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_compose.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_accumulated.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_hide.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_slot.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_tuple_start.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_tuple_transform_each.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_visit_each.cc",
            .lib = lib,
        });
        buildTest(b, .{
            .path = "tests/test_weak_raw_ptr.cc",
            .lib = lib,
        });
    }
}
const cxxFlags: []const []const u8 = &.{
    "-Wall",
    "-Wextra",
    "-Werror",
};
fn buildTest(b: *std.Build, info: BuildInfo) void {
    const test_exe = b.addExecutable(.{
        .name = info.filename(),
        .optimize = info.lib.optimize,
        .target = info.lib.target,
    });
    for (info.lib.include_dirs.items) |include| {
        test_exe.include_dirs.append(include) catch {};
    }
    test_exe.addCSourceFile(info.path, cxxFlags);
    test_exe.addCSourceFile("tests/testutilities.cc", cxxFlags);
    test_exe.linkLibrary(info.lib);
    test_exe.linkLibCpp();
    b.installArtifact(test_exe);

    const run_cmd = b.addRunArtifact(test_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step(
        b.fmt("{s}", .{info.filename()}),
        b.fmt("Run the {s} test", .{info.filename()}),
    );
    run_step.dependOn(&run_cmd.step);
}

const BuildInfo = struct {
    lib: *std.Build.CompileStep,
    path: []const u8,

    fn filename(self: BuildInfo) []const u8 {
        var split = std.mem.split(u8, std.fs.path.basename(self.path), ".");
        return split.first();
    }
};
