note
	description: "Summary description for {SIF_NOTEBOOK_TAB_VIEW}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

deferred class
	SIF_NOTEBOOK_TAB_VIEW
	inherit
		SIF_VIEW
		rename
			activate as sif_view_activate
		undefine
			default_create,
			is_equal,
			copy
		end

feature -- Activation

	activate
		-- Activate the current note book tab
		deferred
		end

note
	copyright: "Copyright (c) 2014-2016, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
