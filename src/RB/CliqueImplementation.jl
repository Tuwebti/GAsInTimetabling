#TODO implement a clique/degree strategy Then retimetable those modules
function cliqueStrategy()

    dataset = copy(timetablingProblem.studentsByModule)
    N = 10

    lowestscoretimetable = dataset
    comparetimetable = copy(timetablingProblem.studentsByModule)
    #comparetimetable = deleteat!(lowestscoretimetable,findin(lowestscoretimetable,mostconstrainedModule))
    DeterministicMain(lowestscoretimetable)
    lowestscore = 100

    for i from 1:N
        modremove = mostconstrainedModule(comparetimetable)
        comparetimetable = deleteat!(comparetimetable,findin(comparetimetable,modremove))
        DeterministicMain(comparetimetable)
        comparescore[i] = length(unnasignedmodules)
        if comparescore[i] < lowestscore
            lowestscoretimetable = comparetimetable
            lowestscore = comparescore[i]
            lowestscoreUModules = unassignedModules
        end
    end
    return(lowestscoretimetable,unassignedModules)
end
