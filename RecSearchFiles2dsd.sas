
%macro RecSearchFiles2dsd(root_path,filter,perlfuncpath,outdsd,outputfullfilepath);
*options nosource nonotes;
filename indata pipe "perl &perlfuncpath/RecursiveSearchDir4SAS.pl &root_path &filter";
data &outdsd(keep=filefullname);
/*filenames generated by macro DirRecursiveSearch are saved in the temp.txt*/
infile indata lrecl=32767;
input;
filefullname=prxchange("s/\\/\//",-1,_infile_);
output;
run;
%if &outputfullfilepath=0 %then %do;
data &outdsd;
set &outdsd;
filefullname=prxchange("s/^.*\/([^\/\\]+)\.pdf$/$1/",-1,strip(filefullname));
run;
%end;
options source notes;
%mend;

/*
In macro RecSearchFiles2dsd
root_path      =>       Searching directory path
filter         =>       perl rgx to match specific files; . will match all files
perlfuncpath   =>       perl script RecursiveSearchDir4SAS.pl path
outdsd         =>       sas output dataset name 
outputfullfilepath =>   0: only filenames will be output, otherwise let it be 1 or missing;
*/


/*option mprint mlogic symbolgen;*/

/*

%RecSearchFiles2dsd(
root_path=F:/360yunpan/SASCodesLibrary/SAS-Useful-Codes,
filter=.sas$,                                   
perlfuncpath=F:/360yunpan/SASCodesLibrary/SAS-Useful-Codes,
outdsd=m,
outputfullfilepath=1);

*/

