
events=sort(collect(timetablingProblem.events))
clashes=zeros(length(events),length(events)) # used by analyse to calculate heatmap of clashes
for fname in ["chromosome.jl",
              "breed.jl",
              "mutate.jl",
              "genetic.jl",
              "fitness.jl",
              "algorithms.jl"]
    include(joinpath("GA",fname))
end
