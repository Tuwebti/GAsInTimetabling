
modules = Dict("M1" => [1,4],"M2" => [2,5],"M3" => [3,4,5]); #test data, numbers indicate a student taking that module (e.g. students 1 and 4 are taking module M1)
ModuleSort = collect(keys(modules)); #initialising final module order array
moduleclash = zeros(length(modules),2); #initialising module clash table. Rows are the modules, first column is clashes with other modules, second column is number of students taking that modue that have a modue clash

modulestocompare = collect(keys(modules)) #initial modules to compare against the current module
modulestocheck = modulestocompare[1:end-1] #don't need to check the last module
global counting1 = Int16(1) #counting1 tells the loop what module it should currently be checking (increased by 1 on each loop)

for module1 in modulestocheck

  counting2 = 1 #counting2 shows how far down the 'modulestocompare' list we are

  modulestocompare = modulestocompare[counting1+1:end] #modules to compare against the current module will be all the modules after it

  #comparing each individual module in modules to compare against the current module
  for module2 in modulestocompare

    for compare in get(modules,module2,0) #for all the students taking the comparison module

      if compare in get(modules,module1,0) #if any of the students taking the comparison module are also taking the main module

        #adds 1 to the second column of moduleclash for each student with a clash for both modules with that clash
        moduleclash[counting1,2] = moduleclash[counting1,2]+1
        moduleclash[counting1+counting2,2] = moduleclash[counting1+counting2,2]+1

      end
    end

    #if the second column of module clash is not equal to zero after the above loop, then this implies there is a module clash
    if moduleclash[counting1,2] != 0
      #adds 1 to the first column of moduleclash for each module with said clash
      moduleclash[counting1,1] = moduleclash[counting1,1] + 1
      moduleclash[counting1+counting2,1] = moduleclash[counting1+counting2,1] + 1

    else
      #if second column of moduleclash is 0, then there is no module clash and so the first column for both modules is set to zero
      moduleclash[counting1,1] = 0

    end
  counting2 = counting2 + 1
  end
  counting1 = counting1 + 1
end


for sortmod in ModuleSort #looping through all modules

  #the following while loop checks how many module clashes the current module has compared to the module before. If more, it switches the two modules
  while moduleclash(1,sortmod) > moduleclash(1,sortmod-1)

    ModuleSort = ModuleSort[1:sortmod-2],module[sortmod],module[sortmod-1]
    moduleclash = moduleclash[1:sortmod-2],moduleclash[sortmod],moduleclash[sortmod-1],moduleclash[sortmod+1:end]
    sortmod = sortmod - 1

  end

    #if the number of module clashes are equal, it will then compare the number of students with clashes instead and do the same as before
    if moduleclash[1,sortmod] == moduleclash[1,sortmod-1]

      while moduleclash[2,sortmod] > moduleclash[2,sortmod-1]

        ModuleSort = ModuleSort[1:sortmod-2],module[sortmod],module[sortmod-1];
        moduleclash = moduleclash[1:sortmod-2),moduleclash[sortmod],moduleclash[sortmod-1],moduleclash[sortmod+1:end]
        sortmod = sortmod - 1

      end

    else
    end
  end
end
