from numpy.core.fromnumeric import size
import pandas as pd

# Little script used to generate all the possible names for the rivens you want to search for based on their attributes.
# Useful for chat filters
# There must be a way to generate permutations with the stat preffixes and suffixes much easier and natural to use.
# But this does the work quite well for the 5 minutes it took to be created.

exc = pd.read_excel("statNames.xlsx")
attr = [None] * 3
position = []
categories = exc["Type"].tolist()
start = exc["Pre/Core"].tolist()
end = exc["End"]

attr[0] = input("First attribute: ")
attr[1] = input("Second attribute: ")
attr[2] = input("Third attribute: (-1 means none): ")

position = [categories.index(i) for i in attr if i != "-1"]  # Gets the index of the attributes
suffix = [start[i] for i in position]
cor = suffix
ending = [end[i] for i in position]  # Search for their values

# Generates permutations
nameList = []
for i, v1 in enumerate(suffix):
    for j, v2 in enumerate(cor):
        if v1 != v2:
            for k, v3 in enumerate(ending):
                if k != j and k != i:
                    nameList.append(v1 + "-" + v2.lower() + v3.lower())


print(nameList, sep="\n")
