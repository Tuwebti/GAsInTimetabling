data = copy(timetablingProblem.studentsByModule)

(a,b,c) = @time DeterminsticMain(data,false)

minb = 100
maxb = 0
for i=1:20
   data = copy(timetablingProblem.studentsByModule)
   (a,b,c) = DeterminsticMain(data,true)
if length(b) < minb
           minb = length(b)
           lowestUnassigned = copy(b)
           lowestScoreTimetable = copy(a)
end
data = copy(timetablingProblem.studentsByModule)
if length(b) > maxb
            maxb = length(b)
            highestUnassigned = copy(b)
            highestScoreTimetable = copy(a)
   end
end
