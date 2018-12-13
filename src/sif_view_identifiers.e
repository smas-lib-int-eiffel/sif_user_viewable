note
	description: "Summary description for {SIF_VIEW_IDENTIFIERS}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

class
	SIF_VIEW_IDENTIFIERS

feature {NONE} -- Enumeration main groups systems wise
	--
	-- A view identifier may not be 0 ever.
	--
	Vi_general_lowest: INTEGER_64 = 1

	Vi_lowest: INTEGER_64
		once
			Result := Vi_general_lowest
		end

	Vi_general_main_view: INTEGER_64
		once
			Result := Vi_general_lowest
		end

	Vi_general_multiple_select: INTEGER_64
		once
			Result := Vi_general_lowest + 1
		end

	Vi_general_tree_multiple_select: INTEGER_64
		once
			Result := Vi_general_lowest + 2
		end
		
	Vi_general_dialog_confirmation: INTEGER_64
		once
			Result := Vi_general_lowest + 100
		end

	Vi_general_dialog_error_abort_retry: INTEGER_64
		once
			Result := Vi_general_lowest + 101
		end

	Vi_general_highest: INTEGER_64 = 9999

	Vi_highest: INTEGER_64
		once
			Result := Vi_general_highest
		end

note
	copyright: "Copyright (c) 2014-2018, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
