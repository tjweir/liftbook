import scala.io.Source

sealed abstract class State
case object Normal extends State
case object InListing extends State
case object InQuotes extends State

var state: State = Normal
var insetDepth = 0
for (file <- args) {
  val outputFile = new java.io.FileWriter(file + "-fixed")

  for ((line,index) <- Source.fromFile(file).getLines.zipWithIndex) {
    //print (file,index,line)
    var output = line
    state match {
      case Normal if line.matches("""(?s)^\\begin_inset listings.*""") => {
	//printf("Found listing at %s : %d\n", file, index + 1)
	state = InListing
	insetDepth = 1
      }
      case InListing => {
	  
	if (line.matches("""(?s)\\begin_inset Quotes e[lr]d.*""")) {
	  printf("Bad quotes at %s : %d\n", file, index + 1)
	  output = "\"\n"
	  state = InQuotes
	} else {
	  if (line.matches("""(?s)\\begin_inset.*""")) {
	    insetDepth += 1
	  }
	  if (line.matches("""(?s)\\end_inset.*""")) {
	    insetDepth -= 1
	  }
	  if (insetDepth == 0) {
	    state = Normal
	  }
	}
      }
      case InQuotes if line.matches("""(?s)\\end_inset.*""") => {
	output = ""
	state = InListing
      }
      case InQuotes => output = ""
      case Normal =>
	// ok
    } 
    outputFile.write(output)
  }

  outputFile.close()
}
