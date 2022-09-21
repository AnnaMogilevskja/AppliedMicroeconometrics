use "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment 4/HighSchooData.dta"

#Table 1
asclogit choice, case(id) alternatives(school) casevars(gender testscore)

#Table 2
asclogit choice sibling distance, case(id) alternatives(school)

#Table 3
asclogit choice sibling distance, case(id) alternatives(school) casevars(gender testscore)
