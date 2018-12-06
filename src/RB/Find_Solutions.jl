#TODO use this to test for N iterations until it find a perfect solution
using Compat, Random, Distributions
lowestScoreTimetable = Dict{String,Set{Event}}()
highestScoreTimetable = Dict{String,Set{Event}}()
highestUnassigned = []
lowestUnassigned = []
minb = 100
maxb = 0
for i in 1:10
       data = copy(timetablingProblem.studentsByModule)
       (a,b) = DeterminsticMain(data,true)      #toggle true/false for soft constraints

       if length(b) < minb
               minb = length(b)
               lowestUnassigned = copy(b)
               lowestScoreTimetable = copy(a)
       end
       if length(b) > maxb
               maxb = length(b)
               highestUnassigned = copy(b)
               highestScoreTimetable = copy(a)
      end
      println("iteration: ",N)
 end
 return (highestScoreTimetable,highestUnassigned,lowestScoreTimetable,lowestUnassigned)
