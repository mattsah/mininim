--gc:orc
--threads:on
--path:"./local"
--path:"./"

# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config
