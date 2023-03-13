// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import SelectionSubscriptionController from "./selection_subscription_controller"
application.register("selection-subscription", SelectionSubscriptionController)

import SweetalertController from "./sweetalert_controller"
application.register("sweetalert", SweetalertController)

import TypedJsController from "./typed_js_controller"
application.register("typed-js", TypedJsController)
