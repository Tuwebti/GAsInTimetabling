include("load1.jl")
include("load2.jl")

include(joinpath("RB","Hierarchy.jl"))
include(joinpath("RB","RuleBasedtest.jl"))

(timt,unass) = DeterminsticMain()
