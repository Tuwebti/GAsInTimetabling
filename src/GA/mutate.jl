

abstract type MutateAlgorithm end
struct SEFMAlg <: MutateAlgorithm end #Stochastic Event freeing mutation
const SEFM = SEFMAlg()

#-------------------

function mutate!(scoredChr::ScoredChromosome, alg::MutateAlgorithm=SEFM)
    _mutate!(scoredChr, alg)
end
function _mutate!(scoredChr::ScoredChromosome, ::SEFMAlg)# Stochastic Event freeing mutation
    chr=scoredChr.chr
    key=rand(keys(chr))
    maxTime= (0,0)
    for i in 1:timetablingProblem.timeslotAmount
        chr[key].timePeriod=i
        newFitness=fitness(chr)
        if newFitness> maxTime[2]
            maxTime=(i, newFitness)
        end
    end
    chr[key].timePeriod=maxTime[1]
    scoredChr.score=maxTime[2]
end
