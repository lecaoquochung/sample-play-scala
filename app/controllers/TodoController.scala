package controllers

//コピペ
import javax.inject._
import play.api.mvc._

import play.api.data._
import play.api.data.Forms._
//コピペ

//入力
class TodoController @Inject()(mcc: MessagesControllerComponents)
  extends MessagesAbstractController(mcc) {

  def helloworld() = Action { implicit request: MessagesRequest[AnyContent] =>
    Ok("Hello World")
  }

  def list() = Action { implicit request: MessagesRequest[AnyContent] =>
    val message: String = "Show TODO list here"
    Ok(views.html.list(message))
  }

}
//入力