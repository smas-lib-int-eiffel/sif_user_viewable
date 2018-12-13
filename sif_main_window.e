note
	description: "Summary description for {SIF_MAIN_WINDOW}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

deferred class
	SIF_MAIN_WINDOW

inherit

	SIF_VIEW
		rename
			make as sif_view_make
		end

	SIF_VIEW_IDENTIFIERS

feature -- Initialization

	make (a_viewable_system_interface: SIF_SYSTEM_INTERFACE_USER_VIEWABLE)
		do
			sif_view_make (a_viewable_system_interface, Vi_general_main_view)
			create title.make_empty
		end

feature -- Status setting

	set_title (a_title: like title)
			-- Assign `a_title' to `title'.
		require
			a_title_not_void: a_title /= Void
		do
			title := a_title
			activate_title
		end

feature {NONE} -- Activation

	activate_title
			-- Make sure the underlying graphical toolkit displays the new title set by set_title
		deferred
		end

feature {NONE} -- Implementation

	title: STRING

;note
	copyright: "Copyright (c) 2014-2016, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
