add_rules("mode.release", "mode.debug")
set_languages("c++20")

target("internal_partition")
    set_kind("binary")
    add_files("src/*.cpp", "src/hello.mpp")
    add_files("src/hello_internal.mpp")
