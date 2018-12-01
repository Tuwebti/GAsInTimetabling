meanScores=[]
iterate_hook_alg=CollectMeanScore()

popSize = 80
iterationSteps = 10000
earlyStop = true
alg = GreedyScalableAlg
for i in 1:15
    saveFile = string(i)*"greedy.jld"
    println("\n\n\n\n")
    println("Island ", i, " : ")
    println("\n\n")
    chromosomes = evolution!(popSize,iterationSteps , earlyStop, saveFile, alg)
    save(joinpath("saved-variables",saveFile),"chromosomes",chromosomes,"meanScores",meanScores,"choice",choice)
end
