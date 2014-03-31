-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

require('luaunit')

TestVBuffer = {}

function TestVBuffer:test_invalid_iterator_erase_from_start()
	local buf = haka.vbuffer_from("toto")
	local pos = buf:pos(0)

	pos:advance(1)

	buf:sub(0, 2):erase()

	local success, msg = pcall(function () pos:advance(1) end)
	assert(not success and msg == "invalid buffer iterator", "failed to detect invalid iterator")
end

function TestVBuffer:test_invalid_iterator_erase()
	local buf = haka.vbuffer_from("toto")
	local pos = buf:pos(0)

	pos:advance(2)

	buf:sub(1, 3):erase()

	local success, msg = pcall(function () pos:advance(1) end)
	assert(not success and msg == "invalid buffer iterator", "failed to detect invalid iterator")
end

function TestVBuffer:test_asbit_empty()
	local buf = haka.vbuffer_allocate(0)
	local success, msg = pcall(function () buf:sub():asbits(8, 6) end)
	assert(not success and msg == "asbits: invalid bit offset", "failed to detect invalid asbits offset")
end

function TestVBuffer:test_setbit_empty()
	local buf = haka.vbuffer_allocate(0)
	local success, msg = pcall(function () buf:sub():setbits(8, 6, 0) end)
	assert(not success and msg == "setbits: invalid bit offset", "failed to detect invalid setbits offset")
end

function TestVBuffer:test_asbit_too_small()
	local buf = haka.vbuffer_allocate(2)
	local success, msg = pcall(function () buf:sub():asbits(12, 24) end)
	assert(not success and msg == "asbits: invalid bit size", "failed to detect invalid asbits size")
end

function TestVBuffer:test_asnumber_too_big()
	local buf = haka.vbuffer_allocate(10)
	local success, msg = pcall(function () buf:sub():asnumber() end)
	assert(not success and msg == "asnumber: unsupported size 10", "failed to detect invalid asnumber size")
end

function TestVBuffer:test_setbit_too_big()
	local buf = haka.vbuffer_allocate(8)
	local success, msg = pcall(function () buf:sub():setbits(12, 2000, 2000) end)
	assert(not success and msg == "setbits: unsupported size 2000", "failed to detect invalid setbits size too big")
end

function TestVBuffer:test_setbit_too_small()
	local buf = haka.vbuffer_allocate(2)
	local success, msg = pcall(function () buf:sub():setbits(12, 24, 0) end)
	assert(not success and msg == "setbits: invalid bit size", "failed to detect invalid setbits size too small")
end

function TestVBuffer:test_insert_on_itself()
	local buf = haka.vbuffer_allocate(10)
	local success, msg = pcall(function () buf:pos(4):insert(buf) end)
	assert(not success and msg == "circular buffer insertion", "failed to detect insert on itself")
end

function TestVBuffer:test_append_on_itself()
	local buf = haka.vbuffer_allocate(10)
	local success, msg = pcall(function () buf:append(buf) end)
	assert(not success and msg == "circular buffer insertion", "failed to detect insert on itself")
end

LuaUnit:setVerbosity(1)
LuaUnit:run('TestVBuffer')
