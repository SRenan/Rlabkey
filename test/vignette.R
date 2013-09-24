##
#  Copyright (c) 2010 LabKey Corporation
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##

library(Rlabkey)
s<-getSession(baseUrl="http://localhost:8080/labkey", folderPath="/apisamples")
s  # shows schemas


scobj <- getSchema(s, "lists")
scobj   # shows available queries

scobj$AllTypes  ## this is the query object

lkdata<- getRows(s, scobj$AllTypes)  # shorthand for labkey.selectRows, all the same args apply
lkdata

lucols <- getLookups(s, scobj$AllTypes$Category)  # can add fields from related queries
lucols
	
#lucols2 <- getLookups(s, scobj$AllTypes, "Category/Group")  # keep going to other tables 
lucols2 <- getLookups(s, lucols[["Category/Group"]])  # keep going to other tables 

lucols2

errordf <- getRows(s, lucols)

cols <- c(names(scobj$AllTypes)[2:6], names(lucols)[2:4])

simpledf <- getRows(s, scobj$AllTypes, colSelect=paste(cols, sep=","))
simpledf

## some trivial calculations to produce and example analysis result
testtable <- simpledf[,3:4]
row <- c(list("Measure"="colMeans"), colMeans(testtable, na.rm=TRUE))
results <- data.frame(row, row.names=NULL, stringsAsFactors=FALSE)
row <- c(list("Measure"="colSums"), colSums(testtable, na.rm=TRUE))
results <- rbind(results, as.vector(row))

bprops <- list(LabNotes="this is a simple demo")
bpl<- list(name=paste("Batch ", as.character(date())),properties=bprops) 

assayInfo<- saveResults(s, "SimpleMeans", results, batchPropertyList=bpl)

## ls functions
lsProjects("http://www.labkey.org")

lkorg <- getSession("http://www.labkey.org", "/home")
lsFolders(lkorg)

lkorg <- getSession("http://www.labkey.org", "/home/Study/ListDemo")
lsSchemas(lkorg)


## insert, update and delete functions
newrow <- data.frame(
	DisplayFld="Inserted from R"
	, TextFld="how its done"
	, IntFld= 98 
	, DoubleFld = 12.345
	, DateTimeFld = "03/01/2010"
	, BooleanFld= FALSE
	, LongTextFld = "Four score and seven years ago"
#	, AttachmentFld = NA    #attachment fields not supported 
	, RequiredText = "Veni, vidi, vici"
	, RequiredInt = 0
	, Category = "LOOKUP2"
	, stringsAsFactors=FALSE)

insertedRow <- labkey.insertRows("http://localhost:8080/labkey", folderPath="/apisamples",schemaName="lists", queryName="AllTypes", toInsert=newrow)
newRowId <- insertedRow$rows[[1]]$RowId

selectedRow<-labkey.selectRows("http://localhost:8080/labkey", folderPath="/apisamples",schemaName="lists", queryName="AllTypes"
		, colFilter=makeFilter(c("RowId", "EQUALS", newRowId)))
selectedRow

updaterow=data.frame(
	RowId=newRowId
	, DisplayFld="Updated from R"
	, TextFld="how to update"
	, IntFld= 777 
	, stringsAsFactors=FALSE)

updatedRow <- labkey.updateRows("http://localhost:8080/labkey", folderPath="/apisamples",schemaName="lists", queryName="AllTypes", toUpdate=updaterow)
selectedRow<-labkey.selectRows("http://localhost:8080/labkey", folderPath="/apisamples",schemaName="lists", queryName="AllTypes"
		, colFilter=makeFilter(c("RowId", "EQUALS", newRowId)))
selectedRow

deleterow <- data.frame(RowId=newRowId, stringsAsFactors=FALSE)
result <- labkey.deleteRows(baseUrl="http://localhost:8080/labkey", folderPath="/apisamples", schemaName="lists", queryName="AllTypes",  toDelete=deleterow)
result
	
