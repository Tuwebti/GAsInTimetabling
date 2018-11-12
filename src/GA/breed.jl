

abstract type BreedAlg end #used to represent what algorithm is used to breed Chromosomes
struct UniformCrossoverAlg <: BreedAlg end
const UniformCrossover = UniformCrossoverAlg()

#-------------------

function breed(chr1::Chromosome,chr2::Chromosome, alg::BreedAlg=UniformCrossover)#implements uniform crossover
    _breed(chr1 , chr2 , alg)
end
function _breed(chr1::Chromosome, chr2::Chromosome, ::UniformCrossoverAlg)
    selectedFromSecond=filter(x -> rand(Bool), keys(chr2))
    child=deepcopy(chr1)
    for key in selectedFromSecond
        child[key]=chr2[key]
    end
    return child
end
