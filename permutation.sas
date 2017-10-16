  %macro permute(r) / parmbuff;      /* the parmbuff option assigns */
      %let i=2;               /* the invocation parameter list to the */
      %let things=;                       /* macro variable &syspbuff */
      %do %while (%Qscan(&syspbuff,&i,%STR(,%))) ne );  /* scan the syspbuff */
         %let p&i="%Qscan(&syspbuff,&i,%STR(,%)))";  /* to determine r */
        %if &i=2 %then %let things=&&p&i;     /* and count the number */
        %else %let things=&things,&&p&i;            /* of elements, n */
        %let i=%eval(&i+1);
      %end;
      %let n=%eval(&i-2);
      data permute;
         drop i j copy;
         array check (*) $ 10 r1-r&r;          /* create a total of r */
          %do m=1 %to &r;                   /* variables  for looping */
            do r&m = &things;
          %end;
          copy=0;
            do i=2 to &r;                 /* look for duplicate items */
              do j=1 to i-1;              /* and keep the unique ones */
                if check(j)=check(i) then copy+1;
              end;
            end;
          if copy = 0 then output;        /* writes to a SAS data set */
          if copy = 0 then put r1-r&r;        /* writes to the log    */
          %do m=1 %to &r;
            end;                               /* end the r DO LOOPS */
          %end;
        run;
       proc print uniform data=permute;
            title "permutations of &n items taken &r at a time ";
            run;
     %mend permute;
%macro combo(r)/parmbuff;

      %let i=2;
      %let things=;
      %do %while (%Qscan(&syspbuff,&i,%STR(,%))) ne );
        %let p&i="%Qscan(&syspbuff,&i,%STR(,%)))";
        %if &i=2 %then %let things=&&p&i;
        %else %let things=&things,&&p&i;
        %let i=%eval(&i+1);
      %end;
      %let n=%eval(&i-2);
       data combo;
            keep v1-v&r;
            array word $8  w1-w&n (&things);
            array rr (*) r1-r&r;
            array v $8  v1-v&r;
           %do i=1 %to &r;                    /* create the DO LOOPs */
             %if &i=1 %then %do;
               do r&i=1 to &n-(&r-&i);
               %end;
             %else %do;
               do r&i=r%eval(&i-1)+1 to &n-(&r-&i);
               %end;
             %end;
               do k=1 to &r;              /* select subscripted items */
               v(k)=word (rr(k));               /* for a SAS data set */
               put v(k)      '  ' @;                       /* for log */
               end;
               put;                                  /* writes to log */
               output;                    /* writes to a SAS data set */
           %do i=1 %to &r;
             end;                     /* create ENDs for the DO LOOPs */
             %end;
            put;
            run;
         proc print uniform data=combo;
            title "combinations of &n items taken &r at a time ";
            run;
       %mend combo;
