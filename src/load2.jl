function chooseDataFile()
    println("available files are :")
    filenames=readdir(joinpath("data","timetablingCompetition"))
    for (i,filename) in enumerate(filenames)
        println(string(i) *" : "* filename)
    end
    println("specify file to load from :")
    saveFile = filenames[parse(Int,readline(stdin))]
    saveFile = joinpath("data",joinpath("timetablingCompetition",saveFile))
    return saveFile
end

#------------

println("Select Import Mode : \n 1 : testinput \n 2 : realData \n 3 : Competition data without classrooms \n 4 : Competition data with classrooms")
choice = readline(stdin)
if choice == "1"
    dataFile=nothing
    timeslotamount = 3
    importMode=TestImport()
elseif choice == "2"
    dataFile=nothing
    timeslotamount = 3
    importMode=BothYearImport()
elseif choice == "3"
    dataFile=chooseDataFile()
    importMode=Data1Import()
    timeslotamount = 45
elseif choice == "4"
    dataFile=chooseDataFile()
    importMode=WithClassroomImport()
    timeslotamount = 45
else error("Input should be 1 or 2") end
println("Do you want to change timeslotamount ? (default is : " * string(timeslotamount) * " ) y/n :")
changetimeslotflag = readline(stdin)
if changetimeslotflag == "y"
    println("enter new timeslotamount :")
    timeslotamount = parse(Int, readline(stdin))
end

timetablingProblem = timetableImport(dataFile,importMode)
nothing #avoids returning timetablingProblem

