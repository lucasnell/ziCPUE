# Raw R code chunks for 'compiling.Rmd'



## @knitr libraries
library("dplyr")
library("tidyr")
library("readxl")
library("stringr")
library("readr")


## @knitr inputs
apal_df <- read_excel(paste0('~/Google Drive/Gulf sturgeon/Adam/',
                             'Final NRDA_Blood_updated_July_2016.xlsx'), 
                      col_types = c('text', 'date', rep('text', 6), 'numeric', 
                                    rep('text', 4), 'numeric', 'numeric', 
                                    rep('text', 78-15)))
suwa_df <- read_excel(paste0("~/Google Drive/Gulf sturgeon/Randall/Melissa/",
                          "Copy of Suwannee July 1 2016.xlsx"), 
                   sheet = 2)
pearl_df <- read_excel(paste0('~/Google Drive/Gulf sturgeon/Western/',
                              'PR_Master_Sturgeon_July_2016.xlsx'))
pasc_df <- read_excel(paste0("~/Google Drive/Gulf sturgeon/Western/",
                          "Copy of MSP_GS_Tagdata_Pascagoula.xlsx"))
choc_df <- suppressWarnings(
    read_excel(paste0("~/Google Drive/Gulf sturgeon/Choctawhatchee/",
                      "Choc_Sturgeon_transmitter_2010_2012.xlsx"), 
               na = 'NA'))
yell_df <- read_excel(paste0('~/Google Drive/Gulf sturgeon/Adam/',
                          'Yellow_Escambia_vTagID_update_June_2016.xlsx'),
                   na = 'NA')
panh_df <- read_excel(paste0('~/Google Drive/Gulf sturgeon/Adam/From Frank July 2016/',
                  'Panhandle_rivers_Frank_July_2016.xlsx'))
erdc_df <- read_excel(paste0('~/Google Drive/Gulf sturgeon/Western/',
                          'Pearl_ERDC_Todd_June_23_2016.xlsx'))



## @knitr manApal
apal_df <- apal_df %>% 
    select(2:15) %>%
    mutate(
        vTagID = as.integer(V_TagID),
        vSerial = as.character(V_Serial),
        FL_mm = FL_cm * 10, 
        TL_mm = TL_cm * 10,
        PIT_Tag1 = as.character(PIT_New), 
        PIT_Tag2 = as.character(Pit_Old),
        Date = as.Date(Date),
        Site = gsub('_', ' ', Site) %>% str_to_title
    ) %>%
    select(Site, Date, vTagID, vSerial, PIT_Tag1, PIT_Tag2, TL_mm, FL_mm)


## @knitr manSuwa
suwa_df <- suwa_df %>%
    rename(
        vTagID = `ACOUSTIC TAG #`,
        PIT_Tag1 = `TAG 9    PIT TAG (ANTERIOR D FIN BASE)`,
        PIT_Tag2 = `TAG 10 EXTRA  OR AUX PIT TAG (INCL EXTRA PIT TAG 2)`,
        TL_mm = `TL mm`,
        FL_mm = `FL mm`,
        Site = `RIVER SYS`,
        Date = DATE
    ) %>%
    mutate(
        Date = as.Date(Date),
        Site = gsub('_', ' ', Site) %>% str_to_title
    ) %>%
    select(Site, Date, vTagID, PIT_Tag1, PIT_Tag2, TL_mm, FL_mm)


## @knitr manPearl
pearl_df <- pearl_df %>%
    filter(Species == 'Gulf_Sturgeon') %>% 
    mutate(
        Date = as.Date(paste(Month, Day, Year, sep = '-'), format = '%m-%d-%Y'),
        Site = gsub('_', ' ', `Capture Water Body`) %>% str_to_title,
        FL_mm = `FL-cm` * 10,
        TL_mm = `TL-cm` * 10,
        PIT_Tag1 = ifelse(!is.na(`Converted PIT Tag (hexadecimal format)`), 
                          `Converted PIT Tag (hexadecimal format)`, 
                          `Pit Tag`),
        vTagID = as.integer(Tel_tag_code),
        vSerial = as.character(Tel_tag_SN),
        PIT_Tag2 = as.character(`old_Pit_tag`)
    ) %>%
    select(Site, Date, vTagID, vSerial, PIT_Tag1, PIT_Tag2, TL_mm, FL_mm)


## @knitr manPasc
pasc_df <- pasc_df %>%
    mutate(
        Date = as.Date(Date_Tagged),
        Site = "Pascagoula",
        FL_mm = `FL(cm)`*10,
        TL_mm = `TL(cm)`*10
    ) %>%
    rename(
        vTagID = Tag_ID,
        PIT_Tag1 = `Pit Tag`
    ) %>%
    select(Site, Date, vTagID, PIT_Tag1, TL_mm, FL_mm)



## @knitr manChoc
choc_df <- choc_df %>%
    mutate(
        FL_mm = `Fork Length (cm)`*10,
        TL_mm = `Total Length (cm)`*10,
        Date = as.Date(`Date Tagged/landed`),
        Site = "Choctawhatchee River"
    ) %>%
    rename(
        vTagID = `VEMCO Tag #`,
        PIT_Tag1 = `New PIT Tag #`,
        PIT_Tag2 = `Existing Pit Tag #`
    ) %>%
    select(Site, Date, vTagID, PIT_Tag1, PIT_Tag2, TL_mm, FL_mm)



## @knitr manYell
yell_df <- yell_df %>%
    rename(
        PIT_Tag1 = `PIT  Tag`, 
        PIT_Tag2 = `PIT (old)`,
        FL_mm = `F L (mm)`, 
        TL_mm = `T L (mm)`) %>%
    mutate(
        Date = as.Date(Date),
        Site = gsub('_', ' ', Site) %>% str_to_title
    ) %>%
    select(Site, Date, vTagID, vSerial, PIT_Tag1, PIT_Tag2, TL_mm, FL_mm)



## @knitr manPanh
panh_df <- panh_df %>%
    mutate(
        vTagID = as.integer(vTagID),
        vSerial = as.character(vSerial),
        FL_mm = FL_cm * 10, 
        TL_mm = TL_cm * 10,
        PIT_Tag1 = as.character(PIT_new), 
        PIT_Tag2 = as.character(PIT_old),
        Date = as.Date(Date),
        Site = paste0(gsub('_', ' ', River) %>% str_to_title, ' River'),
        Internal = (Internal_External == 'Internal')
    ) %>%
    select(Site, Date, vTagID, vSerial, PIT_Tag1, PIT_Tag2, TL_mm, FL_mm, Internal)


## @knitr manErdc
erdc_df <- erdc_df %>%
    mutate(
        Date = as.Date(`Date`),
        vTagID = as.integer(vTagID),
        vSerial = as.character(vSerial)
    ) %>%
    rename(PIT_Tag1 = PIT_Tag) %>%
    select(Site, Date, vTagID, vSerial, PIT_Tag1, TL_mm, FL_mm)



## @knitr gatherFun
gatherByPIT <- function(df){
    df %>%
        gather(PIT_name, PIT_Tag, starts_with('PIT_Tag', ignore.case = FALSE)) %>%
        filter(PIT_name == 'PIT_Tag1' | !is.na(PIT_Tag)) %>%
        select(-PIT_name) %>% 
        filter(!is.na(vTagID) | !is.na(PIT_Tag))
}



## @knitr runGather
allSites <- lapply(ls(pattern = '_df'), function(x) eval(as.name(x))) %>%
    lapply(., gatherByPIT) %>% 
    bind_rows
allSites


## @knitr cleanSites
name_df <- read_csv('./csv_in/site_name_corrections.csv', col_types = 'ccc')
get_sys <- function(sites){
    sapply(sites, function(x){name_df$System[name_df$Site == x]})
}
get_sub <- function(sites){
    sapply(sites, function(x){name_df$Subsystem[name_df$Site == x]})
}
cleanSites <- allSites %>% 
    mutate(System = get_sys(Site), Subsystem = get_sub(Site), 
           vTagID = as.integer(vTagID)) %>% 
    select(System, Subsystem, Date, vTagID, vSerial, TL_mm, FL_mm, PIT_Tag, Internal)



## @knitr fixPITs
# The below code is not currently in use. It's here bc I will later be fixing PIT tags.
# Looking at lengths of PIT tags
# allSites %>% filter(! grepl('[[:alpha:]]', PIT_Tag), !is.na(PIT_Tag))
# 
# allSites %>% 
#     filter(!is.na(PIT_Tag)) %>% 
#     mutate(pit_len = str_length(PIT_Tag)) %>% 
#     select(pit_len) %>% table

