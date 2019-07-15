package computerdatabase

import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

import scala.concurrent.duration._

case class Request(path: String, body: String)

class RailsSimulation extends Simulation {

  val ip = "18.179.16.51"
  val httpConf: HttpProtocolBuilder = http
//    .baseUrl("http://rails5-sample-alb-2086313179.ap-northeast-1.elb.amazonaws.com")
    .baseUrl(s"http://$ip")
    .acceptHeader("application/json,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

  val scn: ScenarioBuilder = scenario("Rails get")
    .repeat(10000) {
      exec {
        http("request")
          .get("/posts")
      }
    }

  val rps: Int = 100
  val durationMinutes: Int = 1

  setUp(scn.inject(atOnceUsers(rps)).protocols(httpConf))
    .throttle(jumpToRps(rps), holdFor(durationMinutes.minutes))
    .maxDuration(durationMinutes.minutes)
}
