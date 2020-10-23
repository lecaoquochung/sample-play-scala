package controllers

import javax.inject._
import play.api._
import play.api.mvc._


/**
 * This controller creates an `Action` to handle HTTP requests to the
 * application's home page.
 */
@Singleton
class CodewarController @Inject()(val controllerComponents: ControllerComponents) extends BaseController {

  /**
   * Create an Action to render an HTML page.
   *
   * The configuration in the `routes` file means that this method
   * will be called when the application receives a `GET` request with
   * a path of `/`.
   */
//  def index() = Action { implicit request: Request[AnyContent] =>
//    Ok(views.html.index())
//  }
  def index() = Action {
    Ok("ok")
  }

  def repeatStr(times: Int, str: String): String = {
    val result = str * times
    result
  }

//  https://www.codewars.com/kata/5168bb5dfe9a00b126000018/train/scala
  def reverseString(word: String): String = {
    word.reverse
  }

}
