include("timetablingProblem.jl")
include("import.jl")

#---------------

println("Select Import Mode : \n 1 : testinput \n 2 : realData \n 3 : benchmark dataset 1")
choice = readline(stdin)
if choice == "1"
    importMode=TestImport()
elseif choice == "2"
    importMode=BothYearImport()
elseif choice == "3"
    importMode=Data1Import()
else error("Input should be 1 , 2 or 3") end
timetablingProblem = timetableImport(importMode)

#---------------

events=sort(collect(timetablingProblem.events))
clashes=zeros(length(events),length(events)) # used by analyse to calculate heatmap of clashes

for fname in ["chromosome.jl",
              "breed.jl",
              "mutate.jl",
              "genetic.jl",
              "fitness.jl"]
    include(joinpath("GA",fname))
end

#---------------

include("analyse.jl")
