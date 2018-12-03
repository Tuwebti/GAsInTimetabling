#TODO use this to test for N iterations until it find a perfect solution
function find_solutions(N,soft)
lowestScoreTimetable = Dict{String,Set{Event}}()
highestScoreTimetable = Dict{String,Set{Event}}()
minb = 100
maxb = 0
for i in 1:N
       data = copy(timetablingProblem.studentsByModule)
       (a,b) = DeterminsticMain(data,soft)      #toggle true/false for soft constraints

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
 end
 return (highestScoreTimetable,highestUnassigned,lowestScoreTimetable,lowestUnassigned)
end
