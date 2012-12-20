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
MergeLoopsFile <- function(n, to=FALSE) {
  filename = paste("../results-", n, ".csv", sep="")
  data = read.csv(filename)
  data$loops <- n
  if (class(to) == "data.frame")
    data = merge(to, data, all=T)
  data
}

runs = c(10, 50, 100, 400, 600, 1000)

res = FALSE
for (run in runs) {
  res <- MergeLoopsFile(run, res)
}

## add column with file sizes
pages <- file.info(Sys.glob("../page_*.html"))
pages$name <- attr(pages, "row.names")
pages <- transform(pages, file = sub("../", "", name))
res <- merge(res, pages[c("size", "file")], by = "file")

## add start-up overhead column
res <- transform(res, overhead=real.s - parser.s)

## add "pp" column (platform + parser) with concatenated platform and parser
res <- transform(res, pp = paste(platform, "/", parser))
res <- res[order(res$pp),]

## So, now we have data.frame like
##
#      file  platform    parser parser.s real.s  user.s sys.s maximum.RSS loops size                      pp
# page_goo.. c-libxml2 libxml2_h.. 3.13..   0.03   0.03  0.00    2244      10  118148 c-libxml2 / libxml2_h..
# page_goo.. c-libxml2 libxml2_h.. 2.92..   0.29   0.29  0.00    2244     100  118148 c-libxml2 / libxml2_h..
##

## plots

base_size <- 15

options.hist <- opts(axis.text.x = theme_text(angle = 330, size = base_size),
                     axis.text.y = theme_text(size = base_size),
                     strip.text.x = theme_text(size = base_size))
options.box <- opts(axis.text.x = theme_text(angle = -50, hjust=0, vjust=1, size = base_size),
                    axis.text.y = theme_text(size = base_size),
                    strip.text.x = theme_text(size = base_size * 1.2))

bench.plot.SecondsPerLoop <- function(data, page) {
  g <- (ggplot(transform(data, spl = parser.s/loops),
               aes(loops, spl))
        + geom_histogram(stat = "identity")
        + ylab(paste("Seconds per loop for page", page))
        ## + ggtitle(paste("Seconds per loop for page", page))
        + facet_wrap(~ pp, nrow=2)
        + options.hist)
  print(g)
}

bench.plot.MemoryVsIterations <- function(data, page) {
  g <- (ggplot(data, aes(loops, maximum.RSS))
        + geom_histogram(stat = "identity")
        ## + scale_y_log10()
        + ylab(paste("Memory for page", page, "(kb)"))
        + facet_wrap(~ pp, nrow=2)
        + options.hist)
  print(g)
}

bench.plot.SecondsBox <- function(data, page) {
  g <- (ggplot(transform(data, spl=parser.s/loops), aes(pp, spl))
        + geom_boxplot()
        + ylab(paste("Average seconds per loop for page", page))
        + options.box)
  print(g)
}

bench.plot.MemoryBox <- function(data, page) {
  g <- (ggplot(data, aes(pp, maximum.RSS))
        + geom_boxplot()
        ## + scale_y_log10()
        + ylab(paste("Average memory usage for page", page, "(kb)"))
        + options.box)
  print(g)
}

bench.plot.OverheadBox <- function(data, percentile) {
  g <- (ggplot(data, aes(pp, overhead))
        + geom_boxplot()
        + ylim(0, quantile(data$overhead, percentile))
        + options.box)
  print(g)
}

## png(filename="html_parser_bench_pre-%03d.png", width=500, height=350)
png(filename="html_parser_bench-%03d.png", width=1280, height=960)

speeddata = res ## subset(res, !(platform=="pypy")) ## subset(res, !((platform=="pypy") & ((parser=="bsoup4_parser.py") | (parser=="html5lib_parser.py"))))
lapply(attr(speeddata$file, "levels"), function(page) {
  bench.plot.SecondsPerLoop(subset(speeddata, file==page), page)
})

lapply(attr(speeddata$file, "levels"), function(page) {
  print(page)
  bench.plot.SecondsBox(subset(speeddata, file==page), page)
  print(page)
})

memdata = res ## subset(res, !(
  ## ((platform=="pypy") & ((parser=="bsoup4_parser.py") | (parser=="html5lib_parser.py")))
  ## | (parser=="jsdom_parser.js")
  ## ))
lapply(attr(memdata$file, "levels"), function(page) {
  bench.plot.MemoryVsIterations(subset(memdata, file==page), page)
})

lapply(attr(memdata$file, "levels"), function(page) {
  bench.plot.MemoryBox(subset(memdata, file==page), page)
})

bench.plot.OverheadBox(res, 0.98)

dev.off()


## tips:
##
## res[c("pp", "file", "parser.s", "loops", "maximum.RSS")]        # SELECT ... FROM
## subset(res, (platform=="erlang") & (file=="page_google.html"))  # WHERE ...
## res[order(res$parser.s, decreasing=T),]                         # ORDER BY ...
##
## options(width=100)  # terminal width (for line wrapping)
