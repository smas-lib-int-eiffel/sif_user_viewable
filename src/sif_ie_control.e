note
	description: "Summary description for {SIF_IE_CONTROL}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

deferred class
	SIF_IE_CONTROL

feature -- Interaction

	put_interaction_element( an_interaction_element: detachable SIF_INTERACTION_ELEMENT; a_view: SIF_VIEW )
		do
			if interaction_element = void then
				current_interacting_view := a_view
				interaction_element := an_interaction_element
				if attached an_interaction_element as l_ie then
					a_view.list_of_ie_controls.force (Current)
				end
				do_put_interaction_element( an_interaction_element )
			end
		end

	clear_interaction
		do
			interaction_element := void
		end

feature {NONE} -- Interaction

	do_put_interaction_element( an_interaction_element: detachable SIF_INTERACTION_ELEMENT )
		deferred
		end

feature {SIF_VIEW} -- Interaction

	interaction_element: detachable SIF_INTERACTION_ELEMENT

feature -- Implementation

	current_interacting_view : detachable SIF_VIEW

;note
	copyright: "Copyright (c) 2014-2016, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
