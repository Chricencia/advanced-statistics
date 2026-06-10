# import the dataset
tb_data <- readr::read_csv("data/TB_dr_surveillance_2023-05-08.csv")

# restarting this R code so i can record it for my tesfi audience
# keep only countries in EUR region and subset of variables
tb_data_clean <- tb_data |> 
  dplyr::filter(
    g_whoregion == "EUR") |> 
  dplyr::select(all_of(c("country", "year"))|
                  starts_with("pulm")|
                  starts_with("r_rlt")|
                  all_of(c("rr_new","rr_rel","rr_ret"))
  )

# report proportions of missing data for all variables in the dataset
# use the naniar package
tb_data_clean |> 
  naniar::miss_var_summary()

# show this graphically 
# use the package gg_ms_fct to visualize the missing values 
tb_data_clean |> 
  naniar::gg_miss_fct(
    fct = country
)

# this heat map can clearly visualize the missing values in our dataset
# specifically from the variable country 

# view the pattern of missingness
tb_data_clean |> 
  naniar::gg_miss_upset(order.by = "freq", nsets = 10)

# redoing this part just for the show
#use the mice() package to show the pattern of missingness
mice::md.pattern(tb_data_clean, rotate.names = TRUE)

#ignoring missing data
# remove two variables with most observations missing
# make a complete case version of the tb data
tb_complete <- tb_data_clean |> 
  dplyr::select(-c(r_rlt_rel,rr_rel)) |> 
  tidyr::drop_na()


naniar::as_shadow(tb_data_clean)

# this is such an interesting part of missingness
tb_shadow <- naniar::bind_shadow(tb_data_clean)

tb_shadow |> 
  dplyr::group_by(pulm_labconf_ret_NA) |> 
  dplyr::summarise_at(.vars = "pulm_labconf_new",
                      .funs = c("mean", "sd", "var", "min", "max"),
                      na.rm = TRUE)

# Imputing missing data
# Part 1: Least value carried forward
tb_data_clean <- tb_data_clean |> 
  dplyr::arrange(country, year) |> 
  dplyr::mutate(pulm_labconf_ret2 = pulm_labconf_ret) |> 
  dplyr::group_by(country) |> 
  tidyr::fill(pulm_labconf_ret2)

# Part 2: Mean Value
tb_data_clean <- tb_data_clean |> 
  dplyr::mutate(pulm_labconf_ret3 = dplyr::case_when(
    is.na(pulm_labconf_ret)~ mean(pulm_labconf_ret, na.rm = TRUE),
    TRUE ~ pulm_labconf_ret))


    
  


