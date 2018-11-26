#= module to import various timetabling data whilst maintaining common interface
=#
using CSV

#TODO make timetableImport() generic to work on different inputs
abstract type ImportMode end
struct TestImport <: ImportMode end
struct Year1Import <: ImportMode end
struct Year2Import <: ImportMode end
struct BothYearImport <: ImportMode end
struct Data1Import <: ImportMode end
function timetableImport(importmode=TestImport())
    _timetableImport(importmode)
end

function _timetableImport(::TestImport)
    events::Set{Event} = Set(["ECM1","ECM2","ECM3","ECM4","ECM5"])
    students::Set{Student} = Set(["Barry","Julie","Charles"])
    studentEnrollement=Dict("Barry" => Set(["ECM2","ECM3"]) , "Julie" => Set(["ECM1","ECM2","ECM5"]) , "Charles" => Set(["ECM3","ECM4","ECM5"]))
    SimpleTutorialTimetablingProblem(events , students , studentEnrollement)
end
function _timetableImport(::BothYearImport)
    events::Set{Event} = Set(["MTH1001","MTH1002","MTH1003","MTH1004","MTH2001","MTH2002","MTH2003","MTH2004"])
    students::Set{Student} = Set([])
    studentEnrollement=Dict()
    for row in CSV.File(joinpath("data","Year1StudentsAnonymised.csv"))
        studentId = "1." * string(row.ID)
        push!(students, studentId)
        Year1Modules = ["MTH1001","MTH1002","MTH1003","MTH1004"]
        enrolledModules = Year1Modules[map(x -> x=="Yes", [row.MTH1001,row.MTH1002,row.MTH1003,row.MTH1004])] # gives an array of the enrolled modules of a student
        push!(studentEnrollement, studentId => Set(enrolledModules))
    end
    for row in CSV.File(joinpath("data","Year2StudentsAnonymised.csv"))
        studentId = "2." * string(row.ID)
        push!(students, studentId)
        Year1Modules = ["MTH2001","MTH2002","MTH2003","MTH2004"]
        enrolledModules = Year1Modules[map(x -> x=="Yes", [row.MTH2001,row.MTH2002,row.MTH2003,row.MTH2004])] # gives an array of the enrolled modules of a student
        push!(studentEnrollement, studentId => Set(enrolledModules))
    end
    studentsByModule = studentsbymodule(events, students, studentEnrollement)
    SimpleTutorialTimetablingProblem(events , students , studentEnrollement, studentsByModule)
end
function _timetableImport(::Data1Import)
    lines = readlines(joinpath("data","dataset1.tim"))
    firstLine = [parse(Int, x) for x in split(lines[1])]
    eventNumber = firstLine[1]
    roomNumber = firstLine[2]
    studentNumber = firstLine[4]
    events = Set([string(x) for x in 1:eventNumber])
    students = Set([string(x) for x in 1:studentNumber])
    studentEnrollement = Dict()
    for i in 1:studentNumber
        student = string(i)
        studentEnrollement[student] = Set()
        for j in 1:eventNumber
            event = string(j)
            index = (i-1)*eventNumber+ j + 1 + roomNumber
            if lines[index]=="1"
                push!(studentEnrollement[student] , event)
            end
        end
    end
    studentsByModule = studentsbymodule(events, students, studentEnrollement)
    return SimpleTutorialTimetablingProblem(events, students, studentEnrollement, studentsByModule)
end

function studentsbymodule(events,students,studentEnrollement)
    studentsByModule=Dict()
    for event in events
        studentsByModule[event]=[]
        for (student,enrolledModules) in pairs(studentEnrollement)
            if event∈enrolledModules
                push!(studentsByModule[event],student)
            end
        end
    end
    return studentsByModule
end



