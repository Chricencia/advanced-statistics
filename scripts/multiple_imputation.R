# multiple imputation
nhanes
library(mice)
nhanes_factor <- nhanes |> 
  dplyr::mutate(
    hyp = as.factor(hyp),
    age = as.factor(age)
  )

# report proportions of missing data for all variables 
nhanes_factor |> 
  naniar::miss_var_summary()

# visualize the missingness
nhanes_factor |> 
  naniar::gg_miss_fct(fct = hyp)

# returns an s3 object of class, mids
ini <- mice(nhanes_factor, maxit = 0)

# see how many missing for each variable
ini$nmis

# extract the predictor matrix from the ini object
predM <- ini$predictorMatrix

# remove age from the model by setting its value to 0 in the predictor matrix
predM[, c("age")] <- 0

# And we can run the imputations, using this updated predictor matrix 
# as the value to the predictorMatrix argument: 
impNoAge <- mice(nhanes_factor, predictorMatrix = predM, print=F)







      