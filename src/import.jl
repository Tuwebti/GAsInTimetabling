#= module to import various timetabling data whilst maintaining common interface
=#

#TODO make timetableImport() generic to work on different inputs
function timetableImport()
    events::Set{Event} = Set(["ECM1","ECM2","ECM3","ECM4","ECM5"])
    lecturers::Set{Lecturer} = Set([])
    students::Set{Student} = Set(["Barry","Julie","Charles"])
    classrooms::Dict{Classroom,Int16} = Dict()
    studentEnrollement=Dict("Barry" => Set(["ECM2","ECM3"]) , "Julie" => Set(["ECM1","ECM2","ECM5"]) , "Charles" => Set(["ECM3","ECM4","ECM5"]))
    TutorialTimetablingProblem(events , lecturers , students , classrooms , 3 , studentEnrollement)
end
