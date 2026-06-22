// Eager-load all Stimulus controllers under this directory.
import { application } from "controllers/application"

import HeaderController from "controllers/header_controller"
application.register("header", HeaderController)

import RevealController from "controllers/reveal_controller"
application.register("reveal", RevealController)
