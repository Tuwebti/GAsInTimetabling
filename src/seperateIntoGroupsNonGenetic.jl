# Algorithm description. Start with a certain number n of groups and a set of students. The goal is to seperate the students into the n groups so as to minimize the maximum of the amount of modules in each group. (ie, if the set of groups is "Groups" we are trying to find min(max({|group_i| | group_i ∈ Groups}))).
# To do this, we first try to assign the n students that are the most different to each of the n different groups.
# We then iterate through the rest students, assigning them to the group_i such that |group_i union {student}| is minimal.

struct Group
    students::Set{Student}
    events::Set{Event}
end

numberOfGroups= 5
function splitIntoGroups(numberOfGroups)
    groups = Vector{Group}()
    for i in 1:numberOfGroups
        push!(groups, Group(Set{Student}(),Set{Event}()))
    end
    # find the most different students and assign them to different groups.
    for group_i in groups
        maxEvents = 0
        maxStudent = rand(timetablingProblem.students)
        for student in timetablingProblem.students
            studentMaxEvents = 0
            studentEvents = timetablingProblem.studentEnrollement[student]
            for group_j in groups
                groupWithStudentEvents = length(union(group_j.events , studentEvents))
                if studentMaxEvents <  groupWithStudentEvents
                    studentMaxEvents = groupWithStudentEvents
                end
            end
            if maxEvents < studentMaxEvents
                maxEvents = studentMaxEvents
                maxStudent = student
            end
        end
        push!(group_i.students, maxStudent)
        union!(group_i.events, timetablingProblem.studentEnrollement[maxStudent])
    end
    return groups
end

function displayGroupModuleNumber(groups)
    show(map(group -> length(group.events), groups))
end


