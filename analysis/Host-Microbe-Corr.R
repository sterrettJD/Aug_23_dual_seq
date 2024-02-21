if(!require("HoMiStats")){
    devtools::install_github("sterrettJD/HoMiStats")
}

library(tidyverse)

# read in mtx KO data
ko <- data.table::fread("../seq.f0.0.r0.0.nonhost.humann/all_genefamilies_ko_named.tsv",
                        data.table=F)
# clean mtx KO data
rownames(ko) <- ko$`# Gene Family`
ko$`# Gene Family` <- NULL
ko <- ko %>% mutate_all(as.numeric)
colnames(ko) <- colnames(ko) %>%
    gsub(pattern="_Abundance-RPKs", replacement="")

# Remove any rows with taxonomy
ko.tax.rows <- rownames(ko) %>% grepl(pattern="\\|")
ko.notax <- ko[!ko.tax.rows,]

# Remove unmapped and ungrouped before relative abundance
un.rows <- rownames(ko.notax) %in% c("UNMAPPED", "UNGROUPED")
ko.notax.mapped <- ko.notax[!un.rows,]

# Convert to relative abundance and transpose so features are columns
ko.notax.rel <- data.frame(t(ko.notax.mapped)/colSums(ko.notax.mapped))
# remove features that average less than 1 transcript per million
ko.notax.rel <- filter_low_abundance_by_mean(ko.notax.rel, 1e-6)
# remove features with a standard deviation less than 1 transcript per million
ko.notax.rel <- filter_low_variance(ko.notax.rel, (1e-6)^2)
# remove features found in fewer than 10% of samples
ko.notax.rel <- filter_sparse_features(ko.notax.rel, 0.1)



# read in host transcriptome
host <- data.table::fread("../seq.f0.0.r0.0.host//host_gene_counts_tpm.csv",
                          data.table=F)
# clean host data
rownames(host) <- host$V1
host$V1 <- NULL
host <- data.frame(t(host))

# put from [0,1million) to [0,1)
host <- host/1e6

# remove features that average less than 1 transcript per million
host <- filter_low_abundance_by_mean(host, 1e-6)
# remove features with a standard deviation less than 1 transcript per million
host <- filter_low_variance(host, (1e-6)^2)
# remove features found in fewer than 50% of samples
host <- filter_sparse_features(host, 0.5)


subset.size <- 1000

time <- system.time(
    res <- run_HoMiCorr(ko.notax.rel[,1:subset.size], host[,1:subset.size], reg.method="lm",
                        ncores=32, show_progress=T)
)

write.csv(res, "HoMiCorr_out.csv")
print(time)

# TESTING
# times <- c()
# sizes <- c(100, 200, 400, 800)
# for(size in sizes){
#     subset.host <- host[1:size]
#     subset.mtx <- ko.notax.rel[,1:size]
#
#     time <-system.time(
#         res <- run_HoMiCorr(subset.mtx, subset.host, reg.method="lm", ncores=8)
#     )
#     times <- c(times, time[3])
# }
# subset.host <- host[,1:100]
# subset.mtx <- ko.notax.rel[,1:100]




