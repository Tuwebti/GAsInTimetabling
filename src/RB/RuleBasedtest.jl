#TODO create an array for bipartite connections, make plots
#TODO implement rooms size constraint
#TODO implement a clique/degree strategy? Then retimetable those modules
#TODO GRAPHS:
#(1) number of slots against no. of students assigned
#(2) bipartite connections

function DeterminsticMain()
    noSlots = timeslotamount
    slotsFree = zeros(noSlots)
    timeSlots = zeros(noSlots)
    studentsByModule = timetablingProblem.studentsByModule
    studentsByTimeslot = Dict{String,Set{Student}}()
    modulesByTimeslot = Dict{String,Set{Event}}()
    timeSlotAvailableTEMP = Dict{String,Set{Event}}()
    roomAvailability = Dict{String,Set{Event}}()
    #Initialise timeslots
    for i in 1:noSlots
        timeslot = string(i)
        studentsByTimeslot[timeslot] = Set()
        modulesByTimeslot[timeslot] = Set()
        #roomAvailability[timeslot] = =Set()
    end

    for event in keys(studentsByModule)
        #TODO implement Will's hierarchal algorithm for each iteration, basically
        #selects the module being considered in this iteration
        #Initialise timeslots available for current event
        for i in 1:noSlots
            timeslot = string(i)
            timeSlotAvailableTEMP[timeslot] = Set()
        end
        #Iterate through timeslots
        for timeslot in sort(collect(keys(studentsByTimeslot)))
            if  ! isempty(intersect(studentsByModule[event], studentsByTimeslot[timeslot]))
                #we have a clash
            else
                #roomChecker = Array{Int64}
                #for roomSize in get(roomAvailability,timeslot,0)
                    #check if room size is available for module
                    #if false
                        #here we assign the room as possible
                    #    append(roomChecker, roomSize)
                    #end
                #end
                #at end of loop we assign module to smallest room

                #add event to available timeslot
                union!(timeSlotAvailableTEMP[timeslot],[event])
                #SOFT CONSTRAINT HERE
            end
        end
        #Soft Constraints FIX
        for availableSlot in sort(collect(keys(timeSlotAvailableTEMP)))
            if ! isempty(get(timeSlotAvailableTEMP,availableSlot,0))
                union!(modulesByTimeslot[availableSlot],[event])
                union!(studentsByTimeslot[availableSlot],studentsByModule[event])
                break
            end
        end
    end
    #print modulesByTimeslot in order, and counts modules
    noModulesAssigned = 0
    for key in map(x -> string(x),sort(map(x -> parse(Int, x), collect(keys(modulesByTimeslot)))))
        print("timeslot " * key * " : ")
        show(sort(collect(modulesByTimeslot[key])))
        #count the amount of students
        noModulesAssigned += length(get(modulesByTimeslot,key,0))
        #count the amount of modules
        println()
    end
    #print the amount of modules unassigned for dataset 1
    noModulesUnassigned = 400-noModulesAssigned
    println("Number of Modules Unassigned: ",noModulesUnassigned)
    return modulesByTimeslot
end
