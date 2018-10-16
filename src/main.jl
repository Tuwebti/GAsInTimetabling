import Base.push!
import Base.sort!
abstract type Gene end
mutable struct SimpleGene <: Gene
    timePeriod::Int
    classroom::Int
end
const Event = String
const Chromosome = Dict{Event,V} where V <: Gene
mutable struct ScoredChromosome
    chr::Chromosome
    score::Real
end

const ScoredChromosomes = Vector{ScoredChromosome}
const Events = Vector{String}
const EdgeConstraint = Tuple{Event, Event}
const EdgeConstraints = Vector{EdgeConstraint}
s=SimpleGene
const timePeriodNumber=3
function fitness(chr::Chromosome)
    testConstraints::EdgeConstraints= [("ECM1","ECM2"),("ECM2","ECM5"),("ECM1","ECM5"),("ECM3","ECM2"),("ECM3","ECM4"),("ECM4","ECM5")]
    constraints=testConstraints
    fitness1(chr,constraints)
end
function fitness1(chr::Chromosome{SimpleGene},constraints::EdgeConstraints)
    violations = 1
    for e in constraints
        if chr[e[1]].timePeriod == chr[e[2]].timePeriod
            violations += 1
        end
    end
    return 1/violations
end
push!(chromosomes::ScoredChromosomes , chr::Chromosome) = sort!(push!(chromosomes, ScoredChromosome(chr , fitness(chr))))
sort!(scoredChromosomes::ScoredChromosomes) = sort!(scoredChromosomes, by= x -> getfield(x , :score), alg=InsertionSort, rev=true) #check whether insertion sort is most effecient (most of array is already sorted), sorted in reverse so that weakest member is outermost (so that culling is fast)

function generateChr(events::Vector{Event},timeperiods::Int,numberToGenerate::Int=5)
    Chromosomes::ScoredChromosomes=[]
    for i in 1:numberToGenerate
        chr::Chromosome{SimpleGene} = Dict()
        for e in events
            chr[e] = SimpleGene(rand(1:timeperiods) ,0)
        end
        push!(Chromosomes,chr)
    end
    return Chromosomes
end

function main()
    events=["ECM1","ECM2","ECM3","ECM4","ECM5"]
    chromosomes = generateChr(events, 3, 2)
    return chromosomes
end
function iterateEvolution!(chromosomes)
    for i in 1:300
        selectCulling!(chromosomes)
        selectMutation!(chromosomes)
        selectBreeding!(chromosomes)
    end
end
function main2()
    events=["ECM1","ECM2","ECM3","ECM4","ECM5"]
    chromosomes = generateChr(events, timePeriodNumber, 10)
    iterateEvolution!(chromosomes)
    chromosomes
end

function selectMutation!(scoredChromosomes)
    scoredChr=rand(scoredChromosomes)
    mutate!(scoredChr)
end
function selectBreeding!(scoredChromosomes)
    chr=breed(weightedRand(scoredChromosomes).chr,weightedRand(scoredChromosomes).chr)
    push!(scoredChromosomes,chr)
end
function selectCulling!(chromosomes)
    pop!(chromosomes)
end
function weightedRand(scoredChromosomes)
    scoredChromosomes[rand(1:div(length(scoredChromosomes), 2))]
end
function testBreed()
    events=["ECM1","ECM2","ECM3","ECM4","ECM5"]
    testConstraints::EdgeConstraints= [("ECM1","ECM2"),("ECM2","ECM5"),("ECM1","ECM5"),("ECM3","ECM2"),("ECM3","ECM4"),("ECM4","ECM5")]
    chromosomes = generateChr(events, 3,2)
    push!(chromosomes,breed(chromosomes[1].chr,chromosomes[2].chr))
    chromosomes
end


function mutate!(scoredChr::ScoredChromosome)# Stochastic Event freeing mutation
    chr=scoredChr.chr
    key=rand(keys(chr))
    maxTime= (0,0)
    for i in 1:timePeriodNumber
        chr[key].timePeriod=i
        newFitness=fitness(chr)
        if newFitness> maxTime[2]
            maxTime=(i, newFitness)
        end
    end
    chr[key].timePeriod=maxTime[1]
    scoredChr.score=maxTime[2]
end

function breed(chr1::Chromosome{SimpleGene},chr2::Chromosome{SimpleGene})#implements uniform crossover
    selectedFromSecond=filter(x -> rand(Bool), keys(chr2))
    child=copy(chr1)
    for key in selectedFromSecond
        child[key]=chr2[key]
    end
    return child
end




