note
	description: "Summary description for {SIF_SYSTEM_INTERFACE_USER_VIEWABLE}."
	author: "Paul Gokke"
	date: "$Date$"
	revision: "$Revision$"
	library: "System Interface Framework (SIF)"
	legal: "See notice at end of class."

deferred class
	SIF_SYSTEM_INTERFACE_USER_VIEWABLE

inherit
	SIF_SYSTEM_INTERFACE_USER

feature -- Intitialization

	make
			-- Initialize the viewable user system interface with a main window
		do
			create views.make (50)
			create views_active.make(50)
			create controllers.make (50)
		end


feature -- Interaction

	interact(an_interaction_elements_set: SIF_INTERACTION_ELEMENT_SORTED_SET)
			-- Interact through the set of interaction elements
		do
			across views_active as l_view loop l_view.item.interact (an_interaction_elements_set) end
		end

feature -- Status

	has_view( a_view_identifier : INTEGER_64) : BOOLEAN
			-- Does the requested view id exist in this system interface?
		do
			Result := views.has (a_view_identifier)
		end

	has_activated_view( a_view_identifier : INTEGER_64) : BOOLEAN
			-- Does the requested view id exist in this system interface?
		do
			Result := views_active.has (a_view_identifier)
		end

	view(a_view_identifier : INTEGER_64): detachable SIF_VIEW
			-- Retrieve view from the registered views.
		require
			view_registered: has_view (a_view_identifier)
		do
			if attached views.item (a_view_identifier) as l_view_to_activate then
				Result := views.item (a_view_identifier)
			end
		end

	view_activated(a_view_identifier : INTEGER_64): detachable SIF_VIEW
			-- Retrieve view from the registered views.
		require
			view_activated: has_activated_view (a_view_identifier)
		do
			if attached views_active.item (a_view_identifier) as l_view_active then
				Result := views_active.item (a_view_identifier)
			end
		end

	has_controller( a_view_identifier : INTEGER_64) : BOOLEAN
			-- Does the requested view id exist in the list of controllers?
		do
			Result := controllers.has (a_view_identifier)
		end

	is_view_controller_executing (a_view_identifier : INTEGER_64) : BOOLEAN
			-- True, when the corresponding controller of the given view identifier is cuurently executing
		do
			if attached controllers.at (a_view_identifier) as l_controller then
				Result := l_controller.is_executing
			end
		end

feature -- Element Change

	put_view( a_new_view : SIF_VIEW )
			-- Put the new view in the register of known views
		require
			view_not_registered_before: not has_view(a_new_view.identifier)
		do
			views.put (a_new_view, a_new_view.identifier)
		end

	activate_view( a_view_identifier : INTEGER_64)
			-- Activate the view if present in the views register.
		require
			view_registered: has_view (a_view_identifier)
		do
			views.search (a_view_identifier)
			if views.found then
				if attached views.found_item as l_view_to_activate then
					views_active.put (l_view_to_activate, a_view_identifier)
					l_view_to_activate.activate
				end
			end
		end

	reactivate_view( a_view_identifier : INTEGER_64)
			-- Activate the view if present in the views register.
		require
			view_registered: has_view (a_view_identifier)
		do
			views.search (a_view_identifier)
			if views.found then
				if attached views.found_item as l_view_to_activate then
					l_view_to_activate.reactivate
				end
			end
		end

	deactivate_view( a_view_identifier : INTEGER_64)
			-- Activate the view if present in the views register.
		require
			view_registered: has_view (a_view_identifier)
		do
			if attached views.item (a_view_identifier) as l_view_to_deactivate then
				l_view_to_deactivate.deactivate
				views_active.remove (a_view_identifier)
			end
		end

	present_view( a_view_identifier : INTEGER_64)
			-- Present the view if present in the views register to the user.
		require
			view_registered: has_view (a_view_identifier)
		do
			if attached views.item (a_view_identifier) as l_view_to_show then
				l_view_to_show.present
			end
		end

	hide_view( a_view_identifier : INTEGER_64)
			-- Hide the view if present in the views register to the user.
		require
			view_registered: has_view (a_view_identifier)
		do
			if attached views.item (a_view_identifier) as l_view_to_hide then
				l_view_to_hide.hide
			end
		end

	adjust_view
			-- Adjust all active views to new content
		do
			across views_active as l_view loop l_view.item.adjust end
		end

	present_view_model_to( a_view_identifier : INTEGER_64; a_view_identifier_to_present_model_to: INTEGER_64)
			-- Present the view if present in the views register to the user.
		require
			view_registered: has_view (a_view_identifier)
			view_to_present_model_to_registered: has_view (a_view_identifier_to_present_model_to)
		do
			if attached views.item (a_view_identifier) as l_view_to_show and
			   attached views.item (a_view_identifier_to_present_model_to) as l_view_to_present_modal_to then
				l_view_to_show.present_model_to(l_view_to_present_modal_to )
			end
		end

	destroy
			-- Destroy the system interface, free all resources
		do
			across views as l_view loop l_view.item.destroy end
		end

	put_controller( a_new_controller : SIF_CONTROLLER; a_view_identifier: INTEGER_64)
		require
			view_registered: has_view (a_view_identifier)
			controller_not_registered_before: not has_controller (a_view_identifier)
		do
			controllers.put (a_new_controller, a_view_identifier)
		end

feature -- Controller related

	execute_controller_with_view(a_view_identifier: INTEGER_64)
		-- Execute the controller with the indentified view and remember them
		require
			view_registered: has_view (a_view_identifier)
			controller_registered: has_controller (a_view_identifier)
			controller_is_not_executing: not is_view_controller_executing (a_view_identifier)
		do
			if permissions_manager.has_view_identifier_permission (a_view_identifier) then
				if attached controllers.at (a_view_identifier) as l_controller then
					activate_view (a_view_identifier)
					l_controller.execute(Current)
					present_view (a_view_identifier)
				end
			end
		end

	end_controller_with_view(a_view_identifier: INTEGER_64)
		-- Execute the controller with the indentified view and remember them
		require
			view_registered: has_view (a_view_identifier)
			controller_registered: has_controller (a_view_identifier)
			controller_not_executing: is_view_controller_executing (a_view_identifier)
		do
			if permissions_manager.has_view_identifier_permission (a_view_identifier) then
				if attached controllers.at (a_view_identifier) as l_controller then
					deactivate_view (a_view_identifier)
					l_controller.end_execution
				end
			end
		end

feature {NONE}

	views: HASH_TABLE[SIF_VIEW, INTEGER_64]
			-- All available main views of the viewable user interface

	views_active: HASH_TABLE[SIF_VIEW, INTEGER_64]
			-- All active views on the viewable user system interface

	controllers: HASH_TABLE[SIF_CONTROLLER, INTEGER_64]
			-- All controller view combinations

;note
	copyright: "Copyright (c) 2014-2018, SMA Services"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			SMA Services
			Website: http://www.sma-services.com
		]"

end
