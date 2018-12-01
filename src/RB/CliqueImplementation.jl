#TODO implement a clique/degree strategy Then retimetable those modules
function cliqueStrategy()

    dataset = copy(timetablingProblem.studentsByModule)
    comparedataset = copy(timetablingProblem.studentsByModule)
    (comparetimetable, lowestscoreUModules) = DeterminsticMain(dataset)
    lowestscoretimetable = Dict{String,Set{Event}}()
    unassignedmodules = []
    lowestscore = 100
    rang = [1 2 3 4 5]
    comparescore = [0 0 0 0 0]
    for i in rang
        modremove = mostConstrainedModule(comparedataset)
        delete!(comparedataset,modremove)
        copydataset = copy(comparedataset)
        println("amount of modules: ",length(collect(keys(copydataset))))
        (comparetimetable,unassignedmodules) = DeterminsticMain(comparedataset)

        comparescore[i] = length(unassignedmodules)

        if comparescore[i] < lowestscore
            lowestscoretimetable = copy(comparetimetable)
            lowestscore = comparescore[i]
            lowestscoreUModules = unassignedmodules
        end
        comparedataset = copydataset
    end
    println(comparescore)
    return(lowestscoretimetable,lowestscoreUModules)
end
