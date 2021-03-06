\name{labkey.getFolders}
\alias{labkey.getFolders}
\title{Retrieve a list of folders accessible to the current user}
\description{
Fetch a list of all folders accessible to the current user, starting from a given folder.
}
\usage{
labkey.getFolders(baseUrl, folderPath,
    includeSubfolders=FALSE, depth=50)
}
\arguments{
  \item{baseUrl}{a string specifying the address of the LabKey Server, including the context root}
  \item{folderPath}{the starting point for the search.  }
  \item{includeSubfolders}{whether the search for subfolders should recurse down the folder hierarchy}
  \item{depth}{maximum number of subfolder levels to show if includeSubfolders=TRUE}
}
\details{
Folders are a hierarchy of containers for data and files.   The are the place where permissions are set 
in LabKey Server.  The top level in a folder hierarchy is the project.  Below the project is an arbitrary 
hierarchy of folders that can be used to partition data for reasons of security, visibility, and organization.

Folders cut across schemas.  Some schemas, like the lists schema are not visible in a folder that has no list objects 
defined in it. Other schemas are visible in all folders.
}
\value{
The available folders are returned as a three-column data frame containing

\item{name}{the name of the folder}
\item{folderPath}{the full path of the folder from the project root}
\item{effectivePermissions}{the current user's effective permissions for the given folder}

}
\author{Peter Hussey, peter@labkey.com}
\seealso{
{Retrieve data:  } \code{\link{labkey.selectRows}}, \code{\link{makeFilter}}, \code{\link{labkey.executeSql}} \cr
{Modify data:  } \code{\link{labkey.updateRows}}, \code{\link{labkey.insertRows}}, \code{\link{labkey.importRows}}, \code{\link{labkey.deleteRows}}\cr
{List available data: } \code{\link{labkey.getQueries}}, \code{\link{labkey.getQueryViews}}, 
\code{\link{labkey.getQueryDetails}}, \code{\link{labkey.getDefaultViewDetails}}, \code{\link{labkey.getLookupDetails}},
}
\examples{
\dontrun{

## List of folders 
# library(Rlabkey)
folders <- labkey.getFolders(baseUrl="http://localhost:8080/labkey",
    folderPath="/apisamples")
folders

}
}
\keyword{IO}
