-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

local ipv4 = require('protocol/ipv4')

haka.rule{
	hook = ipv4.events.receive_packet,
	eval = function (p)
		pkt = p
		require('alert-doc')
		require('alertupdate-doc')
	end
}
