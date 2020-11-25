/**************************/
/****  Input the data  ****/
/**************************/

data baseball;
infile "C:\Users\pchachlani\STAT8678\BBRawData.txt";
input salary 1-4 avg 6-10 OBP 12-16 
      Runs 18-20 Hits 22-24 Doubles 26-27 
      Triples 29-30 HRs 32-33 RBI 35-37 
      Walks 39-41 SOs 43-45 SBs 47-48 
      Errors 50-51  FA_Eligible 53 
	  FA_9192 55 Arb_Eligible 57 Arb_9192 59 
      Full_Name $61-79;  
run;

proc print data=baseball (obs=10);
run;

/******************************/
/**** Exploratory analyses ****/
/******************************/

/**** univariate analyses and graphs of numeric variable "salary" ****/
proc means data=baseball;
var salary;
run;

proc univariate data=baseball plots;
var salary;
run;

proc sgplot data=baseball;
histogram salary;
run;

/**** Explore categorical variables ****/
proc freq data=baseball;
table FA_Eligible;
table FA_Eligible*FA_9192;
run;

proc freq data=baseball;
table FA_Eligible*Arb_Eligible;
run;



/**** explore the correlation between "salary" and several numeric variables ****/
proc corr data=baseball plots=matrix;
var avg runs hits;
with salary;
run;

proc sgplot data=baseball;
scatter x=avg y=salary;
run;

/**** explore the relationship between "salary" and categorical variable "FA_Eligible" ****/
proc means data=baseball;
var salary;
class FA_Eligible;
run;


proc sgplot data=baseball;
vbox salary /group=FA_Eligible;
run;


/**** Transform salary ****/
data baseball;
set baseball;
log_salary=log(salary);
run;

proc univariate data=baseball plots;
var log_salary avg;
run;

/**** Try to correlate different variables with "log_salary" ****/
/**** Note this might not be suitable for 0/1 variables here ****/
proc corr data=baseball;
var avg OBP Runs Hits Doubles 
    Triples HRs  RBI  Walks 
    SOs SBs Errors    FA_Eligible  
    FA_9192 Arb_Eligible Arb_9192;
with log_salary;
run;
 
/**** display the relationship between "log_salary" and "avg"/"RBI" by group ****/
proc sgplot data=baseball;
scatter x=avg y=log_salary/group=FA_Eligible;
loess x=avg y=log_salary/group=FA_Eligible;
run;

proc sgplot data=baseball;
scatter x=RBI y=log_salary/group=FA_Eligible;
loess x=RBI y=log_salary/group=FA_Eligible;
run;

/**** One-sample t-test ****/
proc ttest data=baseball; *possible options here: h0= side= alpha=;
var avg;
run;

/**** Two-sample t-tests ****/
proc ttest data=baseball;
var log_salary;
class FA_Eligible;
run;

proc ttest data=baseball;
var avg;
class FA_Eligible;
run;

/**** Paired t-tests ****/
proc ttest data=baseball;
paired Triples*HRs;
run;

/**** Simple linear regression ****/
proc reg data=baseball;
model log_salary=RBI;
run;

/**** or use PROC GLM ****/
proc glm data=baseball;
model log_salary=RBI;
run;

/**** Linear regression with more than one predictor ****/
proc glm data=baseball;
model log_salary=runs hits;
run;

/**** collin: output results for detecting collinearity ****/
/**** selection=RSQUARE: rank all possible models according to R^2 (note a good idea) ****/
/**** so output aic bic cp adjrsq for comparison        ****/
proc reg data=baseball;
model log_salary=runs hits FA_Eligible walks RBI SOs/collin selection=RSQUARE aic bic cp adjrsq;
run;











