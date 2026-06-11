# handle duplicates
df <- tibble::tibble(x = sample(8, 15, rep = TRUE),
             y = sample(8,15, rep = TRUE))
df

duplicated(df)

# remove the duplicated rows
dplyr::distinct(df)

# identify rows for which there are duplicates
duplicated(df$x)

# remove the duplicates
dplyr::distinct(df, x)

# use the keep.all argument
dplyr::distinct(df, x, .keep_all = T)
