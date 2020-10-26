package controllers

import scala.concurrent.Future

import org.scalatestplus.play._
import play.api.mvc._
import org.scalatestplus.play.guice._
import play.api.test._
import play.api.test.Helpers._

import org.scalatest.{FlatSpec, Matchers}

import scala.collection.mutable

/**
 * Add your spec here.
 * You can mock out a whole application including requests, plugins etc.
 *
 * For more information, see https://www.playframework.com/documentation/latest/ScalaTestingWithScalaTest
 */
//class CodewarControllerSpec extends PlaySpec with GuiceOneAppPerTest with Injecting {
//  "repeatStr method given counter is 3 and string *" should " return string ***" in {
//    assert(StringRepeat.repeatStr(3, "*") == "***")
//  }
//
//}

class CodewarControllerSpec extends PlaySpec with Results {

  "Example Page#index" should {
    "should be valid" in {
      val controller             = new CodewarController(Helpers.stubControllerComponents())
      val result: Future[Result] = controller.index().apply(FakeRequest())
      val bodyText: String       = contentAsString(result)
      bodyText mustBe "ok"
    }
  }

//  "repeatStr method given counter is 3 and string *" should {
//    " return string ***" in {
//      assert(StringRepeat.repeatStr(3, "*") == "***")
//    }
//  }

//  "def reverseString" should {
//    "pass fixed tests" in {
//      Kata.solution("dlrow") should equal ("world")
//      val controller             = new CodewarController(Helpers.stubControllerComponents())
//      controller.reverseString("dlrow") should equal ("world")
//    }
//  }
}