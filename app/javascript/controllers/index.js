// Eager-load all Stimulus controllers under this directory.
import { application } from "controllers/application"

import HeaderController from "controllers/header_controller"
application.register("header", HeaderController)

import RevealController from "controllers/reveal_controller"
application.register("reveal", RevealController)

import FilterController from "controllers/filter_controller"
application.register("filter", FilterController)

import JrfilterController from "controllers/jrfilter_controller"
application.register("jrfilter", JrfilterController)

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

import CounterController from "controllers/counter_controller"
application.register("counter", CounterController)

import BookingController from "controllers/booking_controller"
application.register("booking", BookingController)

import IntroController from "controllers/intro_controller"
application.register("intro", IntroController)

import ParallaxController from "controllers/parallax_controller"
application.register("parallax", ParallaxController)

import ProtoindexController from "controllers/protoindex_controller"
application.register("protoindex", ProtoindexController)

import HscrollController from "controllers/hscroll_controller"
application.register("hscroll", HscrollController)

import LivepreviewController from "controllers/livepreview_controller"
application.register("livepreview", LivepreviewController)

import ThemeController from "controllers/theme_controller"
application.register("theme", ThemeController)

import CarouselController from "controllers/carousel_controller"
application.register("carousel", CarouselController)

import FlipController from "controllers/flip_controller"
application.register("flip", FlipController)

import CursorController from "controllers/cursor_controller"
application.register("cursor", CursorController)

import MagneticController from "controllers/magnetic_controller"
application.register("magnetic", MagneticController)

import SmoothscrollController from "controllers/smoothscroll_controller"
application.register("smoothscroll", SmoothscrollController)
