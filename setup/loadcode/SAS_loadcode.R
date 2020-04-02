libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2008'; 
DATA MDsedd.MD_seddC_2008_CORE;                                                         
INFILE 'C:\Users\TUPPAL\merck\sedd\MD\2008\MD_sedd_2008_CORE.ASC' LRECL = 665;  

libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2011'; 
DATA MDsedd.MD_seddC_2011_CORE;                                                         
INFILE 'C:\Users\TUPPAL\merck\sedd\MD\2011\MD_sedd_2011_CORE.ASC' LRECL = 665;  

libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2014'; 
DATA MDsedd.MD_seddC_2014_CORE;                                                         
INFILE 'C:\Users\TUPPAL\merck\sedd\MD\2014\MD_sedd_2014_CORE.ASC' LRECL = 665;  

libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2017'; 
DATA MDsedd.MD_seddC_2017_CORE;                                                         
INFILE 'C:\Users\TUPPAL\merck\sedd\MD\2017\MD_sedd_2017_CORE.ASC' LRECL = 665;  

libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2016'; 
DATA MDsedd.MD_seddC_2016_CORE;                                                         
INFILE 'H:\Job\Merck\HCUP_data\hcup_asc\SEDD\MD\2016\MD_sedd_2016_CORE.ASC' LRECL = 665;  



libname MDsedd'C:\Users\TUPPAL\merck\2008'; 
PROC MEANS data=MDsedd.MD_seddC_2008_CORE;                                                         
RUN;

libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2011'; 
PROC MEANS data=MDsedd.MD_seddC_2011_CORE;                                                         
RUN;

libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2014'; 
PROC MEANS data= MDsedd.MD_seddC_2014_CORE;                                                         
RUN;

libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2017'; 
PROC MEANS data= MDsedd.MD_seddC_2017_CORE;                                                         
RUN;

libname MDsedd'C:\Users\TUPPAL\merck\sedd\MD_c\2016'; 
PROC MEANS data= MDsedd.MD_seddC_2016_CORE;                                                         
RUN;