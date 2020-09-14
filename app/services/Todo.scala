package services

import javax.inject.Inject

import anorm.SqlParser._
import anorm._
import play.api.db.DBApi

import scala.language.postfixOps

//case class Todo(name: String)
case class Todo(id:Option[Long], name: String)

@javax.inject.Singleton
class TodoService @Inject() (dbapi: DBApi) {

  private val db = dbapi.database("default")

//  val simple = {
//    get[String]("todo.name") map {
//      case name => Todo(name)
//    }
//  }
  val simple = {
    get[Option[Long]]("todo.id") ~
      get[String]("todo.name") map {
      case id~name => Todo(id, name)
    }
  }

  def list(): Seq[Todo] = {

    db.withConnection { implicit connection =>

      SQL(
        """
          select * from todo
        """
      ).as(simple *)

    }

  }

  def insert(todo: Todo) = {
    db.withConnection { implicit connection =>
      SQL(
        """
        insert into todo values ((select next value for todo_seq), {name})
        """
      ).on(
        'name -> todo.name
      ).executeUpdate()
    }
  }

  def findById(id: Long): Option[Todo] = {
    db.withConnection { implicit connection =>
      SQL("select * from todo where id = {id}").on('id -> id).as(simple.singleOpt)
    }
  }

  def update(id: Long, todo: Todo) = {
    db.withConnection { implicit connection =>
      SQL(
        """
          update todo
          set name = {name}
          where id = {id}
        """
      ).on(
        'id -> id,
        'name -> todo.name
      ).executeUpdate()
    }
  }

  def delete(id: Long) = {
    db.withConnection { implicit connection =>
      SQL("delete from todo where id = {id}").on('id -> id).executeUpdate()
    }
  }

}