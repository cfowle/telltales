###############################################################################
##  Project: Regatta Results
##  File Purpose: Pulls data from RegattaNetwork.com
##  Owner: Carrie Fowle
##  Last Updated: January 15, 2018
###############################################################################

urlPrefix = "https://www.regattanetwork.com/clubmgmt/applet_regatta_results.php?regatta_id="
urlSuffix = "&show_crew=1"
results = data.frame()

testURL = "https://www.regattanetwork.com/clubmgmt/applet_regatta_results.php?regatta_id=1642&show_show_crew=1"

webpage = read_html(testURL)

##get headers
rtables = html_nodes(webpage, "table")
header = rtables[[3]] %>% html_text()

##get divisions
divisions = html_nodes(webpage, "h2") %>% sapply(html_text)

##get results
results = tail(rtables, -3) %>% lapply(html_table, header=TRUE, fill = TRUE)



