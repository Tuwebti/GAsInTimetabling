# This seperates the students into groups using a simple evolutionary algorithm. Sorry it's so poorly written, priority is getting it to work in as short a time as possible.

groupAmount=5
groupPopSize=10
chromosomes = Array()

# initialize population
for i in 1:groupPopSize
    chromosomes[i] = Vector()
    for group in 1:groupAmount
        chromosomes[i][group]=Set()
    end
end

# randomly assign each student to a group
for studentsByGroup in chromosomes
    for student in timetablingproblem.students
        push!(studentsByGroup[rand(1:5)], student)
    end
end



# calculate the amount of modules in each group and return 1 / maximum amount of modules in a group
function groupWeakness(studentsByGroup)
    maximum=0
    for students in studentsByGroup
        groupModules = Set()
        for student in students
            studentModules = timetablingProblem.studentEnrollement[student]
            union!(groupModules, studentModules)
        end
        numModulesInGroup = length(groupModules)
        maximum < length(groupModules) ? maximum = numModulesInGroup : nothing
    end
    return maximum
end

#Breed using uniform crossover
function iterateGroup

