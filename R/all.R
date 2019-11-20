globals <- new.env(hash=TRUE, parent=emptyenv())

globals$DEBUG <- FALSE

## setup the path at package level so that DB can be accessed
## during package install/lazyload db creation.
##
## We reset the DB_PATH in .onLoad since we need to
## get the right one based on libpath
globals$DB_PATH <- system.file("extdata", "pd.mirna.4.1.sqlite",
                               package="pd.mirna.4.1")
if (nchar(globals$DB_PATH) == 0)
  stop("Unable to locate DB file")

initDbConnection <- function() {
    globals$dbCon <- dbConnect(dbDriver("SQLite"), dbname=globals$DB_PATH)
    globals$dbCon
}

getDb  <- function() {
    if (!is.null(globals$dbCon) && dbIsValid(globals$dbCon))
      return(globals$dbCon)
    initDbConnection()
}

closeDb <- function() {
    if (dbIsValid(globals$dbCon)){
        sapply(dbListResults(globals$dbCon), dbClearResult)
        dbDisconnect(globals$dbCon)
    }
    remove(list="dbCon", envir=globals)
}

.onAttach <- function(libname, pkgname) {
    globals$DB_PATH <- system.file("extdata", "pd.mirna.4.1.sqlite",
                                   package="pd.mirna.4.1",
                                   lib.loc=libname)
    if (nchar(globals$DB_PATH) == 0)
      stop("Unable to locate DB file")
    ## Establish a connection to the SQLite DB
    initDbConnection()
}

.onUnload <- function(libpath) {
    closeDb()
}

pd.mirna.4.1 <- new("AffyExpressionPDInfo",
                    genomebuild="NCBI Build 35, May 2004",
                    getdb=getDb,
                    geometry=as.integer(strsplit("541;541", ";")[[1]]),
                    annotation="pd.mirna.4.1")

