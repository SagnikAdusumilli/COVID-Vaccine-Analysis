library(opendatatoronto)
library(tidyverse)

#examine different datasets to see which ones will be suitable for our assignment

# Initially let us try for numerical dependent variable. This way can draw scatter plots to examine relationships between variables

# we can also do box blots to check relationship between categorical variable and dependent variable 

#website link https://open.toronto.ca/


# 1) Death data
# https://open.toronto.ca/dataset/death-registry-statistics/
# Dataset contains information relating to the regirstrations of deaths in 4 civic ceter
# quality: gold
# relevant info is: civic_centere, death liscnes, palce of death, time period, 
# time period can be converted into 2 seperate numerical variables month and year 
# dependent variable would be the number of deaths 
# the dataset even has data collection process specified
# importance of the data can be to see, if the population is getting healither i.e less deats
# we can even investigate which month has the most number of deaths
# futher investiton can be the cause (This can go into the conclusion)

#2 About Immunization Coverage for students
# Bronze quality dataset
# has data dictionay and many varieity of variables
# interesting topic

#3) Covid cases Toronto: gold star rating, obv important topic. Should be a safe choice
# https://open.toronto.ca/dataset/covid-19-cases-in-toronto/
# The data is very relevant and we can ask questions like how much does age and time (years) influence the servierity of the cases
# Definitely can provide background context 

#4) opiod usage in shelter
# https://open.toronto.ca/dataset/fatal-and-non-fatal-suspected-opioid-overdoses-in-the-shelter-system/

# Other datasites that may need more worth considering if we have time/we don't find anything good

#1) outbreaks in Toronto Health care Institutions: https://open.toronto.ca/dataset/outbreaks-in-toronto-healthcare-institutions/

#2) blacklegged ticks surveillance:https://open.toronto.ca/dataset/blacklegged-tick-surveillance/ (silver quality data). But missing data dictionary

#3) dinesafe https://open.toronto.ca/dataset/dinesafe/. This is sort of simiar to the one showed in class but is technically a different
# dataset with silver quality. Maybe I could use this.. but would have to check with the prof first

#4) Toronto safety data https://open.toronto.ca/dataset/wellbeing-toronto-safety/