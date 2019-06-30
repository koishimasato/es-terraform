package elasticsearch

import java.io._

import io.gatling.core.Predef._
import io.gatling.core.feeder.{Feeder, SourceFeederBuilder}
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

import scala.concurrent.duration._

case class Request(path: String, body: String)

object FileFeeder {
  def apply(): Feeder[String] = {
    val br = new BufferedReader(new InputStreamReader(new FileInputStream(sys.env("TEST_DATA_PATH"))))
    Iterator.continually {
      val line = br.readLine()
      val relativePath = line.split(" ")(1)
      val body = line.replaceFirst("POST [^\\{]*", "")
      Map("path" -> relativePath, "body" -> body)
    }.takeWhile(_ != null)
  }
}

class ElasticsearchSimulation extends Simulation {

  private val url = "http://localhost:8080"

  val httpConf: HttpProtocolBuilder = http
    .contentTypeHeader("application/json")
    .baseUrl(url)
    .acceptHeader("application/json")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

//  val feeder = FileFeeder()
  val feeder: SourceFeederBuilder[String] = csv("es-requests.csv").random

  val scn: ScenarioBuilder = scenario("Elastic Search Post")
    .repeat(1601061) {
      feed(feeder)
        .exec {
          http("request")
            .post("""/${path}""")
            .body(StringBody("""${body}"""))
          //          .asJSON
        }
    }

  val rps: Int = sys.env.getOrElse("USER_PER_SEC_RATE", "3").toInt
  val durationSeconds: Int = sys.env.getOrElse("DURATION_MINUTES", "2").toInt

  setUp(scn.inject(atOnceUsers(rps)).protocols(httpConf))
    .throttle(jumpToRps(rps), holdFor(durationSeconds.seconds))
    .maxDuration(durationSeconds.seconds)
}


