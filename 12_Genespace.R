library(GENESPACE)
library(ggplot2)


# 1) Specify paths to the working directory and MCScanX
wd <- "/data/users/sjaegers/assembly_annotation_course/12_Genespace_all"
path2mcscanx <- "/data/users/sjaegers/assembly_annotation_course/scripts/MCScanX"
# 2) Run init_genespace to make sure that the input data is OK.
# It also produces the correct directory structure and corresponding paths
# for the GENESPACE run
gpar <- init_genespace(wd = wd, path2mcscanx = path2mcscanx)

# 3) Run GENESPACE
out <- run_genespace(gpar, overwrite = T)