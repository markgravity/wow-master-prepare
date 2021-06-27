local Class = {}
MasterCore.Class = Class

local deepcopy
deepcopy = function(orig, ignoresMetas)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end

        if not ignoresMetas then
            setmetatable(copy, deepcopy(getmetatable(orig)))
        end
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function Class:Create(name, baseclass)
    local super = {}
    local classdef = {}
    classdef.__className = name
    classdef.super = super

    function super:Init(...)
        if name == self.__className then
            self = setmetatable(deepcopy(self, true), { __index = baseclass })
        end

        if baseclass ~= nil then
            baseclass.Init(self, ...)
        end
        return self
    end

    function classdef:Init(...)
        return super.Init(self, ...)
    end

    return classdef, super
end