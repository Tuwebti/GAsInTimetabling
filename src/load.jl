include("timetablingProblem.jl")
include("import.jl")
println("Select Import Mode : \n 1 : testinput \n 2 : realData \n")
choice = readline(stdin)
if choice == "1"
    importMode=TestImport()
elseif choice == "2"
    importMode=BothYearImport()
else error("Input should be 1 or 2") end
for fname in ["chromosome.jl",
              "breed.jl",
              "mutate.jl",
              "genetic.jl",
              "fitness.jl"]
    include(joinpath("GA",fname))
end
include("analyse.jl")
