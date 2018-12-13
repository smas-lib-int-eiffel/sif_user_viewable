note
	description: "Summary description for {SIF_PRODUCT_USER_VIEWABLE}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

deferred class
	SIF_PRODUCT_USER_VIEWABLE
	inherit
		SIF_PRODUCT
			redefine
				manufacture
			end

feature {NONE} -- Logging

	use_logging: BOOLEAN
			-- True, means logging is used during execution of the application
		do
			Result := false
		end

feature {NONE} -- Manufacturing

	manufacture
		do
			Precursor
			manufacture_views
			manufacture_controllers
		end

	manufacture_views
		-- Manufacture the views for a user interface through a viewable system interface
		deferred
		end

	manufacture_controllers
		-- Manufacture the controllers
		deferred
		end

feature -- Dynamic views

	manufacture_dynamic_views(a_system_interface: SIF_SYSTEM_INTERFACE)
			-- Add the set of views to a_system_interface
		do
			-- Intended to be empty				
		end

feature -- Controller execution

	execute_initial_controllers(a_system_interface: SIF_SYSTEM_INTERFACE; a_arguments:STRING_TABLE[STRING])
			-- Execute the initial controllers.
		do
			-- Intended to be empty				
		end

;note
	copyright: "Copyright (c) 2014-2016, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
