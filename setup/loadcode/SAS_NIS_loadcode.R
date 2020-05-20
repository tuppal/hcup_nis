libname NIS'H:\Job\Merck\HCUP_data\NIS\NIS_2008_c'
DATA NIS.NIS_2008_CORE;
INFILE 'H:\Job\Merck\HCUP_data\NIS\NIS_2008\NIS_2008_Core.ASC' LRECL=516;

libname NIS'H:\Job\Merck\HCUP_data\NIS\NIS_2011_c'
DATA NIS.NIS_2011_CORE;
INFILE 'H:\Job\Merck\HCUP_data\NIS\NIS_2011\NIS_2011_Core.ASC' LRECL=516;

libname NIS'H:\Job\Merck\HCUP_data\NIS\NIS_2014_c'
DATA NIS.NIS_2014_CORE;
INFILE 'H:\Job\Merck\HCUP_data\NIS\NIS_2014\NIS_2014_Core.ASC' LRECL=516;

libname NIS'H:\Job\Merck\HCUP_data\NIS\NIS_2016_c'
DATA NIS.NIS_2016_CORE;
INFILE 'H:\Job\Merck\HCUP_data\NIS\NIS_2016\NIS_2016_Core.ASC' LRECL=516;



libname NIS'H:\Job\Merck\HCUP_data\NIS\NIS_2008_c'; 
PROC MEANS data=NIS.NIS_2008_CORE;                                                         
RUN;

libname NIS'H:\Job\Merck\HCUP_data\NIS\NIS_2011_c'; 
PROC MEANS data=NIS.NIS_2011_CORE;                                                         
RUN;

libname NIS'H:\Job\Merck\HCUP_data\NIS\NIS_2014_c'; 
PROC MEANS data= NIS.NIS_2014_CORE;                                                         
RUN;

libname NIS'H:\Job\Merck\HCUP_data\NIS\NIS_2016_c'; 
PROC MEANS data= NIS.NIS_2016_CORE;                                                         
RUN;


