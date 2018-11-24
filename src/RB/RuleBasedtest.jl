#TODO find a way to order dictionaries linearly
#TODO using a variable timeslots, intialise dictionaries
#TODO create an array which tells you which slots are free for a given module
noSlots = 4
slotsFree = zeros(noSlots)
timeSlots = zeros(noSlots)
#D = Dict([("M3", ["1","4"]), ("M2", ["2","5"]), ("M1", ["3","4","5"])])
D = timetablingProblem.studentsByModule
timtST = Dict{String,Array{String,1}}("Tc" => [],"Tb"=>[],"Ta"=>[],"Tl"=>[])
timtM = Dict{String,Array{String,1}}("Tc" => [],"Tb"=>[],"Ta"=>[],"Tl"=>[])
#counts down letters and numbers
for modu1 in keys(D)
    #TODO implement Will's hierarchal algorithm for each iteration, basically
    #selects the module being considered in this iteration

    #slotsFree finds the possible slots available for module modu1
    slotsFree = Dict{String,Array{String}}("Tc" => [],"Tb"=>[],"Ta"=>[])
    for T in keys(timtST)
        #initialise inbedded variables for Timeslot T
        noclash = 1
        for k in get(D,modu1,0)
            if k in get(timtST,T,0)
                #here we have: 1 student (k) shares the same timeslot T for a
                #different module (!= modu1)
                noclash = 0
                break
                #BREAK to next timeslot
            end
        end
        if noclash == 1
            #assign timeslot T, module modu1
            #Places module modu1 into first possible timeslot T
            #print(modu1,"\n")
            #print(T,"\n")
            timtST[T] = append!(timtST[T],get(D,modu1,0))
            timtM[T] = append!(timtM[T],[modu1])
            break
        end
    end
    #can place module modu1 in potential timeslots listed, soft constraints can be
    #applied here
end
#print(timtST,"\n")
print(timtM)
