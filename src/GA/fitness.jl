#=
TODO For the moment once fitness is initialized, it uses the same algorithm (scoring function) for the whole iteration, being able to change fitness functions at various stages of the computation might be an interesting future direction
TODO getconstraints() needs to dispatch on the different possible constraints
=#

abstract type Constraint end

struct EdgeConstraints <: Constraint
    edges::Set{Tuple{Event, Event}}
end

#--------------

abstract type FitnessAlgorithm end
struct SimpleFitnessAlg <: FitnessAlgorithm end
const simpleFitnessAlg = SimpleFitnessAlg()

#TODO create different possible algorithms for fitness 
function initializeFitness(alg::FitnessAlgorithm = simpleFitnessAlg)
    constraints=getConstraints()
    return chr -> _fitness(chr,constraints,alg)
end

function _fitness(chr::Chromosome{SimpleTutorialGene} , constraints::EdgeConstraints , ::SimpleFitnessAlg)
    violations = 1
    for e in constraints.edges
        if chr[e[1]].timePeriod == chr[e[2]].timePeriod
            violations += 1
        end
    end
    return 1/violations
end

#-------------

function getConstraints()
    timetablingProblem = timetableImport(importMode)
    _getConstraints(timetablingProblem)
end
function _getConstraints(problem::SimpleTutorialTimetablingProblem)
    constraints = EdgeConstraints(Set())
    for events in values(problem.studentEnrollement)
        union!(constraints.edges , findPairs(events))
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
