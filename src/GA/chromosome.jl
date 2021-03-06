#= ChromosomeModule : This module defines genes and Chromosomes and overloads common operators to make their interface consistent and simple =#

#=
module ChromosomeModule
using TimetablingProblemModule
export Chromosome, EventBasedGene, Gene, TutorialGene, ScoredChromosome, ScoredChromosomes
=#
import Base.getindex , Base.setindex! , Base.keys , Base.haskey , Base.get , Base.get! , Base.getkey , Base.delete! , Base.pop! , Base.values , Base.pairs

abstract type Gene end


abstract type EventBasedGene <: Gene end #a gene represents an event


mutable struct TutorialGene <: EventBasedGene   #represents Wednesday morning tutorials
    timePeriod::Timeperiod
    classroom::Classroom
    lecturer::Lecturer
end
TutorialGene(timeperiod)=TutorialGene(timeperiod, "noClassroom", "noLecturer")
mutable struct WTutorialGene <: EventBasedGene
    timePeriod::Timeperiod
    classroom::Classroom
end
mutable struct SimpleTutorialGene <: EventBasedGene
    timePeriod::Timeperiod
end


struct Chromosome{V <: Gene}
    chromosome::Dict{Event,V}
    availableRooms::Dict{Timeperiod,Set{Classroom}}
    Chromosome{V}(itr) where V =new(Dict(itr))
    Chromosome{WTutorialGene}(itr,dict) = new(Dict(itr),dict)
end
Chromosome{WTutorialGene}(itr) = new(Dict(itr),allAvailableRooms!(Dict()))
#resets the the available rooms so that all rooms are available
function allAvailableRooms!(availableRooms)
    classrooms = Set(keys(timetablingProblem.classrooms))
    for timeslot in 1:timeslotamount
        availableRooms[timeslot]=copy(classrooms)
    end
    return availableRooms
end
function resetAvailableRooms!(chr::Chromosome{WTutorialGene})
    allAvailableRooms!(chr.availableRooms)
    for gene in values(chr)
        setdiff!(chr.availableRooms[gene.timePeriod],[gene.classroom])
    end
end
resetAvailableRooms!(chr::Chromosome) = nothing
#overload functions to make Chromosome appear as a Dict (might be possible to avoid with macros)
getindex(chr::Chromosome,i)= chr.chromosome[i]
setindex!(chr::Chromosome, val, key)= chr.chromosome[key] = val
keys(chr::Chromosome) = keys(chr.chromosome)
haskey(chr::Chromosome, key) = haskey(chr.chromosome, key)
get(chr::Chromosome, key, default) = get(chr.chromosome, key, default)
get!(chr::Chromosome, key, default) = get!(chr.chromosome, key, default)
getkey(chr::Chromosome, key, default) = getkey(chr.chromosome, key, default)
delete!(chr::Chromosome, key) = delete!(chr.chromosome, key)
pop!(chr::Chromosome, key) = pop!(chr.chromosome, key)
values(chr::Chromosome) = values(chr.chromosome)
pairs(chr::Chromosome) = pairs(chr.chromosome)


mutable struct ScoredChromosome{V}
    chr::Chromosome{V}
    score::Real
end
ScoredChromosomes{T} = Vector{ScoredChromosome{T}}
meanScore(chrs::ScoredChromosomes) = Statistics.mean( map(chr -> chr.score , chrs) )
