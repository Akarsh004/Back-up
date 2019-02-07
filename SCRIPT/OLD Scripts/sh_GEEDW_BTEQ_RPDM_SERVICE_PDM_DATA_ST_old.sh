# --------------------------------------------------------------------------------------------------------------#
# File: sh_GEEDW_BTEQ_RPDM_SERVICE_PDM_DATA_ST.sh										#
# Creation Date: 10-JAN-2018											#
# Last Modified: 10-JAN-2018											#
# Purpose: Population of Service PDM MT Table based on System numbers identified with help of Assert into	#
# Created By: Sumanta Kumar Bhujabal											#
# --------------------------------------------------------------------------------------------------------------#

UPLOAD_FILE=/data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_SYSTEM_NUMBERS_ST.DAT
export UPLOAD_FILE
date1=`date +%m/%d/%Y`
v_date="'$date1'"
size=`ls -l $UPLOAD_FILE | awk '{print $5}'`
if [ $size -gt 0 ]; then

while read line1
do
v_mli_num=${line1}

. /data/informatica/ETCOE/EEDW01/SrcFiles/dbenv.sh
bteq << eof
 /* .RUN File = ${SrcDir}/td_plp.mlbt */ 
/*.RUN File = /apps/informatica/product/pc/bin/td_geedw_plp.mlbt; */
 .RUN File = /data/informatica/ETCOE/EEDW01/SrcFiles/td_plp.mlbt
database ${Bulk_database};

--DELETE GEEDW_PLP_BULK_T.SBOM_DATA WHERE TOP_LEVEL_PARENT_ITEM =  $v_mli_num;

collect stats column ( T2SPUNAME ) on GEEDW_PLP_BULK_T.MT_RPDM_SYSTEM_INSTANCE_ST;
collect stats column ( PARTNUMBER ) on GEEDW_PLP_BULK_T.MT_RPDM_SYSTEM_INSTANCE_ST;
collect stats column ( CHILD_OBID ) on GEEDW_PLP_BULK_T.MT_RPDM_SYSTEM_INSTANCE_ST;

INSERT INTO GEEDW_PLP_BULK_T.MT_RPDM_SYSTEM_INSTANCE_ST
(
SYSTEM_ID
,T2SPUNAME
,PARENT_NM
,LVL
,REL_TYPE
,ITEM_IDNFR
,PARTNUMBER
,TEXTM
,CREATION_DATE
,REMARKM
,CLASS_NM
,PARENT_TEXTM
,REV_INDEX
,SEQUENCE
,PROJECTNAME
,LIFECYCLESTATE
,FROZENINDICATOR
,SUPERSEDED
,OFFICIAL
,CHECKEDOUT
,OWNERNAME
,CURDBNAME
,T2SECURITYSTATE
,CHILD_OBID
,CHILD_NAME
,CHILD_REV
,QUANTITY
,POSTXT
,WEIGHT
,UNITOFMEASURE
,DFSORDER
,DW_LOAD_DTTM
,DW_CREATED_BY
,DW_UPDATED_DTTM
,DW_UPDATED_BY
)
WITH RECURSIVE HIER (SYSTEM_ID,T2SPUNAME,PARENT_NM,LVL,REL_TYPE,ITEM_IDNFR,CLASS_NM,PARENT_TEXTM,PARTNUMBER,TEXTM,CREATION_DATE,REMARKM,REV_INDEX,SEQUENCE,PROJECTNAME
,LIFECYCLESTATE,FROZENINDICATOR,SUPERSEDED ,OFFICIAL,CHECKEDOUT ,OWNERNAME,CURDBNAME,T2SECURITYSTATE
,CHILD_OBID,CHILD_NAME,CHILD_REV,QUANTITY,WEIGHT,UNITOFMEASURE,POSTXT,FINDNUMBER,DFSORDER
)
AS
(
SELECT   DISTINCT
CASE WHEN T2SYSTEM.T2POSEIDONNUMBER IS NULL THEN T2SYSTEM.T2SPUNUMBER
ELSE  T2SYSTEM.T2POSEIDONNUMBER END AS SYSTEM_ID
,T2SYSTEM.T2SPUNAME
, T2SYSTEM.T2SPUNAME AS PARENT_NM
,CAST(1 AS INTEGER )AS LVL
,CAST('Has Top Instances (has)' AS VARCHAR(30)) AS REL_TYPE
,CAST(INSTNCE.PARTNUMBER || ',' || INSTNCE.REVISION || ',' || INSTNCE.SEQUENCE AS VARCHAR(120)) AS ITEM_IDNFR
,CAST('INSTNCE' AS VARCHAR(30)) AS CLASS_NM
,INSTNCE.T2TEXTEN AS PARENT_TEXTM
,INSTNCE.PARTNUMBER
,INSTNCE.T2TEXTEN AS  TEXTM
,INSTNCE.CREATIONDATE AS  CREATION_DATE
,INSTNCE.T2REMARKEN AS  REMARKM
,INSTNCE.REVISION AS REV_INDEX
,INSTNCE.SEQUENCE
,INSTNCE.PROJECTNAME AS PROJECTNAME
,INSTNCE.LIFECYCLESTATE
,INSTNCE.FROZENINDICATOR
,INSTNCE.SUPERSEDED 
,INSTNCE.OFFICIAL
,INSTNCE.CHECKEDOUT 
,INSTNCE.OWNERNAME
,INSTNCE.CURDBNAME
,INSTNCE.T2SECURITYSTATE
,INSTNCE.OBID AS  CHILD_OBID
,INSTNCE.PARTNUMBER AS  CHILD_NAME
,INSTNCE.REVISION AS  CHILD_REV
,CAST(NULL AS DECIMAL(18,6)) AS   QUANTITY
,INSTNCE.T2WEIGHTSTR  AS  WEIGHT
,CAST(NULL AS VARCHAR(5)) AS UNITOFMEASURE  
,CAST(NULL AS VARCHAR(1000)) AS POSTXT
,CAST(NULL AS VARCHAR(5)) AS  FINDNUMBER
,CAST(T2SYSTEM.T2SPUNAME || '\' || INSTNCE.PARTNUMBER AS VARCHAR(500))  AS  DFSORDER
FROM 
GEEDW_PLP_BULK_V.CDR_RPDM_T2SYSTEM T2SYSTEM
INNER JOIN           GEEDW_PLP_BULK_V.CDR_RPDM_T4SyAS  T4SyAS                      
ON          T2SYSTEM.OBID=T4SyAS.LEFT1 AND T4SyAS.CLASS1='T2System'
INNER JOIN  GEEDW_PLP_BULK_V.CDR_RPDM_T4ASSM INSTNCE
ON T4SyAS.RIGHT1=INSTNCE.OBID  AND T4SyAS.CLASS2='T4Assm'
WHERE 1=1
--AND INSTNCE.SUPERSEDED = '-'
AND INSTNCE.PARTNUMBER NOT LIKE '%#%'
AND INSTNCE.LIFECYCLESTATE   LIKE  ANY ( '%APPROVED', '%BlockBwd%','%Discntd%','%Withdrawn','%Working')
--AND T2SYSTEM.T2SPUNUMBER IN '680005599'
--AND T2SYSTEM.T2SPUNUMBER IN ($v_mli_num)
AND INSTNCE.PARTNUMBER  IN ($v_mli_num)
--AND INSTNCE.PARTNUMBER  IN  ('INS051009852373')
UNION ALL 

SELECT
C.SYSTEM_ID
,C.T2SPUNAME
,T4ASSM.PARTNUMBER
,C.LVL+1   AS LVL
,CAST('Has Instances (has)' AS VARCHAR(30)) AS REL_TYPE
,CAST(T4ASSM1.PARTNUMBER || ',' || T4ASSM1.REVISION || ',' || T4ASSM1.SEQUENCE  AS VARCHAR(120)) AS ITEM_IDNFR
,CAST('INSTNCE' AS VARCHAR(30)) AS CLASS_NM
,T4ASSM.T2TEXTEN AS   PARENT_TEXTM
,T4ASSM1.PARTNUMBER
,T4ASSM1.T2TEXTEN AS  TEXTM
,T4ASSM1.CREATIONDATE AS  CREATION_DATE
,T4ASSM1.T2REMARKEN AS  REMARKM
,T4ASSM1.REVISION AS REV_INDEX
,T4ASSM1.SEQUENCE
,T4ASSM1.PROJECTNAME
--,C.TOP_PART 
--,T4ASSM1.PARTNUMBER AS PARENT_PART
,T4ASSM1.LIFECYCLESTATE
,T4ASSM1.FROZENINDICATOR
,T4ASSM1.SUPERSEDED 
,T4ASSM1.OFFICIAL
,T4ASSM1.CHECKEDOUT 
,T4ASSM1.OWNERNAME
,T4ASSM1.CURDBNAME
,T4ASSM1.T2SECURITYSTATE
,T4ASSM1.OBID AS CHILD_OBID
,T4ASSM1.PARTNUMBER AS CHILD_NAME
,T4ASSM1.REVISION AS CHILD_REV
,T4ASSTRC.QUANTITY AS   QUANTITY
,T4ASSM1.T2WEIGHTSTR  AS  WEIGHT
,T4ASSTRC.UNITOFMEASURE  AS UNITOFMEASURE  
,T4ASSTRC.T2TEXT9X25EN  AS POSTXT
,CAST(NULL AS VARCHAR(5)) AS  FINDNUMBER
,CAST(C.DFSORDER|| '\0\' || T4ASSM1.PARTNUMBER  AS VARCHAR(500)) AS DFSORDER

FROM GEEDW_PLP_BULK_V.CDR_RPDM_T4ASSM T4ASSM
INNER JOIN HIER C
ON T4ASSM.OBID = C.CHILD_OBID --AND T4ASSM.SUPERSEDED = '-'
AND T4ASSM.PARTNUMBER NOT LIKE '%#%'
AND T4ASSM.LIFECYCLESTATE   LIKE  ANY ( '%APPROVED', '%BlockBwd%','%Discntd%','%Withdrawn','%Working')
INNER JOIN GEEDW_PLP_BULK_V.CDR_RPDM_T4ASSTRC T4ASSTRC 
ON T4ASSM.OBID = T4ASSTRC.LEFT1
INNER JOIN GEEDW_PLP_BULK_V.CDR_RPDM_T4ASMSTR T4ASMSTR
ON T4ASSTRC.RIGHT1=T4ASMSTR.OBID
INNER JOIN  GEEDW_PLP_BULK_T.MT_RPDM_CHILD_INSTANCE T4ASSM1
ON T4ASMSTR.OBID=T4ASSM1.ITMREV_LEFT1
WHERE C.LVL <30
AND T4ASSM1.PARTNUMBER IS NOT NULL
)
SELECT  
SYSTEM_ID,T2SPUNAME,PARENT_NM,LVL,REL_TYPE,ITEM_IDNFR,PARTNUMBER,TEXTM,CREATION_DATE,REMARKM,CLASS_NM,PARENT_TEXTM,REV_INDEX,SEQUENCE
,PROJECTNAME,LIFECYCLESTATE,FROZENINDICATOR,SUPERSEDED,OFFICIAL,CHECKEDOUT,OWNERNAME,CURDBNAME
,T2SECURITYSTATE,CHILD_OBID,CHILD_NAME,CHILD_REV,QUANTITY,POSTXT,WEIGHT,UNITOFMEASURE,DFSORDER,
CAST(current_timestamp(0 )AS timestamp(0) FORMAT 'MM/DD/YYYYBHH:MI:SS')  AS DW_LOAD_DTTM,
'CDR' AS DW_CREATED_BY,
CAST(current_timestamp(0 )AS timestamp(0) FORMAT 'MM/DD/YYYYBHH:MI:SS') AS DW_UPDATED_DTTM,
'CDR'    AS DW_UPDATED_BY  
 FROM HIER
GROUP BY 
SYSTEM_ID,T2SPUNAME,PARENT_NM,LVL,REL_TYPE,ITEM_IDNFR,PARTNUMBER,TEXTM,CREATION_DATE,REMARKM,CLASS_NM,PARENT_TEXTM,REV_INDEX,SEQUENCE
,PROJECTNAME,LIFECYCLESTATE,FROZENINDICATOR,SUPERSEDED,OFFICIAL,CHECKEDOUT,OWNERNAME
,CURDBNAME,T2SECURITYSTATE,CHILD_OBID,CHILD_NAME,CHILD_REV,QUANTITY,POSTXT,WEIGHT,UNITOFMEASURE,DFSORDER
,DW_LOAD_DTTM,DW_CREATED_BY,DW_UPDATED_DTTM,DW_UPDATED_BY;

eof

done < $UPLOAD_FILE

fi
