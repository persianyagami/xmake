add_rules("mode.debug", "mode.release")
add_requires("zig")

target("test")
    set_kind("binary")
    add_files("src/*.zig")
    set_toolchains("@zig")

