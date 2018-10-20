include("timetablingProblem.jl")
include("import.jl")
for fname in ["chromosome.jl",
              "breed.jl",
              "mutate.jl",
              "genetic.jl",
              "fitness.jl"]
    include(joinpath("GA",fname))
end
