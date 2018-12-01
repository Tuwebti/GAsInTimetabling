
abstract type TimetablingProblem end

const Event = String
const Lecturer = String
const Student = String
const Classroom = Int
const Timeperiod = Int
const StudentEnrollement = Dict{Student,Set{Event}}

struct TutorialTimetablingProblem <: TimetablingProblem
    events::Set{Event}
    lecturers::Set{Lecturer}
    students::Set{Student}
    classrooms::Dict{Classroom,Int16} #here Int represents classroom size
    studentEnrollement::StudentEnrollement
end
struct SimpleTutorialTimetablingProblem <: TimetablingProblem
    events::Set{Event}
    students::Set{Student}
    studentEnrollement::StudentEnrollement
    studentsByModule::Dict{Event,Vector{Student}}
end
struct RoomTimetablingProblem <: TimetablingProblem
    events::Set{Event}
    students::Set{Student}
    studentEnrollement::StudentEnrollement
    studentsByModule::Dict{Event,Vector{Student}}
    classrooms::Dict{Classroom,Int16}
end


