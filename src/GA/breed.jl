

abstract type BreedAlg end #used to represent what algorithm is used to breed Chromosomes
struct UniformCrossoverAlg <: BreedAlg end
const UniformCrossover = UniformCrossoverAlg()

#-------------------

function breed(chr1::Chromosome,chr2::Chromosome, alg::BreedAlg=UniformCrossover)#implements uniform crossover
    _breed(chr1 , chr2 , alg)
end
function _breed(chr1::Chromosome{SimpleTutorialGene}, chr2::Chromosome{SimpleTutorialGene}, ::UniformCrossoverAlg)
    return breedWithFieldNameNumber(chr1,chr2,1)
end
function _breed(chr1::Chromosome{WTutorialGene},chr2::Chromosome{WTutorialGene},::UniformCrossoverAlg)
    return breedWithFieldNameNumber(chr1,chr2,2)
end

function breedWithFieldNameNumber(chr1::Chromosome, chr2::Chromosome, l::Int)
    selectedFromFirst=[rand(Bool,l) for i in 1:length(keys(chr1))]
    child=deepcopy(chr1)
    for (i,key) in enumerate(keys(chr1))
        for j in 1:l
            fieldValue = selectedFromFirst[i][j] ? getfield(chr1[key],j) : getfield(chr2[key],j)
            setfield!(child[key],j, fieldValue)
        end
    end
    resetAvailableRooms!(child)
    return child
end
