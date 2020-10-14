package controllers

import org.scalatestplus.play._
import org.scalatestplus.play.guice._
import play.api.test._
import play.api.test.Helpers._

import org.scalatest.{FlatSpec, Matchers}

/**
 * Add your spec here.
 * You can mock out a whole application including requests, plugins etc.
 *
 * For more information, see https://www.playframework.com/documentation/latest/ScalaTestingWithScalaTest
 */
class CodewarControllerSpec extends PlaySpec with GuiceOneAppPerTest with Injecting {
  "repeatStr method given counter is 3 and string *" should " return string ***" in {
    assert(StringRepeat.repeatStr(3, "*") == "***")
  }

}
