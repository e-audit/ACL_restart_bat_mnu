*
COMMENT 
*********** ENGLISH ********************* GENEREL INFORMATION ABOUT THE SCRIPT ********************************
* 
 Description:   The script gives information about ACL and the content of the table. 
*
 Version:       ACL version 9.2.1 and 9.3.0
*
 Purpose:       The purpose of the script is:
                - help script developers with information about ACL and content of table.
*
 Preconditions: English version of ACL.
*
 Input:         Screen dialog.
                - Open if not already open.
*
 Output:        Get result - write DISP VAR in Command Line.
*
*
 Date:          Developed: 2011-03-24
                Updated  : 2011-06-07 Version 1.1 -  Information about record length, display date and time,
                                                     type, start position and length on fields added.
                           2011-11-14 Version 1.2 -  Information about decimal symbol.
                           2011-11-17 Version 1.3 -  More field information added.
                           2012-05-14 Version 1.4 -  Table information added.
                           2012-06-08 Version 1.5 -  View information added.
                           2012-06-15 Version 1.6 -  User settings EXACT ON OFF added. 
                                                     Run with or without EXACT ON/OFF.
                                                     Problem running script if project name have spaces - solved.
                           2012-08-07 Version 1.7 -  Problem with views - solved
                           2012-10-01 Version 1.8 -  Information about logfile and active filter added.
                           2012-10-12 Version 1.9 -  Content of first record and project path added (v_GetFieldContentOfFirstRecord and v_GetOpenProjectPath)
                           2012-11-16 Version 1.10 - Problem with view filter solved
                           2012-11-21 Version 1.11 - Problem with view filter solved (hopefully)
*
 Version:       1.11
*
 Developer:     Contact person: Erling T Petersen, Denmark, erling.petersen@skat.dk
*
 Copyright:     The script is made to help script developers in the Danish Tax Administration.
                It is permissible to copy all or parts of the script, if you send an email to 
                erling.petersen@skat.dk. It's free.
                Please send an email to erling.petersen@skat.dk if you use the script, or have 
                suggestions for improvement. 
                It's nice to know if the script is being used.
*
END


COMMENT 
*********** DANISH ********************* GENEREL INFORMATION OM SCRIPTET ********************************
*
 Beskrivelse:   Scriptet giver information om ACL og indholdet i en tabel.
*
 Version:       ACL version 9.2.1 and 9.3.0
*
 Formål:        Formål med scriptet er:
                - hjælpe scriptudviklere med information om ACL og tabelindhold.
*
 Forudsætning:  Ingen
*
 Input:         Skærmdialog.
                - Åben tabel, hvis den ikke allerede er åben.
*
 Output:        Resultat får man ved at skrive DISP VAR i kommandolinien.
*
*
 Applications:  Scriptet er placeret i programkataloget, og man køre scriptet ved at skrive:
                DO SCRIPT Func_v_GetACLandTableInfo
                (Get ACL and Table Info)
*
 Dato:          Udviklet:  2011-03-24
                Opdateret: 2011-06-07 Version 1.1 -  Oplysninger med recordlængde, display dato og tid,
                                                     type, start position og længde på felter tilføjet.
                           2011-11-14 Version 1.2 -  Information om decimaltegn.
                           2011-11-17 Version 1.3 -  Flere feltinformationer tilføjet.
                           2012-05-14 Version 1.4 -  Tabel information tilføjet.
                           2012-06-08 Version 1.5 -  View information tilføjet.
                           2012-06-15 Version 1.6 -  Brugeropsætning tilføjget - EXACT ON OFF added. 
                                                     Script kører med og uden EXACT ON/OFF.
                                                     Problem med at køre script, hvis der er mellemrum i projekt navn - løst.
                           2012-08-07 Version 1.7 -  Problem med views - løst.
                           2012-10-01 Version 1.8 -  Information om logfile og aktive filter tilføjet.
                           2012-10-12 Version 1.9 -  Information om indhold i første record og projekt sti
                           2012-11-16 Version 1.10 - Problem med view filter løst
                           2012-11-21 Version 1.11 - Problem med view filter løst (forhåbentlig)
*
 Version:       1.11
*
 Udviklet af:   Arbejdsgruppe: Scripts og makroer
                Kontaktperson: Erling T Petersen, W00055. Email: erling.petersen@skat.dk
*
 Copyright:     Det er tilladt at kopiere hele eller dele scriptet, hvis du sender en email til 
                erling.petersen@skat.dk. Det er gratis.
                Send venligtst en e-mail til erling.petersen@skat.dk, hvis du bruger scriptet, eller har
                forbedringsforslag. Det er rart at vide, om de script man laver, bliver brugt.
*
END


COMMENT *************************** SCRIPT START ************************************************

SAVE

DELETE SCRIPT e_audit_GetACLandTableInfo OK

COMMENT --- Begin --- Delete temporary log ----
DELETE w55_tmp_log.log OK
COMMENT --- End --- Delete temporary log ----

COMMENT --- Begin --- Delete variables ----
DO SCRIPT e_audit_DEL_GetACLandTableInfo
COMMENT --- End ----- Delete variables ----

COMMENT --- Begin --- Get language ----
DO SCRIPT Func_v_GetLanguage
COMMENT --- End --- Get language ----

SET SAFETY OFF


COMMENT --- Begin ---------- Dialog 1 --------------------------------------

COMMENT --- Begin -- EN -----
IF v_default_language='EN' v_dialog_01_title      ='Select table'

IF v_default_language='EN' v_dialog_01_line_01    ='Select table:'
COMMENT --- End -- EN -----


COMMENT --- Begin -- DA -----
IF v_default_language='DA' v_dialog_01_title      ='Vælg tabel'

IF v_default_language='DA' v_dialog_01_line_01    ='Vælg tabel:'
COMMENT --- End -- DA -----

COMMENT --- Begin -- DE -----
IF v_default_language='DE' v_dialog_01_title      ='Wallen Sie Tabellen'

IF v_default_language='DE' v_dialog_01_line_01    ='Wallen Sie Tabellen:'
COMMENT --- End -- DE -----

COMMENT --- End ------------ Dialog 1 --------------------------------------





COMMENT --- Begin --- Create temporary log and display ----
SET LOG TO w55_tmp_log
SET ECHO ON
Display
DISP OPEN
DISP VER
CALC dec(22 11)/7
SET ECHO NONE
SET LOG OFF
COMMENT --- End --- Create temporary log and display ----


COMMENT --- Begin --- Make temporary format ----

DIR C:\w55.* TO TMP_C_DREV
OPEN TMP_C_DREV
DEFINE FIELD TMP_LINE COMPUTED BLANKS(2000)
EXTRACT TMP_LINE FIRST 1 to W55_TMP_FORMAT_2000
COMMENT --- End --- Make temporary format ----

OPEN w55_tmp_log.log FORMAT W55_TMP_FORMAT_2000 CRLF


COMMENT --- Begin --- Get version information ----
LOCATE if Find('<build>')
v_GetVersionBuild=ALLTRIM(INCLUDE(TMP_LINE '0987654321'))

LOCATE if Find('<version_type>')
v_GetVersionType=ALLTRIM(INCLUDE(TMP_LINE '0987654321'))

LOCATE if Find('<patch>')
v_GetVersionPatch=ALLTRIM(INCLUDE(TMP_LINE '0987654321'))

LOCATE if Find('<minor>')
v_GetVersionMinor=ALLTRIM(INCLUDE(TMP_LINE '0987654321'))

LOCATE if Find('<major>')
v_GetVersionMajor=ALLTRIM(INCLUDE(TMP_LINE '0987654321'))

COMMENT --- End ----- Get version information ----


COMMENT --- Begin --- Get decimal symbol ----

LOCATE if FIND('14285714286' TMP_LINE)
v_GetDecimalSymbol=Substr(ALLTRIM(TMP_LINE) 2 1)


COMMENT --- END ----- Get decimal symbol ----


COMMENT --- Begin ---- Get user settings Exact ON or OFF ---------------

SET FILTER TMP_LINE = " 3.1428571428"
COUNT
if COUNT1 =1 v_GetUserSetExactOnOff='OFF'
if COUNT1 =0 v_GetUserSetExactOnOff='ON'

SET FILTER
COMMENT --- END ---- Get user settings Exact ON or OFF ---------------


COMMENT --- Begin --- Set Exact off if it is on ----------------------

IF v_GetUserSetExactOnOff='ON' SET EXACT OFF

COMMENT --- End -__-- Set Exact off if it is on ----------------------


COMMENT --- Begin --- Get open project name ----

LOCATE if find('.ACL is currently open')

v_GetOpenProjectName=ALLTRIM(SPLIT(SUBSTR(TMP_LINE 6 32) '.ACL' 1))+'.ACL'
v_GetOpenProjectName2=ALLTRIM(REPLACE(ALLTRIM(SPLIT(SUBSTR(TMP_LINE 6 32) '.ACL' 1))+'.ACL' '.ACL' '.AC'))

COMMENT --- End ----- Get open project name ----


COMMENT --- Begin --- Get date format ----
DEFINE FIELD DF_Date COMPUTED CTOD('44771122' 'yyyymmdd')
v_df_date=Alltrim(DATE(DF_date))
v_GetDateFormat=Blanks(20)
v_len_date=LENGTH(ALLTRIM(INCLUDE('%v_df_date%' '0987654321')))
GROUP if match(v_len_date 6 8) and not find('nov' v_df_date)
  v_GetDateFormat=REPLACE(v_df_date '44' 'YY')
  v_GetDateFormat=REPLACE(v_GetDateFormat '77' 'YY')
  v_GetDateFormat=REPLACE(v_GetDateFormat '11' 'MM')
  v_GetDateFormat=REPLACE(v_GetDateFormat '22' 'DD')
ELSE if v_len_date=7 and not find('nov' v_df_date)
  v_GetDateFormat=REPLACE(v_df_date '4477' 'YYYY')
  v_GetDateFormat=REPLACE(v_GetDateFormat '1' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '2' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '3' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '4' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '5' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '6' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '7' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '8' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '9' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '0' 'D')
ELSE if v_len_date=5 and not find('nov' v_df_date)
  v_GetDateFormat=REPLACE(v_df_date '77' 'YY')
  v_GetDateFormat=REPLACE(v_GetDateFormat '1' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '2' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '3' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '4' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '5' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '6' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '7' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '8' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '9' 'D')
  v_GetDateFormat=REPLACE(v_GetDateFormat '0' 'D')
ELSE if find('nov' v_df_date)
  v_GetDateFormat=REPLACE(v_df_date '44' 'YY')
  v_GetDateFormat=REPLACE(v_GetDateFormat '77' 'YY')
  v_GetDateFormat=REPLACE(v_GetDateFormat 'Nov' 'MMM')
  v_GetDateFormat=REPLACE(v_GetDateFormat '22' 'DD')
END

v_GetDateFormat=ALLTRIM(v_GetDateFormat)

DELETE DF_Date OK
DELETE v_df_date OK
DELETE v_len_date OK
COMMENT --- End --- Get date format ----



COMMENT --- Begin --- Get open tabelname ----

LOCATE IF FIND('is your primary file.')
v_GetOpenTableName=ALLTRIM(REPLACE(ALLTRIM(SPLIT(ALLTRIM(SPLIT(TMP_LINE '(format ' 2)) ')' 1)) ' ' '_'))

COMMENT --- End --- Get open tabelname ----


COMMENT --- Begin ----------------------- Get tablename from user - Dialog boxes ------------------------------------------

if ISBLANK(v_GetOpenTableName) DIALOG (DIALOG TITLE "%v_dialog_01_title%" WIDTH 453 HEIGHT 173 ) (BUTTONSET TITLE "&OK;&Cancel" AT 360 24 DEFAULT 1 ) (TEXT TITLE "%v_dialog_01_line_01%" AT 24 28 WIDTH 296 ) (ITEM TITLE "f" TO "v_table" AT 24 48 WIDTH 301 )
if ISBLANK(v_GetOpenTableName) v_GetOpenTableName=v_table
OPEN "%v_GetOpenTableName%"

COMMENT --- End ------------------------- Get tablename from user - Dialog boxes ------------------------------------------


COMMENT --- Begin --- Delete temporary log ----
DELETE w55_tmp_log.log OK
COMMENT --- End --- Delete temporary log ----


COMMENT --- Begin --- Create temporary log and display ----
SET LOG to w55_tmp_log
SET ECHO ON
Display
SET ECHO NONE
SET LOG OFF
COMMENT --- End --- Create temporary log and display ----


OPEN w55_tmp_log.log FORMAT W55_TMP_FORMAT_2000 CRLF


COMMENT --- Begin --- Get open file name ----

LOCATE IF FIND('is your primary file.')
v_GetOpenFileName=ALLTRIM(SUBSTR(ALLTRIM(SPLIT(TMP_LINE ' (format ' 1)) 1 256))

COMMENT --- End ----- Get open file name ----



COMMENT --- Begin --- Get display date and time ----

COUNT
LOCATE IF RECNO()=COUNT1
v_GetDisplayDate=ALLTRIM(SUBSTR(TMP_LINE AT(1 '-' TMP_LINE)+1 32))
v_GetDisplayTime=SUBSTR(TMP_LINE 1 8)

COMMENT --- End ----- Get display date and time ----


COMMENT --- Begin --- Get record length ----

LOCATE IF FIND('</reclen>')
v_GetRecordLength=VALUE(SUBSTR(ALLTRIM(INCLUDE(TMP_LINE '0987654321')) 1 32) 0)
SET FILTER

COMMENT --- End ----- Get record length ----


COMMENT --- Begin --- Get field information ----

LOCATE IF TMP_LINE = '<fields>'
v_start_record_fields=RECNO()+1

LOCATE IF TMP_LINE = '</fields>'
v_end_record_fields=RECNO()-1

EXT TMP_LINE to w55_ext_field_info IF BETWEEN(RECNO() v_start_record_fields v_end_record_fields) OPEN
v_field_record_count=WRITE1
v_number_of_loop=1

DELETE w55_exp_field_into_all.txt OK


EXPORT "LOCATE RECORD v_number_of_loop" FIRST 1 to w55_sub_get_fieldnames.bat 
EXPORT "v_tmp_line_content=ALLTRIM(TMP_LINE)" FIRST 1 to w55_sub_get_fieldnames.bat APPEND
EXPORT "if v_tmp_line_content='<field>' v_tmp_line=''" FIRST 1 to w55_sub_get_fieldnames.bat APPEND
EXPORT "v_tmp_line=ALLTRIM(v_tmp_line)+v_tmp_line_content" FIRST 1 to w55_sub_get_fieldnames.bat APPEND
EXPORT "EXPORT ALLTRIM(v_tmp_line) AS 'TMP_LINE' ASCII to w55_exp_field_into_all IF v_tmp_line_content='</field>' AND RECNO()=v_number_of_loop APPEND" FIRST 1 to w55_sub_get_fieldnames.bat APPEND
EXPORT "v_number_of_loop=v_number_of_loop+1" FIRST 1 to w55_sub_get_fieldnames.bat APPEND



DO w55_sub_get_fieldnames WHILE v_number_of_loop<=v_field_record_count

DELETE BATCH w55_sub_get_fieldnames OK
DELETE w55_sub_get_fieldnames.bat OK

DELETE FORMAT w55_ext_field_info OK
DELETE w55_ext_field_info.fil OK

DELETE v_number_of_loop OK
DELETE v_tmp_line OK
DELETE v_tmp_line_content OK
DELETE v_field_record_count OK
DELETE v_start_record_fields OK
DELETE v_end_record_fields OK


OPEN w55_exp_field_into_all.txt FORMAT W55_TMP_FORMAT_2000 CRLF

DEFINE FIELD w55_fieldname COMPUTED ALLTRIM(SUBSTR(ALLTRIM(SPLIT(SPLIT(TMP_LINE '<name>' 2) '</name>' 1)) 1 32))
DEFINE FIELD w55_fieldnametype COMPUTED ALLTRIM(SUBSTR(ALLTRIM(SPLIT(SPLIT(TMP_LINE '<type>' 2) '</type>' 1)) 1 10))
DEFINE FIELD w55_fieldnamestartpos COMPUTED ALLTRIM(SUBSTR(ALLTRIM(SPLIT(SPLIT(TMP_LINE '<start>' 2) '</start>' 1)) 1 5))
DEFINE FIELD w55_fieldnamelength COMPUTED ALLTRIM(SUBSTR(ALLTRIM(SPLIT(SPLIT(TMP_LINE '<length>' 2) '</length>' 1)) 1 5))
DEFINE FIELD w55_fieldnamedecimals COMPUTED ALLTRIM(SUBSTR(ALLTRIM(SPLIT(SPLIT(TMP_LINE '<decimals>' 2) '</decimals>' 1)) 1 5))
DEFINE FIELD w55_fieldnamedescription COMPUTED ALLTRIM(REPLACE(REPLACE(SUBSTR(ALLTRIM(SPLIT(SPLIT(TMP_LINE '<description>' 2) '</description>' 1)) 1 256) '&quot;' '') '&apos;' ''))
DEFINE FIELD w55_fieldnameexpression COMPUTED ALLTRIM(REPLACE(REPLACE(SUBSTR(ALLTRIM(SPLIT(SPLIT(TMP_LINE '<expression>' 2) '</expression>' 1)) 1 256) '&quot;' '') '&apos;' ''))

EXT w55_fieldname w55_fieldnametype w55_fieldnamestartpos w55_fieldnamelength w55_fieldnamedecimals w55_fieldnamedescription w55_fieldnameexpression to ext_w55_tmp_fieldnames OPEN

v_GetFieldnames=BLANKS(3000)
v_GetFieldnamesType=BLANKS(3000)
v_GetFieldnamesStartPos=BLANKS(1000)
v_GetFieldnamesLength=BLANKS(1000)
v_GetFieldnamesDecimals=BLANKS(1000)
v_GetFieldnamesDescription=BLANKS(3000)
v_GetFieldnamesExpression=BLANKS(3000)



GROUP
   v_GetFieldnames=ALLTRIM(v_GetFieldnames)+'#'+w55_fieldname
   v_GetFieldnamesType=ALLTRIM(v_GetFieldnamesType)+'#'+w55_fieldnametype
   v_GetFieldnamesStartPos=ALLTRIM(v_GetFieldnamesStartPos)+'#'+w55_fieldnamestartpos
   v_GetFieldnamesLength=ALLTRIM(v_GetFieldnamesLength)+'#'+w55_fieldnamelength
   v_GetFieldnamesDecimals=ALLTRIM(v_GetFieldnamesDecimals)+'#'+w55_fieldnamedecimals
   v_GetFieldnamesDescription=ALLTRIM(v_GetFieldnamesDescription)+'#'+w55_fieldnamedescription
   v_GetFieldnamesExpression=ALLTRIM(v_GetFieldnamesExpression)+'#'+w55_fieldnameexpression
END

v_GetFieldnames=ALLTRIM(SUBSTR(v_GetFieldnames 2 3000))
v_GetFieldnamesType=ALLTRIM(SUBSTR(v_GetFieldnamesType 2 3000))
v_GetFieldnamesStartPos=ALLTRIM(SUBSTR(v_GetFieldnamesStartPos 2 1000))
v_GetFieldnamesLength=ALLTRIM(SUBSTR(v_GetFieldnamesLength 2 1000))
v_GetFieldnamesDecimals=ALLTRIM(SUBSTR(v_GetFieldnamesDecimals 2 1000))
v_GetFieldnamesDescription=ALLTRIM(SUBSTR(v_GetFieldnamesDescription 2 3000))
v_GetFieldnamesExpression=ALLTRIM(SUBSTR(v_GetFieldnamesExpression 2 3000))


DELETE ext_w55_tmp_fieldnames.fil OK
DELETE FORMAT ext_w55_tmp_fieldnames OK

COMMENT --- End ----- Get field information ----




COMMENT --- Begin --- Get number of FTYPE ------

OPEN "%v_GetOpenTableName%"

v_GetNumberOfChar=0
v_GetNumberOfNumeric=0
v_GetNumberOfDate=0
v_GetNumberOfLogical=0
v_GetCharFields=BLANKS(3000)
v_GetNumericFields=BLANKS(3000)
v_GetDateFields=BLANKS(3000)
v_GetLogicalFields=BLANKS(3000)

v_number_of_loop=1
v_GetNumberOfFields=OCCURS(v_GetFieldnames '#')+1

GROUP FIRST 1
  LOOP WHILE v_number_of_loop <= v_GetNumberOfFields
    v_GetNumberOfChar=v_GetNumberOfChar+1 if ALLTRIM(FTYPE(SPLIT(v_GetFieldnames '#' v_number_of_loop)))='C'
    v_GetCharFields=ALLTRIM(v_GetCharFields)+'#'+ALLTRIM(SPLIT(v_GetFieldnames '#' v_number_of_loop)) if ALLTRIM(FTYPE(SPLIT(v_GetFieldnames '#' v_number_of_loop)))='C'
    v_GetNumberOfNumeric=v_GetNumberOfNumeric+1 if ALLTRIM(FTYPE(SPLIT(v_GetFieldnames '#' v_number_of_loop)))='N'
    v_GetNumericFields=ALLTRIM(v_GetNumericFields)+'#'+ALLTRIM(SPLIT(v_GetFieldnames '#' v_number_of_loop)) if ALLTRIM(FTYPE(SPLIT(v_GetFieldnames '#' v_number_of_loop)))='N'
    v_GetNumberOfDate=v_GetNumberOfDate+1 if ALLTRIM(FTYPE(SPLIT(v_GetFieldnames '#' v_number_of_loop)))='D'
    v_GetDateFields=ALLTRIM(v_GetDateFields)+'#'+ALLTRIM(SPLIT(v_GetFieldnames '#' v_number_of_loop)) if ALLTRIM(FTYPE(SPLIT(v_GetFieldnames '#' v_number_of_loop)))='D'
    v_GetNumberOfLogical=v_GetNumberOfLogical+1 if ALLTRIM(FTYPE(SPLIT(v_GetFieldnames '#' v_number_of_loop)))='L'
    v_GetLogicalFields=ALLTRIM(v_GetLogicalFields)+'#'+ALLTRIM(SPLIT(v_GetFieldnames '#' v_number_of_loop)) if ALLTRIM(FTYPE(SPLIT(v_GetFieldnames '#' v_number_of_loop)))='L'
    v_number_of_loop=v_number_of_loop+1
  END
END


v_GetCharFields=ALLTRIM(SUBSTR(v_GetCharFields 2 3000))
v_GetNumericFields=ALLTRIM(SUBSTR(v_GetNumericFields 2 3000))
v_GetDateFields=ALLTRIM(SUBSTR(v_GetDateFields 2 3000))
v_GetLogicalFields=ALLTRIM(SUBSTR(v_GetLogicalFields 2 3000))


DELETE v_number_of_loop OK


COMMENT --- End ----- Get number of FTYPE ------


COMMENT --- Begin --- Get field content of first record ----
LOCATE FIRST 1

EXPORT "    v_new_fieldname='v_FIELDNUM'+ALLTRIM(STRING(v_count_fieldnumber 15))                                                         " FIRST 1 TO w55_make_content_text.bat
EXPORT "    v_fieldname=ALLTRIM(SPLIT(v_GetFieldNames '#' v_count_fieldnumber))                                                          " FIRST 1 TO w55_make_content_text.bat APPEND
EXPORT "    %"+"v_new_fieldname"+"%=%"+"v_fieldname"+"%                                                                                  " FIRST 1 TO w55_make_content_text.bat APPEND
EXPORT "    if FTYPE(v_fieldname)='C' v_fieldnames_content=ALLTRIM(v_fieldnames_content)+'#'+%"+"v_new_fieldname"+"%                     " FIRST 1 TO w55_make_content_text.bat APPEND
EXPORT "    if FTYPE(v_fieldname)='L' v_fieldnames_content=ALLTRIM(v_fieldnames_content)+'#T' IF %"+"v_fieldname"+"%=T                   " FIRST 1 TO w55_make_content_text.bat APPEND
EXPORT "    if FTYPE(v_fieldname)='L' v_fieldnames_content=ALLTRIM(v_fieldnames_content)+'#F' IF %"+"v_fieldname"+"%=F                   " FIRST 1 TO w55_make_content_text.bat APPEND
EXPORT "    if FTYPE(v_fieldname)='N' v_fieldnames_content=ALLTRIM(v_fieldnames_content)+'#'+ALLTRIM(STRING(%"+"v_new_fieldname"+"% 12)) " FIRST 1 TO w55_make_content_text.bat APPEND
EXPORT "    if FTYPE(v_fieldname)='D' v_fieldnames_content=ALLTRIM(v_fieldnames_content)+'#'+ALLTRIM(DATE(%"+"v_new_fieldname"+"%))      " FIRST 1 TO w55_make_content_text.bat APPEND
EXPORT "    v_count_fieldnumber=v_count_fieldnumber+1                                                                                    " FIRST 1 TO w55_make_content_text.bat APPEND

v_count_fieldnumber=1
v_number_of_blanks=v_GetRecordLength+v_GetNumberOfFields+1
v_fieldnames_content=BLANKS(v_number_of_blanks)

DO w55_make_content_text WHILE v_count_fieldnumber<=v_GetNumberOfFields

DELETE SCRIPT w55_make_content_text OK
DELETE w55_make_content_text.bat OK

EXPORT "    v_del_variable='v_FIELDNUM'+ALLTRIM(STRING(v_count_fieldnumber 15)) " FIRST 1 to w55_del_tmp_field.bat 
EXPORT "    DELETE %"+"v_del_variable"+"% OK                                    " FIRST 1 to w55_del_tmp_field.bat APPEND
EXPORT "    v_count_fieldnumber=v_count_fieldnumber+1                           " FIRST 1 to w55_del_tmp_field.bat APPEND

v_count_fieldnumber=1

DO w55_del_tmp_field WHILE v_count_fieldnumber<=v_GetNumberOfFields


DELETE SCRIPT w55_del_tmp_field OK
DELETE w55_del_tmp_field.bat OK

DELETE v_del_variable OK
DELETE v_new_fieldname OK
DELETE v_fieldname OK
DELETE v_count_fieldnumber OK

v_GetFieldContentOfFirstRecord=ALLTRIM(SUBSTR(v_fieldnames_content 2 v_number_of_blanks))

DELETE v_number_of_blanks OK
DELETE v_fieldnames_content OK


COMMENT --- End ----- Get field content of first record ----


COMMENT --- Begin --- Get relation information ----

OPEN w55_tmp_log.log FORMAT W55_TMP_FORMAT_2000 CRLF
SET FILTER FIND('related by')
COUNT
v_GetNumberOfRelations=COUNT1
DELETE COUNT1 OK

v_GetRelationTableName=Blanks(3000)
v_GetRelationField=Blanks(3000)
v_GetRelationIndex=Blanks(3000)

GROUP 
  v_GetRelationTableName=ALLTRIM(v_GetRelationTableName)+'#'+ALLTRIM(Substr(ALLTRIM(SPLIT(TMP_LINE "'" 2)) 1 31))
  v_GetRelationField=ALLTRIM(v_GetRelationField)+'#'+ALLTRIM(Substr(ALLTRIM(SPLIT(TMP_LINE "'" 4)) 1 31))
  v_GetRelationIndex=ALLTRIM(v_GetRelationIndex)+'#'+ALLTRIM(Substr(ALLTRIM(SPLIT(TMP_LINE "'" 6)) 1 31))
END


v_GetRelationTableName=ALLTRIM(SUBSTR(v_GetRelationTableName 2 3000))
v_GetRelationField=ALLTRIM(SUBSTR(v_GetRelationField 2 3000))
v_GetRelationIndex=ALLTRIM(SUBSTR(v_GetRelationIndex 2 3000))

SET FILTER


COMMENT --- End ----- Get relation information ----

COMMENT --- Begin --- Get project tables ----


OPEN "%v_GetOpenProjectName%" FORMAT W55_TMP_FORMAT_2000 CRLF
SET FILTER TMP_LINE = '^FORMAT'
COUNT
v_GetNumberOfTables=COUNT1
v_GetProjectTableName=Blanks(3000)
v_GetProjectTableFileName=Blanks(3000)

GROUP
  v_GetProjectTableName=ALLTRIM(v_GetProjectTableName)+'#'+ALLTRIM(SPLIT(ALLTRIM(SUBSTR(TMP_LINE 10 32)) ' ' 1))
  v_GetProjectTableFileName=ALLTRIM(v_GetProjectTableFileName)+'#'+ALLTRIM(REVERSE(SPLIT(ALLTRIM(SPLIT(ALLTRIM(REVERSE(TMP_LINE)) '"' 2)) '"' 1)))
END

v_GetProjectTableName=ALLTRIM(SUBSTR(v_GetProjectTableName 2 3000))
v_GetProjectTableFileName=ALLTRIM(SUBSTR(v_GetProjectTableFileName 2 3000))
v_GetProjectTableFileNameNum=OCCURS(v_GetProjectTableFileName '.')

SET FILTER
DELETE COUNT1 OK

COMMENT --- End ----- Get project tables ----

COMMENT --- Begin ----- Get current view name ----
OPEN "%v_GetOpenProjectName2%" FORMAT W55_TMP_FORMAT_2000 CRLF

DEFINE FIELD w55_filename COMPUTED
IF tmp_line='^FORMAT' STATIC
SUBSTR(ALLTRIM(SPLIT(ALLTRIM(SPLIT(TMP_LINE '^FORMAT   ' 2)) ' ' 1)) 1 31)

DEFINE FIELD w55_view_name COMPUTED
IF tmp_line='^REPORT' STATIC
SUBSTR(ALLTRIM(SPLIT(ALLTRIM(SPLIT(TMP_LINE '^REPORT   ' 2)) ' ' 1)) 1 31)

DEFINE FIELD w55_table_name COMPUTED
IF tmp_line='^REPORT' STATIC
SUBSTR(ALLTRIM(SPLIT(ALLTRIM(SPLIT(ALLTRIM(SPLIT(TMP_LINE '^REPORT   '+w55_view_name 2)) ' ' 1)) ' ' 1)) 1 31)

LOCATE IF w55_filename='%v_GetOpenTableName% ' AND tmp_line='[LASTVIEW]'

v_GetOpenViewName=ALLTRIM(EXCLUDE(SUBSTR(TMP_LINE 11 31) ' "'))


DELETE v_GetOpenProjectName2 OK
COMMENT --- End ----- Get current view name ----

COMMENT --- Begin ----- Get current view fields ----
LOCATE IF TMP_LINE='^REPORT' and SPLIT(ALLTRIM(SPLIT(TMP_LINE '^REPORT' 2)) ' ' 1)+' '=v_GetOpenViewName and ALLTRIM(SPLIT(ALLTRIM(SPLIT(TMP_LINE v_GetOpenViewName 2)) ' ' 1))+' '=v_GetOpenTableName+' ' AND ALLTRIM(REVERSE(TMP_LINE))=',T.D '

v_record_start =RECNO()
LOCATE RECORD v_record_start+1

v_GetOpenViewFieldName=BLANKS(3000)
v_GetOpenViewFieldWidth=BLANKS(3000)

GROUP IF RECNO()> v_record_start WHILE TMP_LINE<>'^'
  v_GetOpenViewFieldName=ALLTRIM(v_GetOpenViewFieldName)+'#'+ALLTRIM(SPLIT(ALLTRIM(TMP_LINE) ' ' 1)) IF not MATCH(TMP_LINE '[')
  v_GetOpenViewFieldWidth=ALLTRIM(v_GetOpenViewFieldWidth)+'#'+ALLTRIM(SPLIT(ALLTRIM(SPLIT(ALLTRIM(TMP_LINE) 'WIDTH ' 2)) ' ' 1)) IF not MATCH(TMP_LINE '[') AND FIND('width' TMP_LINE) 
  v_GetOpenViewFieldWidth=ALLTRIM(v_GetOpenViewFieldWidth)+'#'+ALLTRIM(STRING(LENGTH(ALLTRIM(SPLIT(ALLTRIM(TMP_LINE) ' ' 1))) 4)) IF not MATCH(TMP_LINE '[') AND NOT FIND('width' TMP_LINE) 
END

v_GetOpenViewFieldNumber=OCCURS(v_GetOpenViewFieldName '#')
v_GetOpenViewFieldWidth=ALLTRIM(SUBSTR(v_GetOpenViewFieldWidth 2 3000))
v_GetOpenViewFieldName=ALLTRIM(SUBSTR(v_GetOpenViewFieldName 2 3000))


DELETE v_record_start OK

SET FILTER

COMMENT --- End ------- Get current view fields ----

COMMENT --- Begin ------- Get view names ----

SET FILTER ALLTRIM(w55_table_name)+' ' = ALLTRIM("%v_GetOpenTableName%") AND (TMP_LINE = "^REPORT")

v_GetTableViewName=BLANKS(3000)

GROUP IF ALLTRIM(w55_table_name) = ALLTRIM("%v_GetOpenTableName%")+' ' AND (TMP_LINE = "^REPORT")
  v_GetTableViewName=ALLTRIM(v_GetTableViewName)+'#'+ALLTRIM(SPLIT(ALLTRIM(SPLIT(ALLTRIM(TMP_LINE) '^REPORT' 2)) ' ' 1))
END

v_GetTableViewNameNumber=OCCURS(v_GetTableViewName '#')
v_GetTableViewName=ALLTRIM(SUBSTR(v_GetTableViewName 2 3000))
COMMENT --- End --------- Get view names ----


COMMENT --- Begin ------- Get active filter and log file name ----

v_GetViewFilter=''

DIR *.log to w55_tmp_logfiles
OPEN w55_tmp_logfiles


SORT ON FILE_WRITE_DATE  D  FILE_WRITE_TIME  D  IF not find('w55_tmp_log.log') TO "w55_sort_tmp_logfiles" OPEN
LOCATE RECORD 1
v_GetOpenLogFileName=ALLTRIM(SPLIT(FILE_NAME '\' OCCURS(FILE_NAME '\')+1))
v_GetOpenProjectPath=ALLTRIM(SUBSTR(FILE_NAME 1 AT(OCCURS(FILE_NAME '\') '\' FILE_NAME)))

DELETE FORMAT w55_tmp_logfiles OK
DELETE w55_tmp_logfiles.fil OK

DELETE FORMAT w55_sort_tmp_logfiles OK
DELETE w55_sort_tmp_logfiles.fil OK

OPEN "%v_GetOpenLogFileName%" FORMAT W55_TMP_FORMAT_2000 CRLF
COUNT

EXTRACT FIELDS TMP_LINE IF TMP_LINE='@ SET FILTER' AND BETWEEN(RECNO() COUNT1-500 COUNT1) TO "w55_ext_log_filter" OPEN
SORT ON RECNO( )  D  TO "w55_sort_ext_log_filter" OPEN
LOCATE IF TMP_LINE = "@ SET FILTER"

IF TMP_LINE ='@ SET FILTER TO' AND LENGTH(ALLTRIM(TMP_LINE))>12 v_GetViewFilter=ALLTRIM(SUBSTR(TMP_LINE 17 1983))
IF TMP_LINE ='@ SET FILTER' AND TMP_LINE <>'@ SET FILTER TO' AND LENGTH(ALLTRIM(TMP_LINE))>12 v_GetViewFilter=ALLTRIM(SUBSTR(TMP_LINE 13 1983))

CLOSE
DELETE FORMAT w55_ext_log_filter OK
DELETE w55_ext_log_filter.fil OK

DELETE FORMAT w55_sort_ext_log_filter OK
DELETE w55_sort_ext_log_filter.fil OK

DELETE COUNT1 OK

COMMENT --- End --------- Get active filter and log file name ----


OPEN W55_TMP_FORMAT_2000 FORMAT W55_TMP_FORMAT_2000 CRLF
CLOSE


COMMENT --- Begin --- Delete temporary files and variables ----

COM DELETE v_default_language OK
COM DELETE v_valid_characters OK
DELETE v_dialog_01_title OK
DELETE v_dialog_01_line_01 OK
DELETE v_table OK

DELETE w55_tmp_log.log OK
DELETE FORMAT TMP_C_DREV OK
DELETE TMP_C_DREV.fil OK
DELETE W55_TMP_FORMAT_2000.fil OK
DELETE FORMAT W55_TMP_FORMAT_2000 OK

DELETE FORMAT w55_tmp_log_file OK
DELETE w55_tmp_log_file.fil OK

DELETE FORMAT w55_tmp_fieldnames OK
DELETE w55_tmp_fieldnames.fil OK

DELETE FORMAT w55_ext_field_info OK
DELETE w55_ext_field_info.fil OK

DELETE w55_exp_field_into_all.txt OK

DELETE ACL_Ver_Type OK
DELETE ACL_Ver_Patch OK
DELETE ACL_Ver_Minor OK
DELETE ACL_Ver_Major OK
DELETE WRITE1 OK
DELETE OUTPUTFOLDER OK

DELETE ext_w55_tmp_fieldnames.fil OK

COMMENT --- End ----- Delete temporary files and variables ----

OPEN "%v_GetOpenTableName%"

COMMENT ---- Return user settings - EXACT ON/OFF -----
SET EXACT %v_GetUserSetExactOnOff%
SET LOG TO "%v_GetOpenLogFileName%"
SET FILTER %v_GetViewFilter%

SET SAFETY ON
SET ECHO ON

