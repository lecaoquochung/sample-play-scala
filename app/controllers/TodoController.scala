package controllers

import javax.inject._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import services._

//class TodoController @Inject()(mcc: MessagesControllerComponents) extends
// MessagesAbstractController(mcc) {
class TodoController @Inject()(todoService: TodoService, mcc: MessagesControllerComponents)
  extends MessagesAbstractController(mcc) {

  def helloworld() = Action { implicit request: MessagesRequest[AnyContent] =>
    Ok("Hello World")
  }

//  def list() = Action { implicit request: MessagesRequest[AnyContent] =>
//    val message: String = "Show TODO list here"
//    Ok(views.html.list(message))
//  }

//  def list() = Action { implicit request: MessagesRequest[AnyContent] =>
//    val items: Seq[Todo] = Seq(Todo("Todo1"), Todo("Todo2"))
//    Ok(views.html.list(items))
//  }

  // list() with todoService
  def list() = Action { implicit request: MessagesRequest[AnyContent] =>
    val items: Seq[Todo] = todoService.list()
    Ok(views.html.list(items))
  }

  val todoForm: Form[String] = Form("name" -> nonEmptyText)

  def todoNew = Action { implicit request: MessagesRequest[AnyContent] =>
    Ok(views.html.createForm(todoForm))
  }

//  def todoAdd() = Action { implicit request: MessagesRequest[AnyContent] =>
//    val name: String = todoForm.bindFromRequest().get
//    println(name)
//    Ok("Save")
//  }
//  def todoAdd() = Action { implicit request: MessagesRequest[AnyContent] =>
//    val name: String = todoForm.bindFromRequest().get
//    todoService.insert(Todo(name))
//    Redirect(routes.TodoController.list())
//  }
  def todoAdd() = Action { implicit request: MessagesRequest[AnyContent] =>
    val name: String = todoForm.bindFromRequest().get
    todoService.insert(Todo(id = None, name))
    Redirect(routes.TodoController.list())
  }

  def todoEdit(todoId: Long) = Action { implicit request: MessagesRequest[AnyContent] =>
    todoService.findById(todoId).map { todo =>
      Ok(views.html.editForm(todoId, todoForm.fill(todo.name)))
    }.getOrElse(NotFound)
  }

  def todoUpdate(todoId: Long) = Action { implicit request: MessagesRequest[AnyContent] =>
    val name: String = todoForm.bindFromRequest().get
    todoService.update(todoId, Todo(Some(todoId), name))
    Redirect(routes.TodoController.list())
  }

  def todoDelete(todoId: Long) = Action { implicit request: MessagesRequest[AnyContent] =>
    todoService.delete(todoId)
    Redirect(routes.TodoController.list())
  }

}
//入力