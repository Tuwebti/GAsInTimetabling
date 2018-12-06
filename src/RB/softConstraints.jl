function softConstraints(studentsByTimeslot,studentsByModule,event,timeslot)
    timeslots = timeslotamount
    softConstraintScore = 3   #average
    noOfWeights = 1
    #Avoiding early starts, we consider early starts and late finishes to be
    earlyDist = 3.06383
    if parse(Int,timeslot) <= round(timeslots/5)    #definition for EARLY FINISH
        #Weight early finish score
        softConstraintScore += earlyDist
        noOfWeights +=1
    end

    #Avoiding late finishes
    lateDist = 3.085106
    if parse(Int,timeslot) >= floor((4*timeslots)/5)    #definition for LATE FINISH
        #Weight late finish score
        softConstraintScore += lateDist
        noOfWeights +=1
    end

    #Avoiding consecutive modules
    consecutiveDist = 2.255319
    consecutiveScore = 1
    #timeslot before current one
    if timeslot != "1"
        timeslotBelow = string(parse(Int,timeslot)-1)
            for students in studentsByModule[event]
                if students in studentsByTimeslot[timeslotBelow]
                    consecutiveScore += 1
                end
            end
    end
    #timeslot after current one
    if timeslot != string(timeslots)
        timeslotAbove = string(parse(Int,timeslot)+1)
        for students in studentsByModule[event]
            if students in studentsByTimeslot[timeslotAbove]
                consecutiveScore += 1
            end
        end
    end
    #Weight consecutive score
    softConstraintScore += (consecutiveDist)*(consecutiveScore/length(collect(values(studentsByModule[event]))))
    noOfWeights += consecutiveScore/length(collect(values(studentsByModule[event])))

    #Avoiding large gaps
    largeGap = timeslots/2  #definition for LARGE GAPS
    gapDist = 2.978723
    gapScore = 0
    for students in studentsByModule[event]
        for slot in keys(studentsByTimeslot)
        if students in studentsByTimeslot[timeslot]
            if abs(parse(Int,slot)-parse(Int,timeslot)) >= gapDist
                gapScore += 1
            end
        end
    end
end
#Weight large gaps
softConstraintScore += (gapDist)*(gapScore/length(collect(values(studentsByModule[event]))))
noOfWeights += gapScore/length(collect(values(studentsByModule[event])))

#Final average calculation
softConstraintScore = softConstraintScore/noOfWeights
return softConstraintScore
end
