add_rules("mode.debug", "mode.release")
set_policy("test.return_zero_on_failure", true)

for _, file in ipairs(os.files("src/test_*.cpp")) do
    local name = path.basename(file)
    target(name)
        set_kind("binary")
        set_default(false)
        add_files("src/" .. name .. ".cpp")
        add_tests("default")
        add_tests("args", {runargs = {"foo", "bar"}})
        add_tests("pass_output", {trim_output = true, runargs = "foo", pass_outputs = "hello foo"})
        add_tests("fail_output", {fail_outputs = {"hello2 .*", "hello xmake"}})
end

target("test_10")
    set_kind("binary")
    set_default(false)
    add_files("src/compile_1.cpp")
    add_tests("compile_fail", {build_should_fail = true})

target("test_11")
    set_kind("binary")
    set_default(false)
    add_files("src/compile_2.cpp")
    add_tests("compile_pass", {build_should_pass = true})

target("test_13")
    set_kind("binary")
    set_default(false)
    add_files("src/test_1.cpp")
    add_tests("stub_1", {files = "tests/stub_1.cpp", defines = "STUB_1"})

target("test_14")
    set_kind("binary")
    set_default(false)
    add_files("src/test_2.cpp")
    add_tests("stub_2", {files = "tests/stub_2.cpp", defines = "STUB_2"})

target("test_15")
    set_kind("binary")
    set_default(false)
    add_files("src/test_1.cpp")
    add_tests("stub_n", {files = "tests/stub_n*.cpp", defines = "STUB_N"})

target("test_timeout")
    set_kind("binary")
    set_default(false)
    add_files("src/run_timeout.cpp")
    add_tests("run_timeout", {run_timeout = 1000})

