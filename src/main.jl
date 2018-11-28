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
println("")
println("earlyStop ? y/n :")
earlyStop = readline(stdin) == "y"
println("Which algorithm ? : \n 1 simpleAlg ")
algChoice = readline(stdin)
if algChoice == "1"
    alg = simpleAlg
end
println("")
println("file name :")
saveFile = readline(stdin) * ".jld"
chromosomes = evolution!(popSize,iterationSteps , earlyStop, saveFile, alg)

include("saveVariables.jl")

