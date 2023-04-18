// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller

import { application } from "./application"

import ApplicationController from "./application_controller"
application.register("application", ApplicationController)

import DropdownController from "./dropdown_controller"
application.register("dropdown", DropdownController)

import InfiniteScrollController from "./infinite_scroll_controller"
application.register("infinite-scroll", InfiniteScrollController)

import ModalController from "./modal_controller"
application.register("modal", ModalController)

import NavSearchController from "./nav_search_controller"
application.register("nav-search", NavSearchController)

import ConfirmationController from "./confirmation_controller"
application.register("confirmation", ConfirmationController)

import StimulusSlimSelect from "./slim_select_controller"
application.register('slimselect', StimulusSlimSelect)

import ToggleController from "./toggle_controller"
application.register("toggle", ToggleController)

import ScrollToController from "./scroll_to_controller"
application.register("scroll-to", ScrollToController)

import SwapController from "./swap_controller"
application.register("swap", SwapController)

import CopyUrlController from "./copy_url_controller"
application.register("copy-url", CopyUrlController)
