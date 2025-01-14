import
    mininim,
    std/httpcore

export
    httpcore

class Route of Facet:
    var path*: string
    var methods*: seq[HttpMethod]