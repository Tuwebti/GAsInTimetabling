

abstract type MutateAlgorithm end
struct SEFMAlg <: MutateAlgorithm end #Stochastic Event freeing mutation
struct RandAlg <: MutateAlgorithm end
struct FullRandAlg <: MutateAlgorithm end
const SEFM = SEFMAlg()

#-------------------

function mutate!(scoredChr::ScoredChromosome, alg::MutateAlgorithm=SEFM)
    _mutate!(scoredChr, alg)
end
function _mutate!(scoredChr::ScoredChromosome, ::SEFMAlg)# Stochastic Event freeing mutation
    chr=scoredChr.chr
    key=rand(keys(chr))
    scoredChr.chr = sefm(chr,key)
    scoredChr.score = fitness(scoredChr.chr)
    return scoredChr
end
#randomly mutate 10% of chromosomes. of these, mutate half with SEFM and half randomly
function _mutate!(scoredChr, ::RandAlg)
    chr = scoredChr.chr
    for key in keys(chr)
        if rand() > 0.9
            if rand() > 0.5
                chr = sefm(chr,key)
            else
                chr[key].timePeriod=rand(1:timeslotamount)
            end
        end
    end
    scoredChr.score = fitness(scoredChr.chr)
end

function _mutate!(scoredChr, ::FullRandAlg)
    chr = scoredChr.chr
    key=rand(keys(chr))
    chr[key].timePeriod=rand(1:timeslotamount)
    scoredChr.score = fitness(scoredChr.chr)
end




function sefm(chr::Chromosome,key)
    maxTime= (0,0)
    for i in 1:timeslotamount
        chr[key].timePeriod=i
        newFitness=fitness(chr)
        if newFitness> maxTime[2]
            maxTime=(i, newFitness)
        end
    end
    chr[key].timePeriod=maxTime[1]
    return chr
end
#prioritise timeslots over rooms
function sefm(chr::Chromosome{WTutorialGene},key)
    push!(chr.availableRooms[chr[key].timePeriod] , chr[key].classroom)
    maxTime= (0,0)
    for i in 1:timeslotamount
        chr[key].timePeriod=i
        newFitness=fitness(chr)
        if newFitness> maxTime[2]
            maxTime=(i, newFitness)
        end
    end
    chr[key].timePeriod=maxTime[1]
    rooms = chr.availableRooms[maxTime[1]]
    if isempty(rooms)  #if their are no available rooms, proceed over all rooms
        rooms=keys(timetablingProblem.classrooms)
    end
    enoughSpace(room) = timetablingProblem.classrooms[room] >= eventSize[key]
    maxRoom = (0,0)
    for room in filter(x -> enoughSpace(x), rooms)
        chr[key].classroom=room
        newFitness = fitness(chr)
        if newFitness > maxRoom[2]
            maxRoom=(room, newFitness)
        end
    end
    chr[key].classroom=maxRoom[1]
    setdiff!(chr.availableRooms[chr[key].timePeriod] , [chr[key].classroom])
end



