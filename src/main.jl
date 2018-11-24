# global variables for data collection and processing
meanScores=[]
iterate_hook_alg=CollectMeanScore()

# global variables for which algorithms to use
if choice == "1"
    timeslotamount=3
elseif choice == "2"
    timeslotamount=3
elseif choice == "3"
    timeslotamount=45
    chromosomes = evolution!(30,20000,true)
end


# execution


# Data display
displayresults()
