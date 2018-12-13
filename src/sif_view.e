note
	description:  "[
		A view in the system interface framework will use GUI controls of some graphical toolkit
		to be able to present it to the user using the system. A user interacts with the system
		by using the presented controls. The view can have different states. When a view is created
		it exists but to present it to a user to be able to interact with it, the view has to be activated
		first on a viewable system interface. After a view is activated, an interactor (controller or command),
		will put it in a interaction state with a set of interaction elements. To stop interaction and to
		possible hide thew view, it has to be deactivated. Destroying the view will remove it from the system.
		 	]"
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

deferred class
	SIF_VIEW

feature -- Initialization

	make (a_viewable_system_interface: SIF_SYSTEM_INTERFACE_USER_VIEWABLE; an_identifier: INTEGER_64)
			-- Create a view and register the view at the viewable user system interface
		require
			si_not_void: a_viewable_system_interface /= void
			identifier_is_not_0: an_identifier /= 0
		do
			system_insterface_viewable_user := a_viewable_system_interface
			identifier := an_identifier
			--create interaction_elements.make
			create list_of_ie_controls.make (0)
			a_viewable_system_interface.put_view (Current)
		ensure
			identifier_initialized: identifier /= 0 implies a_viewable_system_interface.has_view (identifier)
		end

feature -- Interaction

	interact (an_interaction_elements_set: SIF_INTERACTION_ELEMENT_SORTED_SET)
			-- Interact on the system interface through the set of interaction elements
			-- It should be possible for interactors to call this recursively, unique interaction elements will only be remembered once
		require
			interaction_elements_not_void: an_interaction_elements_set /= void
			is_activated : is_activated
		do
--			from
--				an_interaction_elements_set.start
--			until
--				an_interaction_elements_set.after
--			loop
--				if not interaction_elements.has_interaction_element (an_interaction_elements_set.item.identifier) then
--					interaction_elements.put(an_interaction_elements_set.item)
--				end
--				an_interaction_elements_set.forth
--			end
			do_interact( an_interaction_elements_set )

			interacting := true
		ensure
			interacting: is_interacting
			--interaction_elements_set: interaction_elements.count /= 0
		end

feature -- Access

	activate
			-- Activate the view. This is executed before the view will be presented.
			-- So here preparation actions can be taken before the view is presented.
		require
			not_activated: not is_activated
			interacting: not is_interacting
		do
			--interaction_elements.restore_subscriptions
			list_of_ie_controls.wipe_out
			activated := true
		end

	reactivate
			-- Reactivate the view
			-- When a view is activated, but the interactor has the nessecity to reuse it, whithout deactivating it first
			-- this feature can be used. This is useful when a view must be shown all the time in between more then one activations.
			-- A use case example is a login view.
		require
			activated: is_activated
			interacting: is_interacting
		do
			list_of_ie_controls.do_all (agent clear_ie_control_interaction)
			interacting := false
		end

	is_activated: BOOLEAN
		do
			Result := activated
		end

	do_present
		do
		end

	do_adjust
		do
		end

	do_present_model_to(a_view_to_present_modal_to: SIF_VIEW)
			-- Present (show) the view modal to the given view, to the user. Present is chosen to avoid collision with the much more used show feature name.
			-- The viewable system interface can be used to present a view modal to the main window or any other view.
			--
		do
				-- Intended to be empty. Useful for implementations of views which are automatically shown,
				-- eg. Widgets in a notebook.
		end

	hide
		deferred
		end

	do_interact(an_interaction_elements_set: SIF_INTERACTION_ELEMENT_SORTED_SET)
		deferred
		end

	is_interacting: BOOLEAN
		do
			Result := interacting
		end

	deactivate
			-- Deactivate the view
			-- Deactivation of the view has to make sure the view is not presented anymore to the user.
		require
			activated: is_activated
		do
			list_of_ie_controls.do_all (agent clear_ie_control_interaction)
			activated := false
			interacting := false
			--interaction_elements.suspend_subscriptions
		end

	destroy
			-- Destroy the current view from the system so all resources are freed
		deferred
		end

feature -- Status

	has_controls_ie( an_interaction_element_identifier: INTEGER_64): BOOLEAN
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > list_of_ie_controls.count or Result
			loop
				if attached list_of_ie_controls.at (i).interaction_element as l_interaction_element then
					Result := l_interaction_element.identifier = an_interaction_element_identifier
				end
				i := i + 1
			end
		end

	controls_ie(an_interaction_element_identifier: INTEGER_64): detachable SIF_INTERACTION_ELEMENT
		require
			identifier_exists: has_controls_ie(an_interaction_element_identifier)
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > list_of_ie_controls.count or Result /= void
			loop
				if attached list_of_ie_controls.at (i).interaction_element as l_interaction_element then
					if l_interaction_element.identifier = an_interaction_element_identifier then
						Result := l_interaction_element
					end
				end
				i := i + 1
			end
		end

	control(an_interaction_element_identifier: INTEGER_64): detachable SIF_IE_CONTROL
		require
			identifier_exists: has_controls_ie(an_interaction_element_identifier)
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > list_of_ie_controls.count or Result /= void
			loop
				if attached list_of_ie_controls.at (i).interaction_element as l_interaction_element then
					if l_interaction_element.identifier = an_interaction_element_identifier then
						Result := list_of_ie_controls.at (i)
					end
				end
				i := i + 1
			end
		end

feature -- Implementation

	identifier: INTEGER_64
			-- Unique view identifier

	list_of_ie_controls : ARRAYED_LIST[ SIF_IE_CONTROL ]
			-- List of controls which have their specific interaction element during interaction with the view

feature {NONE} -- Private Implementation

	system_insterface_viewable_user: SIF_SYSTEM_INTERFACE_USER_VIEWABLE

	--interaction_elements: SIF_INTERACTION_ELEMENT_SORTED_SET
			-- The sorted interaction elements of the view

	activated: BOOLEAN
			-- Indication if the view is activated or not

	interacting: BOOLEAN
			-- Indication the view is interacting

	clear_ie_control_interaction( an_ie_control: SIF_IE_CONTROL )
		do
			an_ie_control.clear_interaction
		end

feature {SIF_SYSTEM_INTERFACE} -- Presentation

	present
			-- Present (show) the view to the user. Present is chosen to avoid collision with the much more used show feature name.
			-- The viewable system interface can be used to present a view modal to the main window or any other view.
		require
			activated: is_activated
			interacting: is_interacting
		do
			do_present
		end

	adjust
			-- Adjust the view to changed content
		do
			do_adjust
		end

	present_model_to(a_view_to_present_modal_to: SIF_VIEW)
			-- Present (show) the view modal to the given view, to the user. Present is chosen to avoid collision with the much more used show feature name.
			-- The viewable system interface can be used to present a view modal to the main window or any other view.
			--
		require
			activated: is_activated
			interacting: is_interacting
		do
			--interaction_elements.restore_subscriptions
			do_present_model_to(a_view_to_present_modal_to)
		end

note
	copyright: "Copyright (c) 2014-2016, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
