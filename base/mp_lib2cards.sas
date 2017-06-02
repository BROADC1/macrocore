/**
  @file
  @brief Convert all library members to CARDS files
  @details Gets list of members then calls the <code>%mp_ds2cards()</code>
            macro
    usage:

    %mp_lib2cards(lib=sashelp
        , outloc= C:\temp )


  @param lib= Library in which to convert all datasets
  @param outloc= Location in which to store output.  Defaults to WORK library.
    Do not use a trailing slash (my/path not my/path/).  No quotes.
  @param maxobs= limit output to the first <code>maxobs</code> observations

  @version 9.2
  @author Allan Bowe
  @source https://github.com/macropeople/macrocore
  @copyright GNU GENERAL PUBLIC LICENSE v3
**/

%macro mp_lib2cards(lib=
    ,outloc=%sysfunc(pathname(work)) /* without trailing slash */
    ,maxobs=max);

/* FIRST create the cards files */
%local x ds memlist;
proc sql noprint;
select distinct lowcase(memname)
  into: memlist
  separated by ' '
  from dictionary.tables
  where upcase(libname)="%upcase(&lib)";
%do x=1 %to %sysfunc(countw(&memlist));
   %let ds=%scan(&memlist,&x);
   %mp_ds2cards(base_ds=&lib..&ds,tgt_ds=WORK.&ds
      ,cards_file="&outloc/&ds..sas"
      ,maxobs=&maxobs)
%end;

%mend;