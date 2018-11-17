include("timetablingProblem.jl")
include("import.jl")
println("Select Import Mode : \n 1 : testinput \n 2 : realData \n")
choice = readline(stdin)
if choice == "1"
    importMode=TestImport()
elseif choice == "2"
    importMode=BothYearImport()
else error("Input should be 1 or 2") end

events=["MTH1001","MTH1002","MTH1003","MTH1004","MTH2001","MTH2002","MTH2003","MTH2004"] #this is a temporary hack, need to make events into vector
clashes=zeros(length(events),length(events)) # used by analyse to calculate heatmap of clashes

for fname in ["chromosome.jl",
              "breed.jl",
              "mutate.jl",
              "genetic.jl",
              "fitness.jl"]
    include(joinpath("GA",fname))
end
include("analyse.jl")
