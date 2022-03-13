library(tidyverse)
library(stringr)
library(edgar)

# Importing CIKs_01_2014-03_2022 that was saved by 8-K_filings_scraping_script.ipynb
ciks <- read.csv(file = 'path_to_file/CIKs_01_2014-03-2022', sep = ',', header = TRUE)
ciks <- ciks %>% select(CIK) # 2773 ciks
ciks_unique <- ciks %>% distinct(CIK)
ciks_unique #495 unique ciks
# Adding 2 CIKs that are in the same row
ciks_unique <- append(ciks_unique$CIK, c('CIK 0001753648','CIK 0001790515'))
# Deleting the row that had 2 CIKs
ciks_unique <- ciks_unique[-253]
ciks_unique <- as.data.frame(ciks_unique)

# Removing "CIK" and 0s
ciks_unique[ , 2:3] <- str_split_fixed(ciks_unique$ciks_unique, "000", 2)
#https://stackoverflow.com/questions/66111547/remove-first-character-of-string-with-condition-in-r
ciks_unique$final_CIK <- str_remove(ciks_unique$V3, "^0+")
ciks_to_evaluate <- ciks_unique$final_CIK

# Using edgar package to count how many times "blockchain" appear in the 8-k filings of ciks_to_evaluate
useragent = "your_name your_email"
word.list = 'blockchain'
output <- searchFilings(cik.no = test_ciks_vector,
                        form.type = c('8-K'),
                        filing.year = c(2018,2019,2020,2021),
                        word.list,
                        useragent) 
output

# The calculation of output takes around 5 horus for every year. So we decided that each group member would run a year on its computer.
# importing the results:
output_2021 <- read.csv(file = 'path_to_outputs/output_2021.csv', sep = ',', header = TRUE)
output_2020 <- read.csv(file = 'path_to_outputs/output_2020.csv', sep = ',', header = TRUE)
output_2019 <- read.csv(file = 'path_to_outputs/output_2019.csv', sep = ',', header = TRUE)
output_2018 <- read.csv(file = 'path_to_outputs/output_2018.csv', sep = ',', header = TRUE)

# Consolidating the results
output_2018_2021 <- rbind(output_2018, output_2019)
output_2018_2021 <- rbind(output_2018_2021, output_2020)
output_2018_2021 <- rbind(output_2018_2021, output_2021)

# Filtering 8-k filings that don't have "blockchain" (nwords.hits = 0)
output_2018_2021_distinct <- output_2018_2021  %>% filter(nword.hits!= 0)

# deleting companies that have "blockchain or BLOCKCHAIN in their name
index1 <- with(output_2018_2021_distinct, !grepl("Blockchain|BLOCKCHAIN", company.name))
companies_wo_blockchain <- output_2018_2021_distinct[index1,]

# Using distinct to delete repetition and keep the date where blockchain was first mentioned for a company.
companies_wo_blockchain_unique <- companies_wo_blockchain %>% distinct(company.name, .keep_all = T)
companies_wo_blockchain_unique

# Exporting df to csv to perform the next step: extract financial data from Compustat
write.csv(companies_wo_blockchain_unique,"path_where_to_save_the_file/output_2018_2021_unique.csv", row.names = FALSE)

