library(opendatatoronto)
library(tidyverse)

# Lets start with covid data:(cite the data )
covid_package_id <- search_packages(" COVID-19 Cases in Toronto")$id
covid_data_id <- list_package_resources(covid_package_id)$id
covid_data <- get_resource(covid_data_id) # gives 179868 observations of 18 variables

# what variables of interest do we have in this dataset?

#Outbreak Associated: is this case associated with an outbreak from an hospital, care-home etc

#age group

#NeighbourhoodName: 140 distinct neighborhoods that provide socio-economic data. Perhaps more research can be done to indenity 
# which neighborhood have higher cases 

#FSA: first 3 letters of the postal code, which is a proxy for neihborhood. Not sure if its needed tbh 

#source of infection: travel, outbreak, contact etc. Not sure if this needed

#Classification: are they likely to have covid infection or confirmed to have a covid infection

#Episode date Estimate when the disease was accuired

#Report date: when was the case reported to Toronto public health. This has to be turned into a numerical varible. Maybe into years
# and months

#Client Gender

#Outcome: Fatal, Resolved, active. (We'll combine this into binary response variable, fatal or non fatal)

# we might bring in other variables, if regression analysis is not that helpful for predicting fatality

# tenative hypothesis: THe older people are more likely to have fatal cases and the fatality likelihood should go down as time
# progresses

# Transform the data
covid_data_clean <- na.omit(covid_data) # still has 17642 observations in it 
#1) convert all the non-fatal cases to non fatal (Reloved or Active becomes non-fatal)
# we might include more variable if we come up with a better hypothesis
dataset <- covid_data_clean %>% 
  select(`Reported Date`, `Client Gender`, `Age Group`, Outcome) %>%
  rename(Date = `Reported Date`, Gender = `Client Gender`, Age_group = `Age Group`) %>%
  filter(!(Gender == 'UNKNOWN' | Gender == 'NOT LISTED, PLEASE SPECIFY')) %>%
  mutate(Outcome = if_else(Outcome == 'FATAL', 1, 0))

#2) For each case, record the number of days that have passed since the first case was recorded
initial_date = as.Date(min(dataset$Date))
dataset <- dataset %>% 
  mutate(Day = as.integer(as.Date(Date, format = "%Y-%m-%d") - initial_date))

#Now start with full model and use different criterias to select variables
# we will use step-wise regression and will have to explain why AIC is best for logistic regression

#check if the variables I have are a good predictors
# non-binary gender has higer chance of fatal cases 
logit_model <- glm(Outcome ~ as.factor(Gender) + as.factor(Age_group) + Day, data = dataset, family = 'binomial')
summary(logit_model)
#ok so looks like all the variable choices are good. So I can go head with phase 2 of investigation. Compare these factors 
# before covid before 2020 
data_prevaccine <- dataset %>%
  filter(as.Date(Date) < as.Date('2020-12-14'))

data_postvaccine <- dataset %>%
  filter(as.Date(Date) > as.Date('2020-12-14'))

model_pre <- glm(Outcome ~ as.factor(Gender) + as.factor(Age_group) + Day, data = data_prevaccine, family = 'binomial')
model_post <- glm(Outcome ~ as.factor(Gender) + as.factor(Age_group) + Day, data = data_postvaccine, family = 'binomial')

summary(model_pre)
summary(model_post)

#Looks like vaccinations work 

#1) I want number of cases for each day
days <- unique(dataset$Day)
days <- days[order(days)]
fatal_cases <- c()
non_fatal_cases <- c()
  
index = 1
for(i in days) {
  fatal_cases[index] <- sum(dataset$Day == i & dataset$Outcome == 1)
  non_fatal_cases[index] <- sum(dataset$Day == i & dataset$Outcome == 0)
  index = index + 1
}

cases_sums <- tibble(
  day = days,
  fatal = fatal_cases,
  non_fatal = non_fatal_cases
) 

#draw a scatter plot with days vs fatal cases
fatal_scatter <- ggplot(data = cases_sums, aes(x = days, y = fatal_cases)) +
  geom_point(color = "red")

non_fatal_scatter <- ggplot(data = cases_sums, aes(x = days, y = non_fatal_cases)) +
  geom_point(color = "green")

grid.arrange(fatal_scatter, non_fatal_scatter)

# the age group seems like there's too many bins too. Perhaps we should combine the bins like under 25 and over 25 or maybe do
# a bar graph for each bin? 
# can we do group by operations for each age_group
# this is much better
gender_data <- dataset %>% 
  group_by(Day) %>%
 count(gender = Gender)

ggplot(data = gender_data, aes(x = as.factor(gender), y = n)) +
  geom_boxplot()

age_data <- dataset %>%
  group_by(Day, Outcome) %>%
  count(age_cases = Age_group)

ggplot(data = age_data, aes(x = as.factor(age_cases), y = n)) +
  geom_boxplot()+
  coord_flip()

age_data_fatal <- age_data %>% filter(Outcome == 1)
ggplot(data = age_data_fatal, aes(x = as.factor(age_cases), y = n)) +
  geom_boxplot()+
  coord_flip()

age_data_post_vax <- data_postvaccine %>% 
  filter(Outcome == 1) %>%
  group_by(Day) %>%
  count(age_cases = Age_group)

ggplot(data = age_data_post_vax, aes(x = as.factor(age_cases), y = n)) +
  geom_boxplot()+
  coord_flip()

age_data_pre_vax <- data_prevaccine %>% 
  filter(Outcome == 1) %>%
  group_by(Day) %>%
  count(age_cases = Age_group)

ggplot(data = age_data_pre_vax, aes(x = as.factor(age_cases), y = n)) +
  geom_boxplot()+
  coord_flip()