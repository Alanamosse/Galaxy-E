#!/usr/bin/env Rscript
source("FunctMainGlmGalaxy.r")### chargement des fonctions / load the functions
##################################################################################################################
################  Data transformation for population evolution trend analyses  function:makeTableAnalyse #########
##################################################################################################################
###########

#delcaration des arguments et variables/ declaring some variables and load arguments

args = commandArgs(trailingOnly=TRUE) #####   par defaut prends les arguments comme du texte !!!! / default behaviour is to take the arguments as text !!!

if (length(args)==0) {
    stop("At least one argument must be supplied, an input dataset file (.tabular).", call.=FALSE) #si pas d'arguments -> affiche erreur et quitte / if no args -> error and exit1

} else {
    ImportduSTOC<-args[1] ###### Nom du fichier importé depuis la base de données STOCeps avec son extension / file name imported from the STOCeps database with the file type ".filetype"    

}

##### Le tableau de données doit posséder 4 variables en colonne: abondance ("abond"), les carrés ou sont réalisés les observatiosn ("carre"), la ou les années des observations ("annee"), et le code de ou des espèces ("espece")
##### Data must be a dataframe with 4 variables in column: abundance ("abond"), plots where observation where made ("carre"), year(s) of the different sampling ("annee"), and the species code ("espece") 


#Import des données / Import data 
data<- read.table(ImportduSTOC,sep="\t",dec=".",header=TRUE) # 
vars_data<-c("carre","annee","espece","abond")
err_msg_data<-"The input dataset filtered doesn't have the right format. It need to have the following 4 variables :\n- carre\n- annee\n- espece\n- abond\n"
check_file(data,err_msg_data,vars_data,4)


## mise en colonne des especes  et rajout de zero mais sur la base des carrés selectionné sans l'import  /  Species are placed in separated columns and addition of zero on plots where at least one selected species is present 

makeTableAnalyse <- function(data) {
    tab <- reshape(data
                  ,v.names="abond"
                  ,idvar=c("carre","annee")      
                  ,timevar="espece"
                  ,direction="wide")
    tab[is.na(tab)] <- 0               ###### remplace les na par des 0 / replace NAs by 0 

    colnames(tab) <- sub("abond.","",colnames(tab))### remplace le premier pattern "abond." par le second "" / replace the column names "abond." by ""
    return(tab)
}



#########
#Do your analysis
tableAnalyse<-makeTableAnalyse(data) #la fonction a un 'return' il faut donc stocker le resultat dans une nouvelle variable

#save the data in a output file in a tabular format
filename <- "Datatransformedforfiltering_trendanalysis.tabular"
write.table(tableAnalyse, filename,row.names=FALSE,sep="\t",dec=".")

cat('exit\n')
