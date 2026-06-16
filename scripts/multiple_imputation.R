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

# change default imputation method
meth = ini$meth
meth

# change the method for bmi to norm (Bayesian normal linear regression imputation)
meth["bmi"] <- "norm"
meth

# run the imputation again to factor in new models
impNormBmi <- mice(nhanes_factor, predictorMatrix = predM, meth = meth, print = F)

# extend the number of iterations
impNormBmi_10 <- mice.mids(impNormBmi, maxit = 5,print = F)

# set seed for reproducibility
imp <- mice(nhanes_factor, seed = 123, m = 5, maxit = 5, print = F)
imp

# different elements stored in the mids object created by the mice() function.
attributes(imp)

imp$data
imp$imp

# plot the iterations
plot(imp)

# extracting the complete dataset
c3 <- complete(imp, 3)
md.pattern(c3)

c.long <- complete(imp, "long")
head(c.long)

# broad format
c.broad <- complete(imp, "broad")
head(c.broad)

# compare summary statistics or original and imputed data
summary(nhanes_factor)

summary(complete(imp))

# results of mean calculations from each impute dataset
summary(with(imp, mean(chl)))

# the result of the mean calculation for the original dataset with missing values removed
summary(with(nhanes_factor, mean(chl, na.rm = T)))

# further diagnostic check
stripplot(imp, chl~.imp, pch = 20, cex = 2)

stripplot(imp)



      