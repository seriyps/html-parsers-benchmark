##
## Created on 2012-12-09
## @author: Sergey Prokhorov <me@seriyps.ru>
##
## So, we run some number of tests like
## ./run.sh 100 2>&1 | tee output_100.txt
## ./run.sh 500 2>&1 | tee output_500.txt
## ...
## Convert them to CSV like
## ./to_csv.py < output_100.txt > results-100.csv
## ./to_csv.py < output_500.txt > results-500.csv
## ...
## Now you can play with them using this R script
##
require(ggplot2)

## merge all files, add "loops" column
## TODO: looks ugly. Maybe do this in bash/python???
merge.loops.file <- function(n, to=FALSE) {
  filename = paste("../results-", n, ".csv", sep="")
  data = read.csv(filename)
  data$loops <- n
  if (class(to) == "data.frame")
    data = merge(to, data, all=T)
  data
}

runs = c(10, 100, 1000)

res = FALSE
for (run in runs) {
  res <- merge.loops.file(run, res)
}

## add column with file sizes
pages <- file.info(Sys.glob("../page_*.html"))
pages$name <- attr(pages, "row.names")
pages <- transform(pages, file = sub("../", "", name))
res <- merge(res, pages[c("size", "file")], by = "file")

## add "pp" column (platform + parser) with concatenated platform and parser
res <- transform(res, pp = paste(platform, "/", parser))

## So, now we have data.frame like
##
#      file  platform    parser parser.s real.s  user.s sys.s maximum.RSS loops size                      pp
# page_goo.. c-libxml2 libxml2_h.. 3.13..   0.03   0.03  0.00    2244      10  118148 c-libxml2 / libxml2_h..
# page_goo.. c-libxml2 libxml2_h.. 2.92..   0.29   0.29  0.00    2244     100  118148 c-libxml2 / libxml2_h..
##

## plots

histOptions <- opts(axis.text.x = theme_text(angle = 330))
boxOptions <- opts(axis.text.x = theme_text(angle = -50, hjust=0, vjust=1))

bench.plot.secondsPerLoop <- function(data, page) {
  g <- (ggplot(transform(data, spl = parser.s/loops),
               aes(loops, spl))
        + geom_histogram(stat = "identity")
        + ylab(paste("Seconds per loop for page", page))
        ## + ylab("Seconds / loop")
        ## + ggtitle(paste("Seconds per loop for page", page))
        + facet_wrap(~ pp, nrow=2)
        + histOptions)
  print(g)
}

bench.plot.memoryVsIterations <- function(data, page) {
  g <- (ggplot(data, aes(loops, maximum.RSS))
        + geom_histogram(stat = "identity")
        + ylab(paste("Memory for page", page, "(kb)"))
        + facet_wrap(~ pp, nrow=2)
        + histOptions)
  print(g)
}

bench.plot.secondsBox <- function(data, page) {
  g <- (ggplot(transform(data, spl=parser.s/loops), aes(pp, spl))
        + geom_boxplot()
        + ylab(paste("Average seconds per loop for page", page))
        + boxOptions)
  print(g)
}

png(width=800, height=600)

lapply(attr(res$file, "levels"), function(page) {
  bench.plot.secondsPerLoop(subset(res, file==page), page)
})

data = res ## subset(res, !((platform=="pypy") & ((parser=="bsoup4_parser.py") | (parser=="html5lib_parser.py"))))
lapply(attr(data$file, "levels"), function(page) {
  bench.plot.memoryVsIterations(subset(data, file==page), page)
})

lapply(attr(res$file, "levels"), function(page) {
  print(page)
  bench.plot.secondsBox(subset(res, file==page), page)
  print(page)
})

dev.off()


## tips:
##
## res[c("pp", "file", "parser.s", "loops", "maximum.RSS")]        # SELECT ... FROM
## subset(res, (platform=="erlang") & (file=="page_google.html"))  # WHERE ...
## res[order(res$parser.s, decreasing=T),]                         # ORDER BY ...
##
## options(width=100)  # terminal width (for line wrapping)
