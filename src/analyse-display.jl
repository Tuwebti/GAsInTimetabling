

displayresults()=_displayresults(iterate_hook_alg)
function _displayresults(::CollectMeanScore)
    plot(meanScores, xlabel="iterations" , ylabel="score" , label="mean score")
    png(joinpath("output","evolution_of_mean_score"))
end
