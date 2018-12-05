filenames=readdir("island")
chromosomes = []
for filename in filenames
    islandChromosomes = load(joinpath("island",filename),"chromosomes")
    push!(chromosomes, islandChromosomes[1])
end

save(joinpath("saved-variables","island.jld"),"chromosomes",chromosomes,"meanScores",[],"choice","3")
