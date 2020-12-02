filename = "./input.txt"

inputfile = open(filename)
inputdata = list(map(int,inputfile.readlines()))

# These have the problem where if 2020/2 = 1010 is present in the list, then we won't find anything.
# Luckily in our input, we don't have this situation.

print("Two")
(x,y) = [(x, y) for x in inputdata for y in inputdata if (x != y and x + y == 2020)][0]
print(x,y)
print(x*y)

print("Three")
(x,y,z) = [(x, y, z) for x in inputdata for y in inputdata for z in inputdata if (x != y and y != z and x + y + z == 2020)][0]
print(x,y,z)
print(x*y*z)
