# import the dataset
tb_data <- readr::read_csv("data/TB_dr_surveillance_2023-05-08.csv")

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




