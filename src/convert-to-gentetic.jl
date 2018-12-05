function convertToChromosome(modulesByTimeslot,roomAvailability)
    timeslotByModule = Dict()
    chromosome = Chromosome{WTutorialGene}([],convertRoomFormat(roomAvailability))
    assignedRooms = Dict{Timeperiod,Set{Classroom}}()
    for timeslot in keys(chromosome.availableRooms)
        assignedRooms[timeslot]=Set()
    end
    allAvailableRooms = allAvailableRooms!(Dict())
    reservedRooms = Dict()
    for key in keys(allAvailableRooms)
        reservedRooms[key] = setdiff(allAvailableRooms[key],chromosome.availableRooms[key])
    end
    for (timeslotkey,events) in pairs(modulesByTimeslot)
        for event in events
            timeslot= parse(Int,timeslotkey)
            possibleRoomsTimeslot= filter(room -> timetablingProblem.classrooms[room] >= eventSize[event] , reservedRooms[timeslot])
            setdiff!(possibleRoomsTimeslot,assignedRooms[timeslot])
            roomsWithSizes = map(room -> (room, timetablingProblem.classrooms[room]), collect(possibleRoomsTimeslot))
            getMinSize((roomA,roomSizeA),(roomB,roomSizeB)) = roomSizeA < roomSizeB ? (roomA,roomSizeA) : (roomB,roomSizeB)
            choosenRoom = reduce(getMinSize , roomsWithSizes)[1]
            gene = WTutorialGene(timeslot,choosenRoom)
            push!(assignedRooms[timeslot],choosenRoom)
            if haskey(timeslotByModule,event)
                error("There should only be one timeslot per module")
            else
                chromosome[event]= gene
            end
        end
    end
    return chromosome
end

function 
# deterministic uses a Dict( timeslot => array{Roomsize}) with timeslot as a string, whilst Genetic uses Dict( timeslot => Set(Room)) where timeslot is an Int, the following converts from Deterministic to genetic
#following converst keys to int
function convertRoomFormat(roomAvailability)
    intRoomAvailability=Dict{Timeperiod,Vector{Int16}}()
    for timeperiod in keys(roomAvailability)
        t = parse(Int,timeperiod)
        intRoomAvailability[t] = roomAvailability[timeperiod]
    end
    #following creates reverse lookup from classroomsize to classroomnumber
    sizetoclassrooms = Dict{Int,Vector{Classroom}}()
    for (classroom,size) in pairs(timetablingProblem.classrooms)
        if !haskey(sizetoclassrooms,size)
            sizetoclassrooms[size] = [classroom]
        else
            push!(sizetoclassrooms[size],classroom)
        end
    end
    # availableRooms stores the final conversion
    availableRooms=Dict()
    for i in 1:timeslotamount
        availableRooms[i]=Set()
    end
    for (timeperiod,sizes) in pairs(intRoomAvailability)
        for size in sizes
            classrooms = sizetoclassrooms[size]
            for classroom in classrooms
                if classroom ∈ availableRooms[timeperiod]
                    continue
                else
                    push!(availableRooms[timeperiod],classroom)
                    break
                end
            end
        end
    end
    return availableRooms
end


