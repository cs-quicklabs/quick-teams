// Import and register all Stimulus controllers
import { application } from "controllers/application"

// Explicitly import and register controllers for production reliability
import ApplicationController from "controllers/application_controller"
import AutoDismissController from "controllers/auto_dismiss_controller"
import CommentsController from "controllers/comments_controller"
import ConfirmationController from "controllers/confirmation_controller"
import CopyUrlController from "controllers/copy_url_controller"
import DropdownController from "controllers/dropdown_controller"
import InfiniteScrollController from "controllers/infinite_scroll_controller"
import ModalController from "controllers/modal_controller"
import NavSearchController from "controllers/nav_search_controller"
import ScrollToController from "controllers/scroll_to_controller"
import SlimSelectController from "controllers/slim_select_controller"
import SwapController from "controllers/swap_controller"
import ToggleController from "controllers/toggle_controller"

application.register("application", ApplicationController)
application.register("auto-dismiss", AutoDismissController)
application.register("comments", CommentsController)
application.register("confirmation", ConfirmationController)
application.register("copy-url", CopyUrlController)
application.register("dropdown", DropdownController)
application.register("infinite-scroll", InfiniteScrollController)
application.register("modal", ModalController)
application.register("nav-search", NavSearchController)
application.register("scroll-to", ScrollToController)
application.register("slimselect", SlimSelectController)
application.register("swap", SwapController)
application.register("toggle", ToggleController)
