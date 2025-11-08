--mm:atomicArc
--deepcopy:on
--threads:on
--path:"./local"

# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config
