# All the code used to analyse and display results should go here. This keeps the analysis seperate to from the execution. To access information during the computation, use hooks.
using Statistics
abstract type BeginhookAlg <: Algorithm end
abstract type EndhookAlg <: Algorithm end
abstract type IteratehookAlg <: Algorithm end
struct CollectMeanScore <: IteratehookAlg end

abstract type AnalyseState end #a variable of type AnalyseState collects information during the execution in order to perform analysis at the end.
#-----------------
#Genetic

#beginHook is called just after the population of chromosomes is initialized

#iterateHook is called at each iteration of iterateEvolution!
iterateHook(chr::ScoredChromosomes,i::Int, iterationSteps::Int,saveFile)=iterateHook(chr,i,iterationSteps,saveFile, iterate_hook_alg::IteratehookAlg)
function iterateHook(chrs::ScoredChromosomes,i::Int,iterationSteps,saveFile,::CollectMeanScore)
    push!(meanScores, meanScore(chrs))
    if i%100==0
        println(string((i/iterationSteps)*100) * "% complete")
        save(joinpath("saved-variables",saveFile),"chromosomes",chrs,"meanScores",meanScores)
    end
end


