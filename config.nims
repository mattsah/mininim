import
    std/os

--mm:atomicArc # Still required or mummy blows up
--deepcopy:on
--threads:on
--path:"./local"
--path:"./vendor"
--threadAnalysis:off

# begin Nimble config (version 2)
when withDir(thisDir(), os.fileExists("nimble.paths")):
    include "nimble.paths"
# end Nimble config
