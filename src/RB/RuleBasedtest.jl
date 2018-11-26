#TODO create an array which tells you which slots are free for a given module
#TODO create an array for bipartite connections, make plots
#TODO implement rooms size constraint
#TODO GRAPHS:
#(1) number of slots against no. of students assigned
#(2) bipartite connections

noSlots = 4
slotsFree = zeros(noSlots)
timeSlots = zeros(noSlots)
#D = Dict([("M3", ["1","4"]), ("M2", ["2","5"]), ("M1", ["3","4","5"])])
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
    for timeslot in keys(studentsByTimeslot)
        if  ! isempty(intersect(studentsByModule[event], studentsByTimeslot[timeslot]))
            #we have a clash
        else
            #add event to available timeslot
            #calculate soft constraint score here
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
#print modulesByTimeslot in order
for key in sort(collect(keys(modulesByTimeslot)))
    print("timeslot " * key * " : ")
    show(sort(collect(modulesByTimeslot[key])))
    println()
end
