##############################################################
#.............. S E T   U P   ! ! !
# to be updated
meeting_year <- "2021"
meeting_month <- "10"
meeting_day <- "18"

meeting_date <- as.numeric(paste0(meeting_year, meeting_month, meeting_day))

# measure runtime
start_time <- Sys.time()
  
# load data
sp_feedback <- read.csv(paste0("csv_files/speech_feedback_", meeting_date, ".csv"), stringsAsFactors = FALSE)
speakers_names <- names(split(sp_feedback, sp_feedback$Select.speaker))
speakers_names
rm(sp_feedback)
# sp_titles <- rep(NA, length(speakers_names))   # if titles already contained in the csv file
sp_titles <- c("Jumping into a rabbit hole","I'm Jack","Time to be","Imagine")   # otherwise add titles manually

##############################################################

# loop through all speakers to create their feedback documents
# spkr <- 4
for (spkr in 1:length(speakers_names)) {
  
  ### set up the saving space and name
  filename <- paste0("speech feedback - ", speakers_names[spkr], " - ", meeting_date, ".html")
  directory <- "./feedback"
  fulldir <- paste0(directory, "/", filename)
  
  # --------------------------------------------------------------------------------------------------------------------------------------
  ### create pdf version
  # 1) firstly create the html document with all styling
  rmarkdown::render(input = "speech_feedback_pdf.Rmd", output_file = filename, output_dir = directory, clean = TRUE,
                    params = list(year = meeting_year, month = meeting_month, day = meeting_day, s = spkr, speechtitle = sp_titles[spkr]))
  # 2) then print the created html document to pdf
  pagedown::chrome_print(fulldir)
  # remove the html
  if (file.exists(fulldir)) {file.remove(fulldir)}
  
  # --------------------------------------------------------------------------------------------------------------------------------------
  ### create a html version
  rmarkdown::render(input = "speech_feedback_html.Rmd",
                    output_file = filename, output_dir = directory, clean = TRUE,
                    params = list(year = meeting_year, month = meeting_month, day = meeting_day, s = spkr, speechtitle = sp_titles[spkr]))
}

# measure runtime
end_time <- Sys.time()
end_time - start_time