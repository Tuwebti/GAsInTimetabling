#= create a Timetabling problem according to different possible timetable structures
=#
#=
module TimetablingProblemModule
export TimetablingProblem ,
    Event ,
    Lecturer ,
    Classroom ,
    StudentEnrollement ,
    TutorialTimetablingProblem
=#

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
    timeslotAmount::Int
    studentEnrollement::StudentEnrollement
end
