#TODO show perfect solution for dataset 1 both tried with & without soft constraints for 20 runs
#TODO try find a dataset which  obtains a perfect solution for soft constraints
using Compat, Random, Distributions
#Run clique on dataset 2, removal of 50 modules
a2 = []
(a1,a2,b,c) - cliqueStrategy()

#Best and Worst  for dataset 2, WITHOUT soft constraint, 20 runs
(d,e,f,g) = find_solutions(20,false)
#Best and Worst for dataset 2, WITH soft constraints, 20 runs
(h,i,j,k) = find_solutions(20,true)
