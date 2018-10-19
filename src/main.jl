include("timetablingProblem.jl")
include("import.jl")
for fname in ["chromosome.jl",
              "breed.jl",
              "mutate.jl",
              "genetic.jl"]
    include(joinpath("GA",fname))
end
include("fitness.jl")
evolution!()
