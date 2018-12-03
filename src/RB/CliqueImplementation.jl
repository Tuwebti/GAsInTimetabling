#TODO implement a clique/degree strategy Then retimetable those modules
function cliqueStrategy()
    dataset = copy(timetablingProblem.studentsByModule)
    comparedataset = copy(timetablingProblem.studentsByModule)
    (comparetimetable, lowestscoreUModules) = DeterminsticMain(dataset,false)
    lowestscoretimetable = Dict{String,Set{Event}}()
    unassignedmodules = []
    lowestscore = 100
    removeNmodules = 50
    removedModules = []
    comparescore = zeros(Int,1,removeNmodules)
    for i in 1:removeNmodules
        modremove = mostConstrainedModule(comparedataset)
        union!(removedModules,[modremove])
        delete!(comparedataset,modremove)
        copydataset = copy(comparedataset)
        println("amount of modules: ",length(collect(keys(copydataset))))
        (comparetimetable,unassignedmodules) = DeterminsticMain(comparedataset,false)

        comparescore[i] = length(unassignedmodules)

        if comparescore[i] < lowestscore
            lowestscoretimetable = copy(comparetimetable)
            lowestscore = comparescore[i]
            lowestscoreUModules = unassignedmodules
        end
        comparedataset = copydataset
    end
    println(comparescore)
    return(lowestscoretimetable,lowestscoreUModules,removedModules,comparescore)
end
