#=
TODO For the moment once fitness is initialized, it uses the same algorithm (scoring function) for the whole iteration, being able to change fitness functions at various stages of the computation might be an interesting future direction
TODO getconstraints() needs to dispatch on the different possible constraints
=#

abstract type Constraint end

struct EdgeConstraints <: Constraint
    edges::Dict{Tuple{Event, Event},Int} #Here Int is equal to the number of clashes
end

#--------------

abstract type FitnessAlgorithm end
struct SimpleFitnessAlg <: FitnessAlgorithm end
struct GroupFitnessAlg <: FitnessAlgorithm end
const simpleFitnessAlg = SimpleFitnessAlg()
# The following enables us to construct a heatmap of the clashes
function constraintHook(constraints::EdgeConstraints)
    for i in 1:length(events)
        for j in 1:length(events)
            if haskey(constraints.edges,(events[i],events[j]))
                clashes[i,j]=constraints.edges[(events[i],events[j])]
            end
        end
    end
end

#TODO create different possible algorithms for fitness 
function initializeFitness(alg::FitnessAlgorithm = simpleFitnessAlg)
    constraints=getConstraints()
    constraintHook(constraints)
    return chr -> _fitness(chr,constraints,alg)
end
#Calculate 1/ (1+ num clashes) where num clashes is the total number of clashes.
function _fitness(chr::Chromosome{SimpleTutorialGene} , constraints::EdgeConstraints , ::SimpleFitnessAlg)
    return 1/ (1 + clashAmount(chr, constraints.edges))
end
function _fitness(chr::Chromosome{WTutorialGene}, constraints::EdgeConstraints, ::SimpleFitnessAlg)
    timeClashWeight=0.5
    roomClashWeight=0.5
    timeClashScore = 1/ (1 + clashAmount(chr, constraints.edges))
    roomClashScore = 1/ (1 + roomClashAmount(chr))
    return timeClashWeight * timeClashScore + roomClashWeight * roomClashScore
end

# If n students experience a module clash, then that counts as n clashes. here the factor 2 is because we count each pair twice (because a clash (a,b) is a clash (b,a))
function clashAmount(chr::Chromosome , edges)
    violations = 0
    for (e,clashes) in pairs(edges)
        if chr[e[1]].timePeriod == chr[e[2]].timePeriod
            violations += clashes
        end
    end
    return violations / 2
end
function roomClashAmount(chr::Chromosome)
    genes = values(chr)
    uniqueCombination=Set(map(x -> (x.timePeriod,x.classroom) ,genes))
    return length(genes) - length(uniqueCombination)
end



#-------------

function getConstraints()
    _getConstraints(timetablingProblem)
end
# record the number of clashes
function _getConstraints(problem::TimetablingProblem)
    constraints = EdgeConstraints(Dict())
    for events in values(problem.studentEnrollement)
        for clash in findPairs(events)
            haskey(constraints.edges,clash) ? constraints.edges[clash]+=1 : constraints.edges[clash] = 1
        end
    end
    # add the clashes (a,b) and (b,a)
    for (a,b) in keys(constraints.edges)
        if !haskey(constraints.edges,(b,a))
            constraints.edges[(b,a)]=0
        end
    end
    transpose=Dict()
    for ((a,b),i) in pairs(constraints.edges)
        transpose[(b,a)] = i
    end
    for (a,b) in keys(constraints.edges)
        constraints.edges[(a,b)]+=transpose[(a,b)]
    end
    return constraints
end
function findPairs(oldEvents::Set{Event})
    events = copy(oldEvents)
    pairs = Set()
    for e1 in events
        for e2 in setdiff!(events,[e1])
            union!(pairs,[(e1,e2)])
        end
    end
    return pairs
end

#------------

const fitness = initializeFitness()

#------------
