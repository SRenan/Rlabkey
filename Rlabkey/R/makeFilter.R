##
#  Copyright (c) 2008-2012 Fred Hutchinson Cancer Research Center
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

 makeFilter <- function(...)
 {	

 fargs <- list(...)
 flen <- lapply(fargs, function(x) {len <- length(x); if(len<3){stop ("each filter must be of length 3")}})

 	# Determine number of filters
 	fmat <- rbind(...)
 	fcount <- dim(fmat)[1]
 	# Construct filters
 	filters <- array(0, dim=c(fcount,1))
 	for(i in 1:fcount)
 			{	# Match the operator
 				fop  <- switch(EXPR=fmat[i,2],
 								"EQUALS"="eq",
 								"EQUAL"="eq",
 								"NOT_EQUALS"="neq",
 								"NOT_EQUAL"="neq",
 								"NOT_EQUAL_OR_NULL"="neqornull",
 								"NOT_EQUAL_OR_MISSING"="neqornull",
 								"DATE_EQUAL"="dateeq",
 								"DATE_NOT_EQUAL"="dateneq",
 								"DATE_GREATER_THAN_OR_EQUAL"="dategte",
 								"DATE_LESS_THAN_OR_EQUAL"="datelte",
 								"IS_MISSING"="isblank",
 								"MISSING"="isblank",
 								"IS_NOT_MISSING"="isnonblank",
 								"NOT_MISSING"="isnonblank",
 								"GREATER_THAN"="gt",
 								"GREATER_THAN_OR_EQUAL_TO"="gte",
 								"GREATER_THAN_OR_EQUAL"="gte",
 								"LESS_THAN"="lt",
 								"LESS_THAN_OR_EQUAL_TO"="lte",
 								"LESS_THAN_OR_EQUAL"="lte",
 								"CONTAINS"="contains",
 								"DOES_NOT_CONTAIN"="doesnotcontain",
 								"STARTS_WITH"="startswith",
 								"DOES_NOT_START_WITH"="doesnotstartwith",
 								"EQUALS_ONE_OF"="in",
 								"IN"="in",
								"MV_INDICATOR"="hasmvvalue",
								"QC_VALUE"="hasmvvalue",
								"NO_MV_INDICATOR"="nomvvalue",
								"NOT_QC_VALUE"="nomvvalue",
								"EQUALS_NONE_OF"="notin",
								"NOT_IN"="notin",
								"CONTAINS_ONE_OF"="containsoneof",
								"CONTAINS_NONE_OF"="containsnoneof")
								
 				if(is.null(fop)==TRUE) stop ("Invalid operator name.")
 				# url encode column name and value
 				colnam <- curlEscape(fmat[i,1])
 				fvalue <- curlEscape(fmat[i,3])
 				filters[i] <- paste(colnam,"~",fop,"=",fvalue,sep="")
 			}

 	return(filters)
 }



