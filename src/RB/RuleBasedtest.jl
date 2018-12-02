function DeterminsticMain(studentsByModule)
    #Initial variables
    rooms = copy(timetablingProblem.classrooms)
    modulesAllAssigned = false
    roomAvailable = false
    noSlots = timeslotamount
    slotsFree = zeros(noSlots)
    timeSlots = zeros(noSlots)
    studentsByTimeslot = Dict{String,Set{Student}}()
    modulesByTimeslot = Dict{String,Set{Event}}()
    timeSlotAvailableTEMP = Dict{String,Set{Event}}()
    availableRooms = Dict{String,Array{Int16,1}}()
    roomAvailability = Dict{String,Array{Int16,1}}()
    unassignedModules = []
    lengthOfKeys = length(collect(keys(studentsByModule)))

    #Initialise timeslots & roomslots
        for i in 1:noSlots
            timeslot = string(i)
            roomAvailability[timeslot] = collect(values(rooms))
            studentsByTimeslot[timeslot] = Set()
            modulesByTimeslot[timeslot] = Set()
        end
    #ASSIGN MODULES INTO TIMESLOTS
    while !modulesAllAssigned
        #Display Progress
        currentLength = length(collect(keys(studentsByModule)))
        println(round(sqrt((lengthOfKeys-currentLength)/lengthOfKeys)*100),"% Progress")
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
            availableRoomsSLOT = string(i)
            availableRooms[availableRoomsSLOT] = []
        end
        #Initialise roomslots available for each iterates
        #Iterate through timeslots
        foundSlot = false
        for timeslot in map(x -> string(x),sort(map(x -> parse(Int, x), collect(keys(modulesByTimeslot)))))
            #MODULE CLASH CONSTRAINT
            if isempty(intersect(studentsByModule[event], studentsByTimeslot[timeslot]))
                #ROOM CONSTRAINT
                roomAvailable = false
                for room in roomAvailability[timeslot]
                    if room >= length(collect(studentsByModule[event]))
                        append!(availableRooms[timeslot],room)
                        roomAvailable = true
                    end
                end
                #at end of loop we assign module to smallest room
                if roomAvailable == true
                    union!(timeSlotAvailableTEMP[timeslot],[event])
                    foundSlot = true
                end
                #SOFT CONSTRAINT SCORE HERE
            end
        end
        #Condtion for Unassigned Modules
        if !foundSlot
            push!(unassignedModules,event)
        else
            #SOFT CONSTRAINTS APPLIED
            mostMinRoomSize = maximum(collect(values(rooms)))+1
            minSizeTimeslot = ""
            for timeslot in map(x -> string(x),sort(map(x -> parse(Int, x), collect(keys(timeSlotAvailableTEMP)))))
                if ! isempty(get(timeSlotAvailableTEMP,timeslot,0))
                    #For now we just take first available slot, this is optimal
                    mostMinRoomSize = minimum(availableRooms[timeslot])
                    minSizeTimeslot = timeslot
                    break
                    #Soft constraints replace soft room constraints in here
                    if minimum(availableRooms[timeslot])  < mostMinRoomSize
                        mostMinRoomSize = minimum(availableRooms[timeslot])
                        minSizeTimeslot = timeslot
                    end
                end
            end
            #ASSIGN MODULE HERE
            deleteat!(roomAvailability[minSizeTimeslot],findfirst(x->x==mostMinRoomSize,roomAvailability[minSizeTimeslot]))
            union!(modulesByTimeslot[minSizeTimeslot],[event])
            union!(studentsByTimeslot[minSizeTimeslot],studentsByModule[event])
        end
        #REMOVE MODULE HERE
        delete!(studentsByModule,event)
    end     #TIMETABLE PRODUCED

    #DISPLAY TIMETABLE
    for key in map(x -> string(x),sort(map(x -> parse(Int, x), collect(keys(modulesByTimeslot)))))
        print("timeslot " * key * " : ")
        show(sort(collect(modulesByTimeslot[key])))
        println()
    end

    #DISPLAY UNASSIGNED MODULES
    println("Number of Modules Unassigned: ",length(unassignedModules))
    #Returns pair of Modules by timeslot and unassigend Modules
    return (modulesByTimeslot,unassignedModules)
end

#TODO use this to test multiple iterations until it find a perfect solution
#while true
#       data = copy(timetablingProblem.studentsByModule)
#       (a,b) = DeterminsticMain(data)
#       if length(b) == 0
#       print(a)
#       break
#       end
#      end
