println("Select Import Mode : \n 1 : testinput \n 2 : realData \n 3 : benchmark dataset 1")
choice = readline(stdin)
if choice == "1"
    importMode=TestImport()
elseif choice == "2"
    importMode=BothYearImport()
elseif choice == "3"
    importMode=Data1Import()
else error("Input should be 1 or 2") end
timetablingProblem = timetableImport(importMode)
