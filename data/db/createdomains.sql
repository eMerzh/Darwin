create domain :dbname.genders as char(1) 
       constraint genders_chk
                  check (VALUE in ('M', 'F'));
create domain :dbname.full_text_language as varchar default 'simple' not null
       constraint full_text_language_chk
                  check (VALUE in ('danish', 'dutch', 'english', 'finnish', 'french', 'german', 'hungarian', 'italian', 'norwegian', 'portuguese', 'romanian', 'russian', 'spanish', 'swedish', 'turkish', 'simple'));
create domain :dbname.date_day as smallint
       constraint date_day_chk
                  check (VALUE between 1 and 31);
create domain :dbname.date_month as smallint
       constraint date_month_chk
                  check (VALUE between 1 and 12);
create domain :dbname.date_year as smallint
       constraint date_year_chk
                  check (VALUE between 1500 and 2100);
create domain :dbname.update_date_time as timestamp default now() not null;
create domain :dbname.classifications_ids as integer default 0 not null;
create domain :dbname.classifications_names as varchar default '/' not null;
