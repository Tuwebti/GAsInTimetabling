println("available files are :")
filenames=readdir("saved-variables")
for (i,filename) in enumerate(filenames)
    println(string(i) *" : "* filename)
end
println("specify file to load from :")
saveFile = filenames[parse(Int,readline(stdin))]
chromosomes = load(joinpath("saved-variables",saveFile),"chromosomes")
meanScores = load(joinpath("saved-variables",saveFile),"meanScores")
