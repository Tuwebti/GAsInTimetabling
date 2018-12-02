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
            #Fix 1
            if mostConstrainedModule == ""
                mostConstrainedModule = collect(keys(studentsByModuleHier))[1]
            end
            #Fix 2
            if mostConstrainedModule == moduleCompare
                mostConstrainedModuleNo = constraintScore
            end

            #choose based on module size
            moduleCompareSize = length(collect(studentsByModuleHier[moduleCompare]))
            mostConstrainedSize = length(collect(studentsByModuleHier[mostConstrainedModule]))

            #assignes monstConstrainedModule to highest score
            if  mostConstrainedSize < moduleCompareSize
                #modulecompare has fewer students
                mostConstrainedModule = moduleCompare
            elseif mostConstrainedSize == moduleCompareSize
                #Choose Randomly, when rooms equal size
                temp = [mostConstrainedModule,moduleCompare]
                mostConstrainedModule = rand(temp)
            end
        end
    end
    return mostConstrainedModule
end
