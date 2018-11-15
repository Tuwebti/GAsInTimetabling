
abstract type TimetablingProblem end

const Event = String
const Lecturer = String
const Student = String
const Classroom = String
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
end
