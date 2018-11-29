function mostConstrainedModule(studentsByModuleHier)
    mostConstrainedModule = ""
    mostConstrainedModuleNo = 0
    for moduleCompare in keys(studentsByModuleHier)
        constraintScore = 0
        for moduleClash in keys(studentsByModuleHier)
            if moduleCompare != moduleClash
                if ! isempty(intersect(studentsByModuleHier[moduleCompare], studentsByModuleHier[moduleClash]))
                    #Atleast one student shares same module so clash
                    constraintScore+=1
                end
            end
        end
        #Insert score here
        if mostConstrainedModuleNo < constraintScore
            mostConstrainedModule = moduleCompare
            mostConstrainedModuleNo = constraintScore
        elseif mostConstrainedModuleNo == constraintScore
            #Choose Randomly
            if mostConstrainedModule == ""
                #Fix for case of no interactions between only 2 module size
                mostConstrainedModule = collect(keys(studentsByModuleHier))[1]
            end
            temp = [mostConstrainedModule,moduleCompare]
            mostConstrainedModule = rand(temp)
            if mostConstrainedModule == moduleCompare
                mostConstrainedModuleNo = constraintScore
            end
        end
    end
    return mostConstrainedModule
end
