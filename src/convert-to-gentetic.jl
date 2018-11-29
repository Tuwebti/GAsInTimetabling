(modulesByTimeslot,unnassignedModules)= DeterminsticMain()
function convertToChromosome(modulesByTimeslot)
    timeslotByModule = Dict()
    chromosome = Chromosome{SimpleTutorialGene}([])
    for (timeslotkey,events) in pairs(modulesByTimeslot)
        for event in events
            timeslot= parse(Int,timeslotkey)
            gene = SimpleTutorialGene(timeslot)
            if haskey(timeslotByModule,event)
                error("There should only be one timeslot per module")
            else
                chromosome[event]= gene
            end
        end
    end
    return chromosome
end
chromosome = convertToChromosome(modulesByTimeslot)
println("deterministic fitness score is ", fitness(chromosome))
