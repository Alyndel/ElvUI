local _, ns = ...
local oUF = ns.oUF
local Private = oUF.Private

-- ElvUI_CPU knock off by Simpy (STILL UNFINISHED)

local type = type
local wipe = wipe
local rawset = rawset
local unpack = unpack
local CopyTable = CopyTable
local getmetatable = getmetatable
local setmetatable = setmetatable
local debugprofilestop = debugprofilestop

local _default = { total = 0, average = 0, count = 0 }
local _data, _info = { _all = CopyTable(_default) }, {}

local Collect = function(object, key, func, ...)
	local start = debugprofilestop()
	local args = { func(...) }
	local finish = debugprofilestop() - start

	local obj = _data[object]
	if not obj then
		obj = { _module = CopyTable(_default) }

		if object == Private then
			_info.oUF_Private = obj -- only export timing data
		end

		_data[object] = obj
	end

	local data = obj[key]
	if data then
		data.count = data.count + 1

		if data.finish > data.high then
			data.high = data.finish
		end

		if data.finish < data.low then
			data.low = data.finish
		end

		data.total = data.total + finish
		data.average = data.total / data.count
	else
		data = { high = finish, low = finish, total = finish, average = finish, count = 1 }
		obj[key] = data
	end

	-- update data
	data.start = start
	data.finish = finish

	local module = obj._module
	if module then -- module totals
		module.total = module.total + finish
		module.count = module.count + 1
		module.average = module.total / module.count
	end

	local all = _data._all
	if all then -- overall totals
		all.total = all.total + finish
		all.count = all.count + 1
		all.average = all.total / all.count
	end

	return unpack(args)
end

local Generate = function(object, key, func)
	-- print('Generate', object, key, func)

	return function(...)
		if _info._enabled then
			return Collect(object, key, func, ...)
		else
			return func(...)
		end
	end
end

local Generator = function(object, key, value)
	-- print('Generator', key, value)

	if type(value) == 'function' then
		local func = Generate(object, key, value)
		rawset(object, key, func)
	else
		rawset(object, key, value)
	end
end

_info.data = _data

_info.reset = function()
	wipe(_data)

	_info.oUF_Private = nil

	_data._all = CopyTable(_default)
end

_info.state = function(value)
	_info._enabled = value
end

_info.func = function(tbl, ...)
	-- print('Profiler', tbl)

	local t = getmetatable(tbl)
	if t then
		t.__newindex = Generator

		return tbl, ...
	else
		return setmetatable(tbl, { __newindex = Generator }), ...
	end
end

oUF.Profiler = _info
