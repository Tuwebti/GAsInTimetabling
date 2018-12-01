#include("load1.jl")
#include("load2.jl") type these two in select data u want

include(joinpath("RB","Hierarchy.jl"))
include(joinpath("RB""RuleBasedtest.jl"))

dataInput = copy(timetablingProblem.studentsByModule)
(timetableSolution,unassignedModules) = DeterminsticMain(dataInput)
