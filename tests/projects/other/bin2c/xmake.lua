add_rules("mode.debug", "mode.release")

target("test")
    set_kind("binary")
    add_rules("utils.bin2c", {linewidth = 16, extensions = {".bin", ".png"}})
    add_files("src/*.c")
    add_files("src/*.bin")
    add_files("src/*.png")


