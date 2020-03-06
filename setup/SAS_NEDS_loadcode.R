libname NEDS'H:\Job\Merck\HCUP_data\NEDS\NEDS_2008_c';
DATA NEDS.NEDS_2008_CORE;
INFILE 'H:\Job\Merck\HCUP_data\NEDS\NEDS_2008\NEDS_2008_Core.CSV' LRECL=516;

libname NEDS'H:\Job\Merck\HCUP_data\NEDS\NEDS_2011_c';
DATA NEDS.NEDS_2011_CORE;
INFILE 'H:\Job\Merck\HCUP_data\NEDS\NEDS_2011\NEDS_2011_Core.CSV' LRECL=516;

libname NEDS'H:\Job\Merck\HCUP_data\NEDS\NEDS_2014_c';
DATA NEDS.NEDS_2014_CORE;
INFILE 'H:\Job\Merck\HCUP_data\NEDS\NEDS_2014\NEDS_2014_Core.CSV' LRECL=516;

libname NEDS'H:\Job\Merck\HCUP_data\NEDS\NEDS_2016_c';
DATA NEDS.NEDS_2016_CORE;
INFILE 'H:\Job\Merck\HCUP_data\NEDS\NEDS_2016\NEDS_2016_Core.CSV' LRECL=516;



libname NEDS'H:\Job\Merck\HCUP_data\NEDS\NEDS_2008_c'; 
PROC MEANS data=NEDS.NEDS_2008_CORE;                                                         
RUN;

libname NEDS'H:\Job\Merck\HCUP_data\NEDS\NEDS_2011_c'; 
PROC MEANS data=NEDS.NEDS_2011_CORE;                                                         
RUN;

libname NEDS'H:\Job\Merck\HCUP_data\NEDS\NEDS_2014_c'; 
PROC MEANS data= NEDS.NEDS_2014_CORE;                                                         
RUN;

libname NEDS'H:\Job\Merck\HCUP_data\NEDS\NEDS_2016_c'; 
PROC MEANS data= NEDS.NIS_2016_CORE;                                                         
RUN;
