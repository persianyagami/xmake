add_rules("mode.debug", "mode.release")

rule("test")
    add_deps("xcode.application")
    after_build(function ()
        print("xxx")
    end)

target("test")
    add_rules("xcode.application")
    add_files("src/*.m", "src/**.storyboard", "src/*.xcassets")
    add_files("src/Info.plist")
    add_rules("test")
