--mm:atomicArc # Still required or mummy blows up
--deepcopy:on
--threads:on
--path:"./local"
--path:"./vendor"

# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config
