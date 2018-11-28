# This module contains different possible Genetic algorithm flows


abstract type Algorithm end

#-------------

import Base.push! , Base.sort!
push!(chromosomes::Vector{ScoredChromosome{T}} , chr::Chromosome{T})  where {T} = sort!(push!(chromosomes, ScoredChromosome(chr , fitness(chr))))
# TODO check whether insertion sort is most effecient (most of array is already sorted)
#sort! sorts in reverse so that weakest member is outermost (so that culling is fast)
sort!(scoredChromosomes::ScoredChromosomes) = sort!(scoredChromosomes, by= x -> getfield(x , :score), alg=InsertionSort, rev=true)

#---------------

function evolution!(popSize::Int, iterationSteps, earlyStop, saveFile, iterateAlg)
    chromosomes=initializePop(popSize)
    return continueEvolution(chromosomes, iterationSteps, earlyStop, saveFile, iterateAlg)
end

#---------------

function continueEvolution(chromosomes, iterationSteps, earlyStop, saveFile, iterateAlg)
    iterateEvolution!(chromosomes, iterationSteps, earlyStop, saveFile, iterateAlg)
    endHook(chromosomes)
    return chromosomes
end

#---------------

#TODO make initialzePop generic
function initializePop(popSize::Int)
    if typeof(timetablingProblem) == SimpleTutorialTimetablingProblem
        chromosomes=_initializePopTutorial(popSize)
        beginHook(chromosomes)
        return chromosomes
    else
        error("timetablingProblem should be of type SimpleTutorialTimetablingProblem")
    end
end
function _initializePopTutorial(popSize)
    Chromosomes::ScoredChromosomes{SimpleTutorialGene}=[]
    for i in 1:popSize
        chr = Chromosome{SimpleTutorialGene}([])
        for e in timetablingProblem.events
            chr[e] = SimpleTutorialGene(rand(1:timeslotamount))
        end
        push!(Chromosomes,chr)
    end
    return Chromosomes
end

#---------------

abstract type EvolutionAlg <: Algorithm end
struct SimpleAlg <: EvolutionAlg end
const simpleAlg = SimpleAlg()


#TODO chang for loop to while and add an argument to specify an iteration condition
function iterateEvolution!(chromosomes, iterationSteps, earlyStop, saveFile, alg::EvolutionAlg = simpleAlg)
    _iterateEvolution!(chromosomes, iterationSteps, earlyStop, saveFile, alg)
end
function _iterateEvolution!(chromosomes,  iterationSteps, earlyStop, saveFile, ::SimpleAlg)
    for i in 1:iterationSteps
        if earlyStop
            if meanScore(chromosomes) > 0.98
                break
            end
        end
        selectCulling!(chromosomes, simple_select_culling_alg)
        selectMutation!(chromosomes, simple_select_mutation_alg)
        selectBreeding!(chromosomes, simple_select_breeding_alg)
        iterateHook(chromosomes, i, iterationSteps, saveFile)
    end
    return chromosomes
end

#--------------

abstract type Select_mutation_alg <: Algorithm end
struct Simple_select_mutation_alg <: Select_mutation_alg end
const simple_select_mutation_alg = Simple_select_mutation_alg()
function selectMutation!(scoredChromosomes , alg::Select_mutation_alg = simple_select_mutation_alg)
    _selectMutation!(scoredChromosomes, alg)
end
function _selectMutation!(scoredChromosomes,::Simple_select_mutation_alg)
    scoredChr=rand(scoredChromosomes)
    mutate!(scoredChr)
end

#---------------

abstract type Select_breeding_alg end
struct Simple_select_breeding_alg <: Select_breeding_alg end
const simple_select_breeding_alg = Simple_select_breeding_alg()

function selectBreeding!(scoredChromosomes, alg::Select_breeding_alg = simple_select_breeding_alg)
    _selectBreeding!(scoredChromosomes, alg)
end
function _selectBreeding!(scoredChromosomes, ::Simple_select_breeding_alg)
    function weightedRand(scoredChromosomes)
        scoredChromosomes[rand(1:div(length(scoredChromosomes), 2))]
    end
    chr=breed(weightedRand(scoredChromosomes).chr,weightedRand(scoredChromosomes).chr)
    push!(scoredChromosomes,chr)
end


#---------------

abstract type Select_culling_alg <: Algorithm end
struct Simple_select_culling_alg <: Select_culling_alg end
const simple_select_culling_alg = Simple_select_culling_alg()
function selectCulling!(chromosomes, alg::Select_culling_alg = simple_select_culling_alg)
    _selectCulling!(chromosomes, alg)
end

function _selectCulling!(chromosomes, ::Simple_select_culling_alg)
    pop!(chromosomes)
end


#default empty implementation for hooks
beginHook(_)= nothing
iterateHook(_,_,_)= nothing
endHook(_)= nothing
