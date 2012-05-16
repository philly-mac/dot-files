package bootstrap.liftweb

import net.liftweb.http._

class Boot {
  def boot {
    LiftRules.addToPackages("example")
  }
}



