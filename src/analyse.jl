# All the code used to analyse and display results should go here. This keeps the analysis seperate to from the execution. To access information during the computation, use hooks.
using Statistics
using Plots
abstract type BeginhookAlg <: Algorithm end
abstract type EndhookAlg <: Algorithm end
abstract type IteratehookAlg <: Algorithm end
struct CollectMeanScore <: IteratehookAlg end


abstract type AnalyseState end #a variable of type AnalyseState collects information during the execution in order to perform analysis at the end.
#-----------------
#Genetic

#beginHook is called just after the population of chromosomes is initialized

#iterateHook is called at each iteration of iterateEvolution!
iterateHook(chr::ScoredChromosomes,i::Int)=iterateHook(chr,i,iterate_hook_alg::IteratehookAlg)
function iterateHook(chrs::ScoredChromosomes,i::Int,::CollectMeanScore)
    push!(meanScores, meanScore(chrs))
end
meanScore(chrs::ScoredChromosomes) = Statistics.mean( map(chr -> chr.score , chrs) )

displayresults()=_displayresults(iterate_hook_alg)
function _displayresults(::CollectMeanScore)
    plot(meanScores, xlabel="iterations" , ylabel="score" , label="mean score")
end

# The following shows a heatmap of the constraints between events
function constraintHook(constraints::EdgeConstraints)
    events=["MTH1001","MTH1002","MTH1003","MTH1004","MTH2001","MTH2002","MTH2003","MTH2004"] #this is a temporary hack, need to make events into vector
    for i in 1:length(events)
        for j in 1:length(events)
            clashes[i,j]=constraints.edges[(events[i],events[j])]
        end
    end
end



