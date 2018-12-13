note
	description: "Summary description for {SIF_CONTROLLER_MULTIPLE_SELECT}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

class
	SIF_CONTROLLER_MULTIPLE_SELECT

inherit
	SIF_CONTROLLER
		rename
			caption_identifier as Iei_multiple_select_caption
		redefine
			default_create,
			ended,
			cleanup
		select
			default_create
		end

	SIF_SHARED_COMMAND_MANAGER
		undefine
			default_create
		end

	SIF_COMMAND_IDENTIFIERS
		undefine
			default_create
		end

	SIF_INTERACTION_ELEMENT_IDENTIFIERS
		rename
			default_create as sif_interaction_element_identifiers_default_create
		end

	SIF_VIEW_IDENTIFIERS
		undefine
			default_create
		end

feature -- Initialization

	default_create
		do
			create selected_list_result.make_empty
			sif_interaction_element_identifiers_default_create
			create interaction_elements.make
			make_with_interaction_elements(interaction_elements)
		end

feature -- Execution

	put_information( a_name: detachable STRING; a_source_list: detachable ARRAY[ARRAY[STRING]]; a_selections: detachable ARRAY[INTEGER] )
		require
			correct_information: a_name /= void and a_source_list /= void and a_selections /= void
		do
			name := a_name
			source_list := a_source_list
			selections := a_selections
		end

	do_execute( si : SIF_SYSTEM_INTERFACE )
		local
			list_row: ARRAY[STRING]
		do
			ie_confirm.event_label.publish ("Ok")
			ie_cancel.event_label.publish ("Annuleer")
		end


feature -- Access

	selected_list_result: ARRAY[INTEGER]

feature -- Interaction

	do_publish_caption (an_ie_caption: SIF_IE_EVENT)
			-- Identify this interactor by setting a caption, which can be used for presentation by the system interface
		local
			caption_text: STRING
		do
			create caption_text.make_from_string ("Selectie van meerdere elementen.")
			if attached name as l_name then
				if not l_name.is_empty then
					caption_text.make_empty
					caption_text.append ("Selectie van meerdere elementen voor: ")
					caption_text.append (l_name)
					caption_text.append (".")
				end
			end
			an_ie_caption.event_label.publish (caption_text)
		end

feature {NONE} -- Interaction elements

	do_prepare_interaction_elements
			-- Prepare the necessary interaction elements for the interactor
		do
			create_interaction_elements

			ie_confirm.event.subscribe (agent handle_ok)
			ie_cancel.event.subscribe (agent handle_cancel)

			if attached name as l_name  and
			   attached source_list as l_source_list and
			   attached selections as l_selections then
				if attached	ie_event_multiple_selection.ie_name as l_target_name then
					l_target_name.text.copy (l_name)
				end
				ie_event_multiple_selection.selections.copy(l_selections)
				ie_event_multiple_selection.ie_source_list.event_list.publish (l_source_list)
			end
		end

	create_interaction_elements
			-- Prepare the necessary interaction elements for the interactor
		do
			create ie_event_multiple_selection.make (Iei_multiple_select, interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "select" )
		end

	ie_event_multiple_selection: SIF_IE_LIST_MULTIPLE_SELECT

	name: detachable STRING

	source_list: detachable ARRAY[ARRAY[STRING]]

	selections: detachable ARRAY[INTEGER]

feature {NONE} -- Implementation

	handle_ok
		do
			execution_result.put_passed
			if attached selections as l_selections then
				l_selections.copy (ie_event_multiple_selection.selections)
			end
			ended
		end

	handle_cancel
		do
			execution_result.put_failed
			ended
		end

	ended
		do
			Precursor
		end

	cleanup
			-- Make sure that all instances used during execution wil be detached
		do
			source_list := void
			selections := void
			Precursor
		end

note
	copyright: "Copyright (c) 2014-2017, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
