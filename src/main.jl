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
end


# execution
evolution!()

# Data display
displayresults()
