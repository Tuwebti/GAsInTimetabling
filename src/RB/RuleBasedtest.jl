function DeterminsticMain(studentsByModule)
    #TODO implement rooms size constraint

    #Initial variables
    modulesAllAssigned = false
    noSlots = timeslotamount
    slotsFree = zeros(noSlots)
    timeSlots = zeros(noSlots)
    studentsByTimeslot = Dict{String,Set{Student}}()
    modulesByTimeslot = Dict{String,Set{Event}}()
    timeSlotAvailableTEMP = Dict{String,Set{Event}}()
    roomAvailability = Dict{String,Set{Event}}()
    unassignedModules = []
    lengthOfKeys = length(collect(keys(studentsByModule)))
    #Initialise timeslots
    for i in 1:noSlots
        timeslot = string(i)
        studentsByTimeslot[timeslot] = Set()
        modulesByTimeslot[timeslot] = Set()
        #roomAvailability[timeslot] = =Set()
    end
    #ASSIGN MODULES INTO TIMESLOTS
    while !modulesAllAssigned
        #Display Progress
        currentLength = length(collect(keys(studentsByModule)))
        println(((lengthOfKeys-currentLength)/lengthOfKeys)*100,"% Progress")
        #signif(73489, 3)?
        #Check if no more modules need to be assigned
        if length(collect(keys(studentsByModule))) <= 1
            #End cases, just selects last event
            modulesAllAssigned = true
            event = collect(keys(studentsByModule))[1]
        else
            #Select most constrained module For ActualEvent
            event = mostConstrainedModule(studentsByModule)
        end
        #Initialise timeslots available for each iterate
        for i in 1:noSlots
            timeslot = string(i)
            timeSlotAvailableTEMP[timeslot] = Set()
        end
        #Iterate through timeslots
        foundSlot = false
        for timeslot in map(x -> string(x),sort(map(x -> parse(Int, x), collect(keys(modulesByTimeslot)))))
            if isempty(intersect(studentsByModule[event], studentsByTimeslot[timeslot]))
                #ROOM CONSTRAINT
                #roomChecker = Array{Int64}
                #for roomSize in get(roomAvailability,timeslot,0)
                    #check if room size is available for module
                    #if false
                        #here we assign the room as possible
                    #    append(roomChecker, roomSize)
                    #end
                #end
                #at end of loop we assign module to smallest room

                #MODULE CLASH CONSTRAINT
                union!(timeSlotAvailableTEMP[timeslot],[event])
                foundSlot = true
                #SOFT CONSTRAINT SCORE HERE
            end
        end
        #Condtion for Unassigned Modules
        if !foundSlot
            push!(unassignedModules,event)
        end
        #SOFT CONSTRAINTS APPLIED
        for availableSlot in sort(collect(keys(timeSlotAvailableTEMP)))
            if ! isempty(get(timeSlotAvailableTEMP,availableSlot,0))
                union!(modulesByTimeslot[availableSlot],[event])
                union!(studentsByTimeslot[availableSlot],studentsByModule[event])
                break
            end
        end

        #REMOVE MODULE HERE
        delete!(studentsByModule,event)
    end     #TIMETABLE PRODUCED

    #DISPLAY TIMETABLE
    for key in map(x -> string(x),sort(map(x -> parse(Int, x), collect(keys(modulesByTimeslot)))))
        #print("timeslot " * key * " : ")
        #show(sort(collect(modulesByTimeslot[key])))
        #println()
    end

    #DISPLAY UNASSIGNED MODULES
    println("Number of Modules Unassigned: ",length(unassignedModules))

    #Returns pair of Modules by timeslot and unassigend Modules
    return (modulesByTimeslot,unassignedModules)
end
