#TODO create an array for bipartite connections, make plots
#TODO implement rooms size constraint
#TODO count the number of students & modules assigned to not assigned
#TODO GRAPHS:
#(1) number of slots against no. of students assigned
#(2) bipartite connections

function DeterminsticMain()
    noSlots = 55
    slotsFree = zeros(noSlots)
    timeSlots = zeros(noSlots)
    studentsByModule = timetablingProblem.studentsByModule
    studentsByTimeslot = Dict{String,Set{Student}}()
    modulesByTimeslot = Dict{String,Set{Event}}()
    timeSlotAvailableTEMP = Dict{String,Set{Event}}()
    #Initialise timeslots
    for i in 1:noSlots
        timeslot = string(i)
        studentsByTimeslot[timeslot] = Set()
        modulesByTimeslot[timeslot] = Set()
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
                #add event to available timeslot
                #calculate soft constraint score here?
                union!(timeSlotAvailableTEMP[timeslot],[event])
            end
        end
        #Soft Constraints, searches through available timeslots and scores them
        #then chooses most preferrable timeSlot
        for availableSlot in sort(collect(keys(timeSlotAvailableTEMP)))
            if ! isempty(get(timeSlotAvailableTEMP,availableSlot,0))
                union!(modulesByTimeslot[availableSlot],[event])
                union!(studentsByTimeslot[availableSlot],studentsByModule[event])
                break
            end
        end
    end
    #print modulesByTimeslot in order, and counts modules and students
    noStudentsAssigned = 0
    noModulesAssigned = 0
    for key in map(x -> string(x),sort(map(x -> parse(Int, x), collect(keys(modulesByTimeslot)))))
        print("timeslot " * key * " : ")
        show(sort(collect(modulesByTimeslot[key])))
        #count the amount of students
        noModulesAssigned += length(get(modulesByTimeslot,key,0))
        #count the amount of modules
        noStudentsAssigned += length(get(studentsByTimeslot,key,0))
        println()
    end
    #count the amount of students & modules
end
