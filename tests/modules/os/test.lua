function test_cpdir(t)
    -- get mclock
    local tm = os.mclock()
    -- test cpdir
    os.mkdir("test1")
    t:require(os.exists("test1"))
    os.cp("test1","test2")
    t:require(os.exists("test2"))
    os.rmdir("test1")
    t:require_not(os.exists("test1"))
    io.writefile("test2/awd","awd")
    os.rmdir("test2")
    t:require_not(os.exists("test2"))
    -- assert mclock
    t:require(os.mclock() >= tm)
end

function test_rename(t)
    -- get mclock
    local tm = os.mclock()
    -- test rename
    os.mkdir("test1")
    t:require(os.exists("test1"))
    os.mv("test1","test2")
    t:require_not(os.exists("test1"))
    t:require(os.exists("test2"))
    os.rmdir("test2")
    t:require_not(os.exists("test2"))
    -- assert mclock
    t:require(os.mclock() >= tm)
end

function test_cp_mvdir_into_another_dir(t)
    -- get mclock
    local tm = os.mclock()
    -- test cp/mvdir into another dir
    os.mkdir("test1")
    os.mkdir("test2")
    t:require(os.exists("test1"))
    t:require(os.exists("test2"))
    os.cp("test1","test2")
    t:require(os.exists("test2/test1"))
    os.mv("test1","test2/test1")
    t:require_not(os.exists("test1"))
    t:require(os.exists("test2/test1/test1"))
    os.rmdir("test2")
    t:require_not(os.exists("test2"))
    -- assert mclock
    t:require(os.mclock() >= tm)
end

function test_cp_symlink(t)
    if is_host("windows") then
        return
    end
    os.touch("test1")
    os.ln("test1", "test2")
    t:require(os.isfile("test1"))
    t:require(os.isfile("test2"))
    t:require(os.islink("test2"))
    os.cp("test2", "test3")
    t:require(os.isfile("test3"))
    t:require(not os.islink("test3"))
    os.cp("test2", "test4", {symlink = true})
    t:require(os.isfile("test4"))
    t:require(os.islink("test4"))
    os.mkdir("dir")
    os.touch("dir/test1")
    os.cd("dir")
    os.ln("test1", "test2")
    os.cd("-")
    t:require(os.islink("dir/test2"))
    os.cp("dir", "dir2")
    t:require(not os.islink("dir2/test2"))
    os.cp("dir", "dir3", {symlink = true})
    t:require(os.islink("dir3/test2"))
    os.tryrm("test1")
    os.tryrm("test2")
    os.tryrm("test3")
    os.tryrm("test4")
    os.tryrm("dir")
    os.tryrm("dir2")
    os.tryrm("dir3")
    t:require(not os.exists("test1"))
    t:require(not os.exists("test2"))
    t:require(not os.exists("dir"))
end

function test_setenv(t)
    -- get mclock
    local tm = os.mclock()
    -- test setenv
    os.setenv("__AWD","DWA")
    t:are_equal(os.getenv("__AWD"), "DWA")
    os.setenv("__AWD","DWA2")
    t:are_equal(os.getenv("__AWD"), "DWA2")
    -- assert mclock
    t:require(os.mclock() >= tm)
end

function test_argv(t)
    t:are_equal(os.argv(""), {})
    -- $cli aa bb cc
    t:are_equal(os.argv("aa bb cc"), {"aa", "bb", "cc"})
    -- $cli aa --bb=bbb -c
    t:are_equal(os.argv("aa --bb=bbb -c"), {"aa", "--bb=bbb", "-c"})
    -- $cli "aa bb cc" dd
    t:are_equal(os.argv('"aa bb cc" dd'), {"aa bb cc", "dd"})
    -- $cli aa(bb)cc dd
    t:are_equal(os.argv('aa(bb)cc dd'), {"aa(bb)cc", "dd"})
    -- $cli aa\\bb/cc dd
    t:are_equal(os.argv('aa\\bb/cc dd'), {"aa\\bb/cc", "dd"})
    -- $cli "aa\\bb/cc dd" ee
    t:are_equal(os.argv('"aa\\\\bb/cc dd" ee'), {"aa\\bb/cc dd", "ee"})
    -- $cli "aa\\bb/cc (dd)" ee
    t:are_equal(os.argv('"aa\\\\bb/cc (dd)" ee'), {"aa\\bb/cc (dd)", "ee"})
    -- $cli -DTEST=\"hello\"
    t:are_equal(os.argv('-DTEST=\\"hello\\"'), {'-DTEST="hello"'})
    -- $cli -DTEST=\"hello\" -DTEST=\"hello\"
    t:are_equal(os.argv('-DTEST=\\"hello\\" -DTEST2=\\"hello\\"'), {'-DTEST="hello"', '-DTEST2="hello"'})
    -- $cli -DTEST="hello"
    t:are_equal(os.argv('-DTEST="hello"'), {'-DTEST=hello'})
    -- $cli -DTEST="hello world"
    t:are_equal(os.argv('-DTEST="hello world"'), {'-DTEST=hello world'})
    -- $cli -DTEST=\"hello world\"
    t:are_equal(os.argv('-DTEST=\\"hello world\\"'), {'-DTEST="hello', 'world\"'})
    -- $cli "-DTEST=\"hello world\"" "-DTEST2="\hello world2\""
    t:are_equal(os.argv('"-DTEST=\\\"hello world\\\"" "-DTEST2=\\\"hello world2\\\""'), {'-DTEST="hello world"', '-DTEST2="hello world2"'})
    -- $cli '-DTEST="hello world"' '-DTEST2="hello world2"'
    t:are_equal(os.argv("'-DTEST=\"hello world\"' '-DTEST2=\"hello world2\"'"), {'-DTEST="hello world"', '-DTEST2="hello world2"'})
    -- only split
    t:are_equal(os.argv('-DTEST="hello world"', {splitonly = true}), {'-DTEST="hello world"'})
    t:are_equal(os.argv('-DTEST="hello world" -DTEST2="hello world2"', {splitonly = true}), {'-DTEST="hello world"', '-DTEST2="hello world2"'})
end

function test_args(t)
    t:are_equal(os.args({}), "")
    t:are_equal(os.args({"aa", "bb", "cc"}), "aa bb cc")
    t:are_equal(os.args({"aa", "--bb=bbb", "-c"}), "aa --bb=bbb -c")
    t:are_equal(os.args({"aa bb cc", "dd"}), '"aa bb cc" dd')
    t:are_equal(os.args({"aa(bb)cc", "dd"}), 'aa(bb)cc dd')
    t:are_equal(os.args({"aa\\bb/cc", "dd"}), "aa\\bb/cc dd")
    t:are_equal(os.args({"aa\\bb/cc dd", "ee"}), '"aa\\\\bb/cc dd" ee')
    t:are_equal(os.args({"aa\\bb/cc (dd)", "ee"}), '"aa\\\\bb/cc (dd)" ee')
    t:are_equal(os.args({"aa\\bb/cc", "dd"}, {escape = true}), "aa\\\\bb/cc dd")
    t:are_equal(os.args('-DTEST="hello"'), '-DTEST=\\"hello\\"')
    t:are_equal(os.args({'-DTEST="hello"', '-DTEST2="hello"'}), '-DTEST=\\"hello\\" -DTEST2=\\"hello\\"')
    t:are_equal(os.args('-DTEST=hello'), '-DTEST=hello') -- irreversible
    t:are_equal(os.args({'-DTEST="hello world"', '-DTEST2="hello world2"'}), '"-DTEST=\\\"hello world\\\"" "-DTEST2=\\\"hello world2\\\""')
end

