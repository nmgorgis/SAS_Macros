
 %macro delete_all_txt_files_in_folder(folder);
       filename filelist "&folder";
       data _null_;
          dir_id = dopen('filelist');
          total_members = dnum(dir_id);
          do i = 1 to total_members;  
             member_name = dread(dir_id,i);
             if scan(lowcase(member_name),2,'.')='txt' then do; 
              file_id = mopen(dir_id,member_name,'i',0);
              if file_id > 0 then do; 
                freadrc = fread(file_id);
                rc = fclose(file_id);
                rc = filename('delete',member_name,,,'filelist');
                rc = fdelete('delete');
             end;
             rc = fclose(file_id);
          end;
          end;
          rc = dclose(dir_id);
       run;
 %mend;
