package controllers

import javax.inject.Inject

import play.api.mvc._
//import play.api.templates.Html // deprecated (Since version 2.3.0) Use play.twirl.api.Html
import play.twirl.api.Html

class SampleController @Inject() (cc: ControllerComponents) extends AbstractController(cc) {
  def index = Action {
//    Ok("It works!")
    val content = Html("<div>This is the content for the sample app<div>")
    Ok (views.html.sample("Home")(content))
  }
}