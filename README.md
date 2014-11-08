# Arrest Analysis

You should knit the documents in the following order:

```r
library(knitr)
knit("dataCollection.Rmd")
knit("arrestAnalysis.Rmd")
knit("weather.Rmd")
knit("drugArrests.Rmd")
```

The compiled HTML files are all checked in to the directory if you'd prefer to view the results without running the commands yourself.

## RMarkdown Analysis

The following Rmd files are included in the repo.

### Data Collection

[Preview](https://rawgithub.com/trestletech/ArrestAnalysis/master/dataCollection.html)

Collects the arrest data from the [Lake County site](http://www.lakesheriff.com/resources/arrests.htm), scraping the HTML.

### Arrest Analysis

[Preview](https://rawgithub.com/trestletech/ArrestAnalysis/master/arrestAnalysis.html)

A quick analysis of the arrest records compared to the demographics of the county.

### Weather

[Preview](https://rawgithub.com/trestletech/ArrestAnalysis/master/weather.html)

Download the weather for that area using the [Weather Underground API](http://www.wunderground.com/weather/api/)

### Drug Arrests

[Preview](https://rawgithub.com/trestletech/ArrestAnalysis/master/drugArrests.html)

Compare the drug arrest records to the weather in that area.

## Shiny Application

There's also a small interactive Shiny application included in the top-level directory. The hosted version is available [here](https://trestletech.shinyapps.io/arrest-weather).
