function algChoice()
    println("Which algorithm ? : \n 1 simpleAlg \n 2 ScalableAlg \n 3 GreedyScalableAlg \n 4 VariableScalableAlg ")
    algChoice = readline(stdin)
    if algChoice == "1"
        alg = simpleAlg
    elseif algChoice == "2"
        alg = ScalableAlg()
    elseif algChoice == "3"
        alg = GreedyScalableAlg()
    elseif algChoice == "4"
        alg = AlternatingScalableAlg()
    end
    return alg
end
function earlyStopChoice()
    println("")
    println("earlyStop ? y/n :")
    earlyStop = readline(stdin) == "y"
    return earlyStop
end

#---------------------

println("start from existing chromosomes ? y/n :")
initializeChoice = readline(stdin) == "y"
if !initializeChoice
    # global variables for data collection and processing
    meanScores=[]
    iterate_hook_alg=CollectMeanScore()

    # global variables for which algorithms to use
    if choice == "1"
        popSize = 5
        iterationSteps = 300
    elseif choice == "2"
        popSize = 5
        iterationSteps = 300
    elseif choice == "3"
        popSize = 30
        iterationSteps = 2000
    end
    println("Do you want to change popSize ? (default is : " * string(popSize) * " ) y/n :")
    changepopSizeflag = readline(stdin)
    if changepopSizeflag == "y"
        println("enter new popSize :")
        popSize = parse(Int, readline(stdin))
    end
    println("Do you want to change iterationSteps ? (default is : " * string(iterationSteps) * " ) y/n :")
    changeiterationStepsflag = readline(stdin)
    if changeiterationStepsflag == "y"
        println("enter new iterationSteps :")
        iterationSteps = parse(Int, readline(stdin))
    end
    earlyStop = earlyStopChoice()
    alg= algChoice()
    println("")
    println("file name :")
    saveFile = readline(stdin) * ".jld"
    chromosomes = evolution!(popSize,iterationSteps , earlyStop, saveFile, alg)
else
    println("specify file to load from :")
    saveFile = readline(stdin) * ".jld"
    chromosomes = load(joinpath("saved-variables",saveFile),"chromosomes")
    meanScores = load(joinpath("saved-variables",saveFile),"meanScores")
    choice = load(joinpath("saved-variables",saveFile),"choice")
    iterate_hook_alg=CollectMeanScore()
    println("select iterationSteps :")
    iterationSteps = parse(Int, readline(stdin))
    earlyStop = earlyStopChoice()
    alg = algChoice()
    chromosomes = continueEvolution(chromosomes, iterationSteps, earlyStop, saveFile, alg)
end

include("saveVariables.jl")

#---------------

