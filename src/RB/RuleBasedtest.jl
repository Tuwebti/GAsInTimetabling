#TODO find a way to order dictionaries linearly
#TODO using a variable timeslots, intialise dictionaries
#TODO create an array which tells you which slots are free for a given module
timeslotamount = 4
#D = Dict([("M3", ["1","4"]), ("M2", ["2","5"]), ("M1", ["3","4","5"])])
studentsByModule = timetablingProblem.studentsByModule
studentsByTimeslot = Dict{String,Set{Student}}()
modulesByTimeslot = Dict{String,Set{Event}}()
for i in 1:timeslotamount
    timeslot = string(i)
    studentsByTimeslot[timeslot] = Set()
    modulesByTimeslot[timeslot] = Set()
end

for event in keys(studentsByModule)
    #TODO implement Will's hierarchal algorithm for each iteration, basically
    #selects the module being considered in this iteration

    for timeslot in keys(studentsByTimeslot)
        #initialise inbedded variables for timeslot
        noclash = true
        if ! isempty(intersect(studentsByModule[event], studentsByTimeslot[timeslot]))
                noclash = false
        end
        if noclash
            #add the module to the timeslot
            #add the students of the module to the timeslot
            #print(modu1,"\n")
            #print(T,"\n")
            union!(modulesByTimeslot[timeslot],[event])
            union!(studentsByTimeslot[timeslot],studentsByModule[event])
            break
        end
    end
    #can place module modu1 in potential timeslots listed, soft constraints can be
    #applied here
end
#print modulesByTimeslot in order
for key in sort(collect(keys(modulesByTimeslot)))
    print("timeslot " * key * " : ")
    show(sort(collect(modulesByTimeslot[key])))
    println()
end

