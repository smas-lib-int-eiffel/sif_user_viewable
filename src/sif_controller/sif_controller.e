note
	description:  "[
		Class CONTROLLER plays a central part of the system interface architecture framework.
		The CONTROLLER class will only be used as an interacter with views of a viewable system
		interface.
		The role of the controller should be to direct the execution of an interactive session;
		this may include creating and coordinating views and or other controllers. 
		The controller handles user actions, which may lead to updates of the view, the model or both.

		A controller is responsible for a certain part of a specific problem/application domain.
		It will have to subscribe the model through available agents from the model to the
		system interface abstraction. This may only be done by using interaction elements
		and not directly to a view. This makes it possible to execute functionality from
		the problem/application domain on different system interfaces, but only viewable ones!

		When possible the controllers need to (re)use commands for specific functionality.

		Controllers are considered as "glue code", so the implementation should be kept as
		minimal as possible.

		The agents of the model, which are to be used to subscribe and unsubscribe to the event types
		available in the different interaction elements, should be available as a single reference,
		by using a single variable. This is necessary to overcome the problem mentioned in
		Touch Of Class, H18 page 691.
		 	]"
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

deferred class
	SIF_CONTROLLER

inherit
	SIF_INTERACTOR
		rename
			make as interactor_make
		redefine
			create_basic_interaction_elements
		end

	SHARED_SIF_PERMISSIONS_MANAGER
		undefine
			default_create
		end

	SIF_VIEW_IDENTIFIERS
		undefine
			default_create
		end

feature {NONE} -- Initialization basic interaction elements

	create_basic_interaction_elements
			-- <Precursor>
		do
			Precursor

			create ie_confirm.make(Iei_confirm, interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "confirm")
			create ie_cancel.make(Iei_cancel, interaction_elements, {SIF_ENUM_INTERACTION_ELEMENT_TYPE}.enum_control, "cancel")
		end

		ie_confirm: SIF_IE_EVENT
				-- Basic, always available interaction element to confirm

		ie_cancel: SIF_IE_EVENT
				-- Basic, always available interaction element to cancel

feature {NONE} -- Control flow

	make_with_interaction_elements(an_interaction_elements_set: SIF_INTERACTION_ELEMENT_SORTED_SET)
		do
			interactor_make(an_interaction_elements_set)

			executing_controllers.force (Current, executing_controllers.count + 1)
		end

	executing_controllers : ARRAY[ SIF_CONTROLLER ]
		once
			create Result.make_empty
		end

feature {SIF_CONTROLLER} -- Refresh

	refresh
		local
			i: INTEGER
			stopped: BOOLEAN
		do
			from
				i := 1
				last_refresh_error.make_empty
			until
				i > executing_controllers.count or stopped
			loop
				stopped := executing_controllers.at (i).do_refresh
				i := i + 1
			end
			if stopped then
				if attached system_interface as l_system_interface then
					check error_text_set: not last_refresh_error.is_empty end
					l_system_interface.error (last_refresh_error)
				end
			end
		end

	do_refresh: BOOLEAN
			-- Refresh information if due. Result true, means something went wrong and refreshing all controllers must stop.
		do
		end

	last_refresh_error: STRING
		once
			create Result.make_empty
		end

feature {NONE} -- Generic dialog handling

	handle_confimation_dialog( a_caption: READABLE_STRING_GENERAL; a_confirmation_text: READABLE_STRING_GENERAL; a_proc_ok: PROCEDURE[]; a_proc_cancel: PROCEDURE[]; a_view_model_to_id: like {SIF_VIEW}.identifier)
		do
			if attached {SIF_SYSTEM_INTERFACE_USER_VIEWABLE}system_interface as l_si_user_viewable then
				create_general_dynamic_interaction_elements
				if attached dynamic_elements as l_dynamic_elements and then
				   attached {SIF_IE_TEXT}l_dynamic_elements.interaction_element (Iei_generic_dynamic_caption) as l_iei_generic_dynamic_caption and then
				   attached {SIF_IE_EVENT}l_dynamic_elements.interaction_element (Iei_generic_dynamic_ok) as l_iei_generic_dynamic_ok and then
				   attached {SIF_IE_EVENT}l_dynamic_elements.interaction_element (Iei_generic_dynamic_cancel) as l_iei_generic_dynamic_cancel and then
				   attached {SIF_IE_TEXT}l_dynamic_elements.interaction_element (Iei_generic_dynamic_text) as l_iei_generic_dynamic_text then
			   		l_iei_generic_dynamic_caption.event_output.publish (a_caption.to_string_32)
				   	l_iei_generic_dynamic_ok.event.subscribe (a_proc_ok)
				   	l_iei_generic_dynamic_cancel.event.subscribe (a_proc_cancel)
				   	l_iei_generic_dynamic_text.event_output.publish (a_confirmation_text.to_string_32)
					l_si_user_viewable.activate_view (Vi_general_dialog_confirmation)
					l_si_user_viewable.interact (l_dynamic_elements)
					l_si_user_viewable.present_view_model_to (Vi_general_dialog_confirmation, a_view_model_to_id)
				end
			end
		end

	handle_error_abort_retry_dialog( a_caption: READABLE_STRING_GENERAL; an_error_text: READABLE_STRING_GENERAL; a_proc_ok: PROCEDURE[]; a_proc_cancel: PROCEDURE[]; a_view_model_to_id: like {SIF_VIEW}.identifier)
		do
			if attached {SIF_SYSTEM_INTERFACE_USER_VIEWABLE}system_interface as l_si_user_viewable then
				create_general_dynamic_interaction_elements
				if attached dynamic_elements as l_dynamic_elements and then
				   attached {SIF_IE_TEXT}l_dynamic_elements.interaction_element (Iei_generic_dynamic_caption) as l_iei_generic_dynamic_caption and then
				   attached {SIF_IE_EVENT}l_dynamic_elements.interaction_element (Iei_generic_dynamic_ok) as l_iei_generic_dynamic_ok and then
				   attached {SIF_IE_EVENT}l_dynamic_elements.interaction_element (Iei_generic_dynamic_cancel) as l_iei_generic_dynamic_cancel and then
				   attached {SIF_IE_TEXT}l_dynamic_elements.interaction_element (Iei_generic_dynamic_text) as l_iei_generic_dynamic_text then
			   		l_iei_generic_dynamic_caption.event_output.publish (a_caption.to_string_32)
				   	l_iei_generic_dynamic_ok.event.subscribe (a_proc_ok)
				   	l_iei_generic_dynamic_cancel.event.subscribe (a_proc_cancel)
				   	l_iei_generic_dynamic_text.event_output.publish (an_error_text.to_string_32)
					l_si_user_viewable.activate_view (Vi_general_dialog_confirmation)
					l_si_user_viewable.interact (l_dynamic_elements)
					l_si_user_viewable.present_view_model_to (Vi_general_dialog_confirmation, a_view_model_to_id)
				end
			end
		end

note
	copyright: "Copyright (c) 2014-2018, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
