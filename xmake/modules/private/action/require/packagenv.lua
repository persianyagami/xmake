--!A cross-platform build utility based on Lua
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Copyright (C) 2015-2020, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        packagenv.lua
--

-- imports
import("core.package.package", {alias = "core_package"})

-- enter the package environments
function _enter_package(package_name, envs, installdir)

    -- save the old environments
    _g._OLDENVS = _g._OLDENVS or {}
    local oldenvs = _g._OLDENVS[package_name]
    if not oldenvs then
        oldenvs = {}
        _g._OLDENVS[package_name] = oldenvs
    end

    -- add the new environments
    for name, values in pairs(envs) do
        oldenvs[name] = oldenvs[name] or os.getenv(name)
        if name == "PATH" or name == "LD_LIBRARY_PATH" or name == "DYLD_LIBRARY_PATH" then
            for _, value in ipairs(values) do
                if path.is_absolute(value) then
                    os.addenv(name, value)
                else
                    os.addenv(name, path.join(installdir, value))
                end
            end
        else
            os.addenv(name, unpack(table.wrap(values)))
        end
    end
end

-- leave the package environments
function _leave_package(package_name)
    _g._OLDENVS = _g._OLDENVS or {}
    local oldenvs = _g._OLDENVS[package_name]
    if oldenvs then
        for name, values in pairs(oldenvs) do
            os.setenv(name, values)
        end
        _g._OLDENVS[package_name] = nil
    end
end

-- enter environment of the given binary packages, git, 7z, ..
function enter(...)
    for _, name in ipairs({...}) do
        for _, manifest_file in ipairs(os.files(path.join(core_package.installdir(), name:sub(1, 1), name, "*", "*", "manifest.txt"))) do
            local manifest = io.load(manifest_file)
            if manifest and manifest.plat == os.host() and manifest.arch == os.arch() then
                _enter_package(name, manifest.envs, path.directory(manifest_file))
            end
        end
    end
end

-- leave environment of the given binary packages, git, 7z, ..
function leave(...)
    for _, name in ipairs({...}) do
        _leave_package(name)
    end
end
