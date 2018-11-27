println("Select Import Mode : \n 1 : testinput \n 2 : realData \n 3 : benchmark dataset 1")
choice = readline(stdin)
if choice == "1"
    timeslotamount = 3
    importMode=TestImport()
elseif choice == "2"
    timeslotamount = 3
    importMode=BothYearImport()
elseif choice == "3"
    importMode=Data1Import()
    timeslotamount = 45
else error("Input should be 1 or 2") end
println("Do you want to change timeslotamount ? (default is : " * string(timeslotamount) * " ) y/n :")
changetimeslotflag = readline(stdin)
if changetimeslotflag == "y"
    println("enter new timeslotamount :")
    timeslotamount = parse(Int, readline(stdin))
end

timetablingProblem = timetableImport(importMode)
