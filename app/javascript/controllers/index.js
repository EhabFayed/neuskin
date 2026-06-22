// Eager-load all Stimulus controllers under this directory.
import { application } from "controllers/application"

import HeaderController from "controllers/header_controller"
application.register("header", HeaderController)

import RevealController from "controllers/reveal_controller"
application.register("reveal", RevealController)

import FilterController from "controllers/filter_controller"
application.register("filter", FilterController)

import PhoneController from "controllers/phone_controller"
application.register("phone", PhoneController)

import CountdownController from "controllers/countdown_controller"
application.register("countdown", CountdownController)

import FaqsearchController from "controllers/faqsearch_controller"
application.register("faqsearch", FaqsearchController)

import VipapplyController from "controllers/vipapply_controller"
application.register("vipapply", VipapplyController)

import CookieController from "controllers/cookie_controller"
application.register("cookie", CookieController)
