# --------------------------------------------------------------------------------------------------------------#
# File: sh_GEEDW_BTEQ_RPDM_TOP_PART_ORDER_DATA_LOAD.sh								#
# Creation Date: 10-JAN-2018											#
# Last Modified: 10-JAN-2018											#
#Last Modified: 23-APRIL-2018: To add Language code,Ref Part# and Ref Part Rev					#
# Purpose: Population of Service PDM MT Table based on System numbers identified with help of Assert into	#
# Created By: Sumanta Kumar Bhujabal										#
# --------------------------------------------------------------------------------------------------------------#

UPLOAD_FILE=/data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_TOP_PART_ORDER.DAT
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

CREATE VOLATILE TABLE VT_ORD_POC_DATA_DTTMRP AS 
(
WITH RECURSIVE HIER (
LVL,
REL_TYPE,
T2SPUNUMBER,
T2SPUNAME,
TOP_PART_IDNFR,
T3ORDERNUMBER,
ORDERREVISION,
PARENT_PART,
ITEM_IDNFR,
PROJECTNAME,
CLASS_NM,
CHILD_OBID,
CHILD_NAME,
CHILD_REV,
QUANTITY,
TEXTM,
LANGUAGE_CODE,
POSTXT1,
TEXT_REMARK,
WEIGHT,
SECURITY_STATE,
ORIGINATED_DATE,
T2DECISIONCODE,
UNITOFMEASURE,
CREATOR_SSO,
PART_LIFECYCLESTATE,
CHILD_T2APPROVEDDATE,
FINDNUMBER,
DFSORDER,
LFSTATE_DFSORDER,
DECIONCD_DFSORDER,
TRELEASEDLANG_CODE,
T2RELEASEDLANG
) AS (

SELECT DISTINCT  
VT.LVL+1 AS LVL
,CAST('Orders (Ordrs)' AS VARCHAR(150)) AS REL_TYPE
,VT.T2SPUNUMBER
,VT.T2SPUNAME
,VT.TOP_PART_IDNFR
,VT.T3ORDERNUMBER
,VT.ORDERREVISION
,VT. CHILD_NAME
,CAST(PART1.PARTNUMBER || ',' || PART1.REVISION || ',' || PART1.SEQUENCE AS VARCHAR(120)) AS ITEM_IDNFR
,PART1.PROJECTNAME
,CAST('PART' AS VARCHAR(30)) AS CLASS_NM
,PART1.OBID AS CHILD_OBID
,PART1.PARTNUMBER AS CHILD_NAME
,PART1.REVISION AS CHILD_REV
,T3OdPART.QUANTITY  AS QUANTITY 
--,PART1.T2TEXTEN AS TEXT_EN  
,COALESCE(PART1.T2TEXTEN, PART1.T2TEXTDE ,PART1.T2TEXTPL,PART1.T2TEXTSV, PART1.T2TEXTFR , PART1.T2TEXTIT
,PART1.T2TEXTES, PART1.T2TEXTRU,   PART1.T2TEXTNO, PART1.T2TEXTPT,PART1.T2TEXTRO, PART1.T2TEXTCS,PART1.T2TEXTCN)  AS TEXTM
,CASE 
                                                                                WHEN PART1.T2TEXTEN  IS NOT NULL THEN 'EN'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS NOT NULL THEN  'DE'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS NOT 

NULL THEN  'PL'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS NOT NULL THEN 'SV'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS NOT NULL THEN  'FR'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS  NULL 
                                                                                AND PART1.T2TEXTIT IS NOT NULL THEN 'IT' 
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS  NULL 
                                                                                AND PART1.T2TEXTIT IS  NULL AND  PART1.T2TEXTES IS NOT NULL THEN    'ES'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS  NULL 
                                                                                AND PART1.T2TEXTIT IS  NULL AND  PART1.T2TEXTES IS  NULL  AND                 

PART1.T2TEXTRU IS NOT NULL THEN 'RU'         
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS  NULL 
                                                                                AND PART1.T2TEXTIT IS  NULL AND  PART1.T2TEXTES IS  NULL  AND                 

PART1.T2TEXTRU IS  NULL AND PART1.T2TEXTNO IS NOT NULL THEN           'NO'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS  NULL 
                                                                                AND PART1.T2TEXTIT IS  NULL AND  PART1.T2TEXTES IS  NULL  AND                 

PART1.T2TEXTRU IS  NULL AND PART1.T2TEXTNO IS  NULL  
                                                                                AND PART1.T2TEXTPT IS NOT NULL THEN         'PT'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS  NULL 
                                                                                AND PART1.T2TEXTIT IS  NULL AND  PART1.T2TEXTES IS  NULL  AND                 

PART1.T2TEXTRU IS  NULL AND PART1.T2TEXTNO IS  NULL  
                                                                                AND PART1.T2TEXTPT IS  NULL  AND PART1.T2TEXTRO IS NOT NULL THEN 'RO'          
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS  NULL 
                                                                                AND PART1.T2TEXTIT IS  NULL AND  PART1.T2TEXTES IS  NULL  AND                 

PART1.T2TEXTRU IS  NULL AND PART1.T2TEXTNO IS  NULL  
                                                                                AND PART1.T2TEXTPT IS  NULL  AND PART1.T2TEXTRO IS  NULL AND                 

PART1.T2TEXTCS IS NOT NULL THEN 'CS'
                                                                                WHEN  PART1.T2TEXTEN  IS  NULL  AND PART1.T2TEXTDE  IS  NULL  AND   PART1.T2TEXTPL IS  

NULL  AND PART1.T2TEXTSV IS  NULL AND   PART1.T2TEXTFR IS  NULL 
                                                                                AND PART1.T2TEXTIT IS  NULL AND  PART1.T2TEXTES IS  NULL  AND                 

PART1.T2TEXTRU IS  NULL AND PART1.T2TEXTNO IS  NULL  
                                                                                AND PART1.T2TEXTPT IS  NULL  AND PART1.T2TEXTRO IS  NULL AND                 

PART1.T2TEXTCS IS  NULL AND  PART1.T2TEXTCN IS NOT NULL THEN          'CN'
END AS LANGUAGE_CODE
,T3OdPART.T2TEXT9X25  AS POSTXT1
,PART1.T2REMARKEN AS TEXT_REMARK
,PART1.T2WEIGHTSTR AS  WEIGHT
,PART1.T2SECURITYSTATE AS SECURITY_STATE      
,PART1.CREATIONDATE AS ORIGINATED_DATE 
,CAST('' AS VARCHAR(275)) AS T2DECISONCODE    
,T3OdPART.UNITOFMEASURE AS UNITOFMEASURE 
,PART1.CREATOR AS CREATOR_SSO
,PART1.LIFECYCLESTATE AS PART_LIFECYCLESTATE
,PART1.T2APPROVEDDATE AS CHILD_T2APPROVEDDATE
,T3OdPART.FINDNUMBER AS  FINDNUMBER
,CAST(VT.DFSORDER || '/' ||  PART1.PARTNUMBER AS VARCHAR(500))  AS  DFSORDER
,CAST(PART1.LIFECYCLESTATE AS VARCHAR(1000))  AS  LFSTATE_DFSORDER
,CAST('' AS VARCHAR(1000))  AS  DECIONCD_DFSORDER
,CASE WHEN   PART1.T2RELEASEDLANG = 'Bps41' THEN 'EN + ZH'
							WHEN   PART1.T2RELEASEDLANG = 'Bps60' THEN 'EN + DE + PL'
							WHEN   PART1.T2RELEASEDLANG = 'Bps61' THEN 'PL + RU'
							WHEN   PART1.T2RELEASEDLANG = 'Bps67' THEN 'PL + DE'
							WHEN   PART1.T2RELEASEDLANG = 'Bps70' THEN 'FR + ES'
							WHEN   PART1.T2RELEASEDLANG = 'Bps81' THEN 'EN + DE + SV'
							WHEN   PART1.T2RELEASEDLANG = 'Bps82' THEN 'EN + SV'
							WHEN   PART1.T2RELEASEDLANG = 'Bps83' THEN 'EN + DE'
							WHEN   PART1.T2RELEASEDLANG = 'Bps84' THEN 'EN + FR + DE'
							WHEN   PART1.T2RELEASEDLANG = 'Bps85' THEN 'EN + FR'
							WHEN   PART1.T2RELEASEDLANG = 'Bps86' THEN 'EN + PL'
							WHEN   PART1.T2RELEASEDLANG = 'Bps87' THEN 'EN + IT'
							WHEN   PART1.T2RELEASEDLANG = 'Bps88' THEN 'EN + ES'
							WHEN   PART1.T2RELEASEDLANG = 'Bps89' THEN 'EN + RU'
							WHEN   PART1.T2RELEASEDLANG = 'Bps90' THEN 'DE + FR'
							WHEN   PART1.T2RELEASEDLANG = 'Bpsen' THEN 'EN'
							WHEN   PART1.T2RELEASEDLANG = 'Bpsde' THEN 'DE'
							WHEN   PART1.T2RELEASEDLANG = 'Bpspl' THEN 'PL'
							WHEN   PART1.T2RELEASEDLANG = 'Bpssv' THEN 'SV'
							WHEN   PART1.T2RELEASEDLANG = 'Bpsfr' THEN 'FR'
							WHEN   PART1.T2RELEASEDLANG = 'Bpsit' THEN 'IT'
							WHEN   PART1.T2RELEASEDLANG = 'Bpses' THEN 'ES'
							WHEN   PART1.T2RELEASEDLANG = 'Bpsru' THEN 'RU'
							WHEN   PART1.T2RELEASEDLANG = 'Bpsno' THEN 'NO'
							WHEN   PART1.T2RELEASEDLANG = 'Bpspt' THEN 'PT'
							WHEN   PART1.T2RELEASEDLANG = 'Bpsro' THEN 'RO'
							WHEN   PART1.T2RELEASEDLANG = 'Bpscs' THEN 'CS'
							WHEN   PART1.T2RELEASEDLANG = 'Bpscn' THEN 'ZH'
							ELSE  PART1.T2RELEASEDLANG
END 		TRELEASEDLANG_CODE	
,PART1.T2RELEASEDLANG		
FROM  GEEDW_Q_PLP_BULK_T.MT_RPDM_SYS_ORD_LVL1_DATA VT
INNER JOIN 
(
SELECT 
T2SYSTEM.T2SPUNUMBER
,T3ORDER.T3ORDERNUMBER
,T3PRDORD.REVISION
,T3ORDER.OBID
FROM  GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2SYSTEM T2SYSTEM
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T4SYSPRO T4SYSPRO 
ON T2SYSTEM.OBID=T4SYSPRO.LEFT1
INNER JOIN   GEEDW_Q_PLP_BULK_V.CDR_RPDM_T3PRDORD T3PRDORD
ON T4SYSPRO.RIGHT1=T3PRDORD.OBID
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T3ORDER  T3ORDER 
ON T3ORDER.T3ORDERNUMBER=T3PRDORD.T3ORGORDERNO
GROUP BY 1,2,3,4
) PART
ON VT.T2SPUNUMBER=PART.T2SPUNUMBER
/*AND VT.CHILD_NAME=PART.T3ORDERNUMBER
AND VT.CHILD_REV=PART.REVISION*/
INNER JOIN  GEEDW_Q_PLP_BULK_V.CDR_RPDM_T3OdPart T3OdPart
ON PART.OBID=T3OdPART.LEFT1 AND PART.T3ORDERNUMBER=T3OdPART.T3ORDERNUMBER
AND VT.CHILD_REV=T3OdPART.REVISION
INNER JOIN   GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2ASSM PART1
ON T3OdPART.RIGHT1=PART1.OBID

WHERE CLASS_NM='Order'
/*$and$substitute{T2SPUNUMBER}$    
$and$substitute{T3ORDERNUMBER}$*/
AND PART1.PARTNUMBER IN ($v_mli_num) 
--AND PART.T3ORDERNUMBER='0000072130'
--AND 	PART.T2SPUNUMBER='Sy0020076'
--AND PART1.PARTNUMBER ='HTGD495375R0003'
/*AND PART1.PARTNUMBER IN ('E1268259622R89','1ECR300456P0004','1BNR000767P0001','W70408545GWN40','HTGD485997P0002','GMD2112172P0001','SYNO000000P2496','HTCT427787P0001','HTCT438965P0001')*/
UNION ALL 
SELECT
C.LVL+1
,CAST('Uses for Order (UsOrd)' AS VARCHAR(150)) AS REL_TYPE
,C.T2SPUNUMBER
,C.T2SPUNAME
,C.TOP_PART_IDNFR
,C.T3ORDERNUMBER
,C.ORDERREVISION
,PARENT.PARTNUMBER AS PARENT_PART
,CAST(T2ASSM.PARTNUMBER || ',' || T2ASSM.REVISION || ',' || T2ASSM.SEQUENCE AS VARCHAR(120)) AS ITEM_IDNFR
,T2ASSM.PROJECTNAME
,CAST('PART' AS VARCHAR(30)) AS CLASS_NM
,T2ASSM.OBID AS CHILD_OBID
,T2ASSM.PARTNUMBER AS CHILD_NAME
,T2ASSM.REVISION AS CHILD_REV
,T3ODASAS.QUANTITY  AS QUANTITY 
--,T2ASSM.T2TEXTEN AS TEXT_EN  
,COALESCE(T2ASSM.T2TEXTEN, T2ASSM.T2TEXTDE ,T2ASSM.T2TEXTPL,T2ASSM.T2TEXTSV, T2ASSM.T2TEXTFR , T2ASSM.T2TEXTIT
,T2ASSM.T2TEXTES, T2ASSM.T2TEXTRU,   T2ASSM.T2TEXTNO, T2ASSM.T2TEXTPT,T2ASSM.T2TEXTRO, T2ASSM.T2TEXTCS,T2ASSM.T2TEXTCN) AS TEXTM
,CASE 
                                                                                WHEN T2ASSM.T2TEXTEN  IS NOT NULL THEN 'EN'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS NOT NULL THEN  'DE'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS NOT NULL THEN  'PL'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS NOT NULL THEN 'SV'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS NOT NULL THEN  'FR'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS  NULL 
                                                                                AND T2ASSM.T2TEXTIT IS NOT NULL THEN 'IT' 
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS  NULL 
                                                                                AND T2ASSM.T2TEXTIT IS  NULL AND  T2ASSM.T2TEXTES IS NOT NULL THEN          'ES'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS  NULL 
                                                                                AND T2ASSM.T2TEXTIT IS  NULL AND  T2ASSM.T2TEXTES IS  NULL  AND                 

T2ASSM.T2TEXTRU IS NOT NULL THEN 'RU'    
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS  NULL 
                                                                                AND T2ASSM.T2TEXTIT IS  NULL AND  T2ASSM.T2TEXTES IS  NULL  AND                 

T2ASSM.T2TEXTRU IS  NULL AND T2ASSM.T2TEXTNO IS NOT NULL THEN 'NO'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS  NULL 
                                                                                AND T2ASSM.T2TEXTIT IS  NULL AND  T2ASSM.T2TEXTES IS  NULL  AND                 

T2ASSM.T2TEXTRU IS  NULL AND T2ASSM.T2TEXTNO IS  NULL  
                                                                                AND T2ASSM.T2TEXTPT IS NOT NULL THEN    'PT'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS  NULL 
                                                                                AND T2ASSM.T2TEXTIT IS  NULL AND  T2ASSM.T2TEXTES IS  NULL  AND                 

T2ASSM.T2TEXTRU IS  NULL AND T2ASSM.T2TEXTNO IS  NULL  
                                                                                AND T2ASSM.T2TEXTPT IS  NULL  AND T2ASSM.T2TEXTRO IS NOT NULL THEN 'RO' 
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS  NULL 
                                                                                AND T2ASSM.T2TEXTIT IS  NULL AND  T2ASSM.T2TEXTES IS  NULL  AND                 

T2ASSM.T2TEXTRU IS  NULL AND T2ASSM.T2TEXTNO IS  NULL  
                                                                                AND T2ASSM.T2TEXTPT IS  NULL  AND T2ASSM.T2TEXTRO IS  NULL AND                 

T2ASSM.T2TEXTCS IS NOT NULL THEN 'CS'
                                                                                WHEN  T2ASSM.T2TEXTEN  IS  NULL  AND T2ASSM.T2TEXTDE  IS  NULL  AND   T2ASSM.T2TEXTPL 

IS  NULL  AND T2ASSM.T2TEXTSV IS  NULL AND   T2ASSM.T2TEXTFR IS  NULL 
                                                                                AND T2ASSM.T2TEXTIT IS  NULL AND  T2ASSM.T2TEXTES IS  NULL  AND                 

T2ASSM.T2TEXTRU IS  NULL AND T2ASSM.T2TEXTNO IS  NULL  
                                                                                AND T2ASSM.T2TEXTPT IS  NULL  AND T2ASSM.T2TEXTRO IS  NULL AND                 

T2ASSM.T2TEXTCS IS  NULL AND  T2ASSM.T2TEXTCN IS NOT NULL THEN 'CN'
END AS LANGUAGE_CODE
,T3ODASAS.T2TEXT9X25 AS POSTXT1 
,T2ASSM.T2REMARKEN AS TEXT_REMARK
,T2ASSM.T2WEIGHTSTR AS  WEIGHT
,T2ASSM.T2SECURITYSTATE AS SECURITY_STATE      
,T2ASSM.CREATIONDATE AS ORIGINATED_DATE 
,T3ODASAS.T2DECISIONCODE AS T2DECISONCODE    
,T3ODASAS.UNITOFMEASURE AS UNITOFMEASURE
,T2ASSM.CREATOR AS CREATOR_SSO
,T2ASSM.LIFECYCLESTATE AS T2ASSM_LIFECYCLESTATE
,T2ASSM.T2APPROVEDDATE AS CHILD_T2APPROVEDDATE
,T3ODASAS.FINDNUMBER AS  FINDNUMBER  
,CAST(C.DFSORDER || '/' || T2ASSM.PARTNUMBER  AS VARCHAR(500)) AS DFSORDER
,CAST(C.LFSTATE_DFSORDER || '/' ||  T2ASSM.LIFECYCLESTATE  AS VARCHAR(1000))  AS  LFSTATE_DFSORDER
,CAST(C.DECIONCD_DFSORDER || '/' || T3ODASAS.T2DECISIONCODE AS VARCHAR(1000))  AS  DECIONCD_DFSORDER
,CASE WHEN   T2ASSM.T2RELEASEDLANG = 'Bps41' THEN 'EN + ZH'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps60' THEN 'EN + DE + PL'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps61' THEN 'PL + RU'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps67' THEN 'PL + DE'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps70' THEN 'FR + ES'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps81' THEN 'EN + DE + SV'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps82' THEN 'EN + SV'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps83' THEN 'EN + DE'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps84' THEN 'EN + FR + DE'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps85' THEN 'EN + FR'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps86' THEN 'EN + PL'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps87' THEN 'EN + IT'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps88' THEN 'EN + ES'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps89' THEN 'EN + RU'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bps90' THEN 'DE + FR'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpsen' THEN 'EN'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpsde' THEN 'DE'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpspl' THEN 'PL'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpssv' THEN 'SV'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpsfr' THEN 'FR'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpsit' THEN 'IT'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpses' THEN 'ES'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpsru' THEN 'RU'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpsno' THEN 'NO'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpspt' THEN 'PT'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpsro' THEN 'RO'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpscs' THEN 'CS'
							WHEN   T2ASSM.T2RELEASEDLANG = 'Bpscn' THEN 'ZH'
							ELSE  T2ASSM.T2RELEASEDLANG
END 		TRELEASEDLANG_CODE	
,T2ASSM.T2RELEASEDLANG		
FROM  HIER C
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2ASSM PARENT
ON C.CHILD_OBID=PARENT.OBID
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T3ODASAS T3ODASAS
ON  PARENT.OBID=T3ODASAS.LEFT1 AND  C.T3ORDERNUMBER=T3ODASAS.T3ORDERNUMBER
AND C.ORDERREVISION=T3ODASAS.REVISION
--INNER JOIN VT_MAX_REV_PARTS_DTTMRP T2ASSM 
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2ASSM T2ASSM 
ON T3ODASAS.RIGHT1=T2ASSM.OBID 
WHERE C.LVL <10
) 
SELECT DISTINCT
LVL,
REL_TYPE,
T2SPUNUMBER,
T2SPUNAME,
TOP_PART_IDNFR,
T3ORDERNUMBER,
ORDERREVISION,
PARENT_PART,
ITEM_IDNFR,
PROJECTNAME,
CLASS_NM,
CHILD_OBID,
CHILD_NAME,
CHILD_REV,
QUANTITY,
TEXTM,
LANGUAGE_CODE,
POSTXT1,
TEXT_REMARK,
WEIGHT,
CAST('' AS VARCHAR(275)) AS T2POSITIONNO,
SECURITY_STATE,
ORIGINATED_DATE,
T2DECISIONCODE,
UNITOFMEASURE,
CREATOR_SSO,
PART_LIFECYCLESTATE,
CHILD_T2APPROVEDDATE,
FINDNUMBER,
DFSORDER,
TRELEASEDLANG_CODE,
T2RELEASEDLANG,
CAST('' AS VARCHAR(275)) AS DOCUMENTTYPE
FROM HIER
) WITH DATA PRIMARY INDEX( CHILD_OBID) ON COMMIT PRESERVE ROWS;

COLLECT STATISTICS on VT_ORD_POC_DATA_DTTMRP  INDEX (CHILD_OBID);

----------------------Insert Additional Text data
INSERT  INTO VT_ORD_POC_DATA_DTTMRP
(
LVL
,REL_TYPE
,T2SPUNUMBER
,T2SPUNAME
,TOP_PART_IDNFR
,T3ORDERNUMBER
,PARENT_PART
,ITEM_IDNFR
,CLASS_NM
,POSTXT1
,LANGUAGE_CODE
,FINDNUMBER
,ORIGINATED_DATE
--,PART_LIFECYCLESTATE
--,DC
,DFSORDER
)
SELECT   DISTINCT
VT.LVL+1 AS LVL
,CAST('Part has add. text in Order (OHasT) ' AS VARCHAR(150)) AS REL_TYPE
,VT.T2SPUNUMBER
,VT.T2SPUNAME
,VT.TOP_PART_IDNFR
,VT.T3ORDERNUMBER
,VT.CHILD_NAME
,CAST('Additional Text' AS VARCHAR(120)) AS ITEM_IDNFR
,CAST('Additional Text'AS VARCHAR(30)) AS CLASS_NM
--,TXT_REL.T2TEXT9X25EN
,CASE 
                                                                                WHEN TXT_REL.T2TEXT9X25EN  IS NOT NULL THEN TXT_REL.T2TEXT9X25EN
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS NOT NULL THEN  

TXT_REL.T2TEXT9X25DE 
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS NOT NULL THEN  TXT_REL.T2TEXT9X25PL
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS NOT NULL THEN TXT_REL.T2TEXT9X25SV
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS NOT NULL THEN  TXT_REL.T2TEXT9X25FR 
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS NOT NULL THEN TXT_REL.T2TEXT9X25IT
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS NOT NULL THEN            

      TXT_REL.T2TEXT9X25ES                                                    
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS NOT NULL THEN TXT_REL.T2TEXT9X25RU
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS NOT NULL THEN              TXT_REL.T2TEXT9X25NO
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS NOT NULL THEN          TXT_REL.T2TEXT9X25PT
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS NOT NULL THEN            

     TXT_REL.T2TEXT9X25RO
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS  NULL AND                

 TXT_REL.T2TEXT9X25CS IS NOT NULL THEN TXT_REL.T2TEXT9X25CS
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS  NULL AND                

 TXT_REL.T2TEXT9X25CS IS  NULL AND  TXT_REL.T2TEXT9X25CN  IS NOT NULL THEN            TXT_REL.T2TEXT9X25CN                                                              

                                                                                                                                                                      
                                                                                END AS TEXTM
,CASE 
                                                                                WHEN TXT_REL.T2TEXT9X25EN  IS NOT NULL THEN 'EN'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS NOT NULL THEN  'DE'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS NOT NULL THEN  'PL'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS NOT NULL THEN 'SV'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS NOT NULL THEN  'FR'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS NOT NULL THEN 'IT' 
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS NOT NULL THEN            

      'ES'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS NOT NULL THEN 'RU'           
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS NOT NULL THEN              'NO'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS NOT NULL THEN          'PT'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS NOT NULL THEN 'RO'       

  
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS  NULL AND                

 TXT_REL.T2TEXT9X25CS IS NOT NULL THEN 'CS'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS  NULL AND                

 TXT_REL.T2TEXT9X25CS IS  NULL AND  TXT_REL.T2TEXT9X25CN IS NOT NULL THEN             'CN'
END AS LANGUAGE_CODE
,TXT_REL.FINDNUMBER
,MIN(TXT_REL.CREATIONDATE)
--,TXT_REL.LASTUPDATE
,CAST(VT.DFSORDER || '/' || TXT_REL.FINDNUMBER  AS VARCHAR(500)) AS DFSORDER
FROM VT_ORD_POC_DATA_DTTMRP VT
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2Assm PART
ON VT.CHILD_NAME = PART.PARTNUMBER AND VT.PROJECTNAME=PART.PROJECTNAME
AND VT.CHILD_REV=PART.REVISION
INNER JOIN  GEEDW_Q_PLP_BULK_V.CDR_RPDM_T3ODASTX  TXT_REL
ON PART.OBID=TXT_REL.LEFT1 AND  VT.T3ORDERNUMBER=TXT_REL.T3ORDERNUMBER
AND VT.ORDERREVISION=TXT_REL.REVISION
WHERE  VT.CLASS_NM='PART'
GROUP BY 
VT.LVL+1 
,CAST('Part has add. text in Order (OHasT) ' AS VARCHAR(30))
,VT.T2SPUNUMBER
,VT.T2SPUNAME
,VT.TOP_PART_IDNFR
,VT.T3ORDERNUMBER
,VT.CHILD_NAME
,CAST('Additional Text' AS VARCHAR(120)) 
,CAST('Additional Text'AS VARCHAR(30))  
,CASE 
                                                                                WHEN TXT_REL.T2TEXT9X25EN  IS NOT NULL THEN TXT_REL.T2TEXT9X25EN
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS NOT NULL THEN  

TXT_REL.T2TEXT9X25DE 
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS NOT NULL THEN  TXT_REL.T2TEXT9X25PL
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS NOT NULL THEN TXT_REL.T2TEXT9X25SV
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS NOT NULL THEN  TXT_REL.T2TEXT9X25FR 
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS NOT NULL THEN TXT_REL.T2TEXT9X25IT
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS NOT NULL THEN            

      TXT_REL.T2TEXT9X25ES                                                    
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS NOT NULL THEN TXT_REL.T2TEXT9X25RU
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS NOT NULL THEN              TXT_REL.T2TEXT9X25NO
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS NOT NULL THEN          TXT_REL.T2TEXT9X25PT
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS NOT NULL THEN            

     TXT_REL.T2TEXT9X25RO
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS  NULL AND                

 TXT_REL.T2TEXT9X25CS IS NOT NULL THEN TXT_REL.T2TEXT9X25CS
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS  NULL AND                

 TXT_REL.T2TEXT9X25CS IS  NULL AND  TXT_REL.T2TEXT9X25CN  IS NOT NULL THEN            TXT_REL.T2TEXT9X25CN                                                              

                                                                                                                                                                      
                                                                                END
,CASE 
                                                                                WHEN TXT_REL.T2TEXT9X25EN  IS NOT NULL THEN 'EN'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS NOT NULL THEN  'DE'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS NOT NULL THEN  'PL'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS NOT NULL THEN 'SV'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS NOT NULL THEN  'FR'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS NOT NULL THEN 'IT' 
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS NOT NULL THEN            

      'ES'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS NOT NULL THEN 'RU'           
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS NOT NULL THEN              'NO'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS NOT NULL THEN          'PT'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS NOT NULL THEN 'RO'       

  
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS  NULL AND                

 TXT_REL.T2TEXT9X25CS IS NOT NULL THEN 'CS'
                                                                                WHEN  TXT_REL.T2TEXT9X25EN  IS  NULL  AND TXT_REL.T2TEXT9X25DE  IS  NULL  AND   

TXT_REL.T2TEXT9X25PL IS  NULL  AND TXT_REL.T2TEXT9X25SV IS  NULL AND   TXT_REL.T2TEXT9X25FR IS  NULL 
                                                                                AND TXT_REL.T2TEXT9X25IT IS  NULL AND  TXT_REL.T2TEXT9X25ES IS  NULL  AND               

  TXT_REL.T2TEXT9X25RU IS  NULL AND TXT_REL.T2TEXT9X25NO IS  NULL  
                                                                                AND TXT_REL.T2TEXT9X25PT IS  NULL  AND TXT_REL.T2TEXT9X25RO IS  NULL AND                

 TXT_REL.T2TEXT9X25CS IS  NULL AND  TXT_REL.T2TEXT9X25CN IS NOT NULL THEN             'CN'
END
,TXT_REL.FINDNUMBER
,CAST(VT.DFSORDER  || '/' ||  TXT_REL.FINDNUMBER  AS VARCHAR(500)) ;

---------------------insert IT PLAN Data
INSERT  INTO VT_ORD_POC_DATA_DTTMRP
(
LVL,
REL_TYPE,
T2SPUNUMBER,
T2SPUNAME,
TOP_PART_IDNFR,
T3ORDERNUMBER,
PARENT_PART,
ITEM_IDNFR,
CLASS_NM,
CHILD_OBID,
CHILD_NAME,
CHILD_REV,
TEXTM,
LANGUAGE_CODE,
POSTXT1,
TEXT_REMARK,
SECURITY_STATE,
CREATOR_SSO,
PART_LIFECYCLESTATE,
ORIGINATED_DATE,
CHILD_T2APPROVEDDATE,
DFSORDER,
FINDNUMBER,
TRELEASEDLANG_CODE,
T2RELEASEDLANG
)

SELECT   DISTINCT
VT.LVL+1 as LVL
,CAST('Described by for Order (ODscB)' AS VARCHAR(150)) AS REL_TYPE
,VT.T2SPUNUMBER
,VT.T2SPUNAME
,VT.TOP_PART_IDNFR
,VT.T3ORDERNUMBER
,PART.PARTNUMBER  AS PARENT_PART
,CAST(T2TstPln.PARTNUMBER || ',' || T2TstPln.REVISION || ',' || T2TstPln.SEQUENCE  AS VARCHAR(120)) AS ITEM_IDNFR
,CAST('I+T Plan' AS VARCHAR(30)) AS CLASS_NM
,T2TstPln.OBID AS CHILD_OBID
,T2TstPln.PARTNUMBER AS CHILD_NAME
,T2TstPln.REVISION AS CHILD_REV
,COALESCE(T2TstPln.T2TEXTEN, T2TstPln.T2TEXTDE ,T2TstPln.T2TEXTPL,T2TstPln.T2TEXTSV, T2TstPln.T2TEXTFR , T2TstPln.T2TEXTIT
,T2TstPln.T2TEXTES, T2TstPln.T2TEXTRU,   T2TstPln.T2TEXTNO, T2TstPln.T2TEXTPT,T2TstPln.T2TEXTRO, T2TstPln.T2TEXTCS,T2TstPln.T2TEXTCN)  AS TEXTM
,CASE 
                                                                                WHEN T2TstPln.T2TEXTEN  IS NOT NULL THEN 'EN'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS NOT NULL THEN  'DE'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS NOT NULL THEN  'PL'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS NOT NULL THEN 'SV'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS NOT NULL THEN  'FR'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS  NULL 
                                                                                AND T2TstPln.T2TEXTIT IS NOT NULL THEN 'IT' 
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS  NULL 
                                                                                AND T2TstPln.T2TEXTIT IS  NULL AND  T2TstPln.T2TEXTES IS NOT NULL THEN          'ES'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS  NULL 
                                                                                AND T2TstPln.T2TEXTIT IS  NULL AND  T2TstPln.T2TEXTES IS  NULL  AND                 

T2TstPln.T2TEXTRU IS NOT NULL THEN 'RU'    
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS  NULL 
                                                                                AND T2TstPln.T2TEXTIT IS  NULL AND  T2TstPln.T2TEXTES IS  NULL  AND                 

T2TstPln.T2TEXTRU IS  NULL AND T2TstPln.T2TEXTNO IS NOT NULL THEN 'NO'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS  NULL 
                                                                                AND T2TstPln.T2TEXTIT IS  NULL AND  T2TstPln.T2TEXTES IS  NULL  AND                 

T2TstPln.T2TEXTRU IS  NULL AND T2TstPln.T2TEXTNO IS  NULL  
                                                                                AND T2TstPln.T2TEXTPT IS NOT NULL THEN    'PT'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS  NULL 
                                                                                AND T2TstPln.T2TEXTIT IS  NULL AND  T2TstPln.T2TEXTES IS  NULL  AND                 

T2TstPln.T2TEXTRU IS  NULL AND T2TstPln.T2TEXTNO IS  NULL  
                                                                                AND T2TstPln.T2TEXTPT IS  NULL  AND T2TstPln.T2TEXTRO IS NOT NULL THEN 'RO' 
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS  NULL 
                                                                                AND T2TstPln.T2TEXTIT IS  NULL AND  T2TstPln.T2TEXTES IS  NULL  AND                 

T2TstPln.T2TEXTRU IS  NULL AND T2TstPln.T2TEXTNO IS  NULL  
                                                                                AND T2TstPln.T2TEXTPT IS  NULL  AND T2TstPln.T2TEXTRO IS  NULL AND                 

T2TstPln.T2TEXTCS IS NOT NULL THEN 'CS'
                                                                                WHEN  T2TstPln.T2TEXTEN  IS  NULL  AND T2TstPln.T2TEXTDE  IS  NULL  AND   

T2TstPln.T2TEXTPL IS  NULL  AND T2TstPln.T2TEXTSV IS  NULL AND   T2TstPln.T2TEXTFR IS  NULL 
                                                                                AND T2TstPln.T2TEXTIT IS  NULL AND  T2TstPln.T2TEXTES IS  NULL  AND                 

T2TstPln.T2TEXTRU IS  NULL AND T2TstPln.T2TEXTNO IS  NULL  
                                                                                AND T2TstPln.T2TEXTPT IS  NULL  AND T2TstPln.T2TEXTRO IS  NULL AND                 

T2TstPln.T2TEXTCS IS  NULL AND  T2TstPln.T2TEXTCN IS NOT NULL THEN 'CN'
END AS LANGUAGE_CODE
,T2PTSTPL.T2TEXT9X25EN AS POSTXT
,T2TstPln.T2REMARKEN AS TEXT_REMARK
,T2TstPln.T2SECURITYSTATE AS SECURITY_STATE               
,T2TstPln.CREATOR AS CREATOR_SSO
,T2TstPln.LIFECYCLESTATE AS PART_LIFECYCLESTATE
,T2TstPln.CREATIONDATE
,T2TstPln.T2APPROVEDDATE AS CHILD_T2APPROVEDDATE
,CAST(VT.DFSORDER || '/' || T2TstPln.PARTNUMBER  AS VARCHAR(500))  AS  DFSORDER
,T3ODASTP.FINDNUMBER
,CASE WHEN   T2TstPln.T2RELEASEDLANG = 'Bps41' THEN 'EN + ZH'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps60' THEN 'EN + DE + PL'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps61' THEN 'PL + RU'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps67' THEN 'PL + DE'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps70' THEN 'FR + ES'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps81' THEN 'EN + DE + SV'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps82' THEN 'EN + SV'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps83' THEN 'EN + DE'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps84' THEN 'EN + FR + DE'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps85' THEN 'EN + FR'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps86' THEN 'EN + PL'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps87' THEN 'EN + IT'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps88' THEN 'EN + ES'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps89' THEN 'EN + RU'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bps90' THEN 'DE + FR'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpsen' THEN 'EN'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpsde' THEN 'DE'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpspl' THEN 'PL'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpssv' THEN 'SV'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpsfr' THEN 'FR'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpsit' THEN 'IT'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpses' THEN 'ES'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpsru' THEN 'RU'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpsno' THEN 'NO'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpspt' THEN 'PT'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpsro' THEN 'RO'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpscs' THEN 'CS'
							WHEN   T2TstPln.T2RELEASEDLANG = 'Bpscn' THEN 'ZH'
							ELSE  T2TstPln.T2RELEASEDLANG
END 		TRELEASEDLANG_CODE	
,T2TstPln.T2RELEASEDLANG	
FROM VT_ORD_POC_DATA_DTTMRP VT
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2Assm PART
ON VT.CHILD_NAME = PART.PARTNUMBER AND VT.PROJECTNAME=PART.PROJECTNAME
AND VT.CHILD_REV=PART.REVISION
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T3ODASTP T3ODASTP
ON PART.OBID=T3ODASTP.LEFT1  AND  VT.T3ORDERNUMBER=T3ODASTP.T3ORDERNUMBER
AND VT.ORDERREVISION=T3ODASTP.REVISION
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2TstPln T2TstPln
ON T3ODASTP.RIGHT1 = T2TstPln.OBID --AND T2TstPln.SUPERSEDED = '-'
AND T2TstPln.PARTNUMBER  NOT LIKE '%#%'
LEFT OUTER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2PTSTPL  T2PTSTPL
ON PART.OBID = T2PTSTPL.LEFT1;



-------- Insert I+T Step data

INSERT  INTO VT_ORD_POC_DATA_DTTMRP
(
LVL,
REL_TYPE,
T2SPUNUMBER,
T2SPUNAME,
TOP_PART_IDNFR,
T3ORDERNUMBER,
PARENT_PART,
ITEM_IDNFR,
CLASS_NM,
CHILD_OBID,
CHILD_REV,
PART_LIFECYCLESTATE,
SECURITY_STATE,
CREATOR_SSO,
ORIGINATED_DATE,
T2POSITIONNO,
DFSORDER
)

SELECT DISTINCT
VT.LVL+1 as lvl
,CAST('Has I+T Steps (HasSt)' AS VARCHAR(150)) AS REL_TYPE
,VT.T2SPUNUMBER
,VT.T2SPUNAME
,VT.TOP_PART_IDNFR
,VT.T3ORDERNUMBER
,IT_PLAN.PARTNUMBER AS PLAN_NAME
,CAST(T2IStep.T2ISTEPDESCEN  AS VARCHAR(120)) AS ITEM_IDNFR
, CAST('I+T Step' AS VARCHAR(30))  AS CLASS_NM
,T2IStep.OBID AS CHILD_OBID
--,T2IStep.T2ISTEPDESCEN AS CHILD_NAME
,'-' AS CHILD_REV
,T2IStep.LIFECYCLESTATE
,T2IStep.T2SECURITYSTATE AS SECURITY_STATE               
,T2IStep.CREATOR AS CREATOR_SSO
,T2IStep.CREATIONDATE
,T2TplIsR.T2POSITIONNO                  
,CAST(VT.DFSORDER || '/' || T2IStep.T2ISTEPDESCEN  AS VARCHAR(500))  AS  DFSORDER
FROM VT_ORD_POC_DATA_DTTMRP VT
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2TstPln IT_PLAN
ON VT.CHILD_OBID = IT_PLAN.OBID
--AND IT_PLAN.SUPERSEDED = '-'
AND IT_PLAN.PARTNUMBER NOT LIKE '%#%'
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2TplIsR T2TplIsR
ON IT_PLAN.OBID = T2TplIsR.LEFT1 --AND IT_PLAN.SUPERSEDED = '-' --AND VT.TOP_PART=T2TplIsR.T3ORDERNUMBER
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2IStep T2IStep
ON T2TplIsR.RIGHT1=T2IStep.OBID  AND T2IStep.SUPERSEDED = '-'
where vt.class_nm='I+T Plan'	;

COLLECT STATISTICS on VT_ORD_POC_DATA_DTTMRP  INDEX (CHILD_OBID);

---------------------------Insert  Part to Document  Data
INSERT  INTO VT_ORD_POC_DATA_DTTMRP
(
LVL,
REL_TYPE,
T2SPUNUMBER,
T2SPUNAME,
TOP_PART_IDNFR,
T3ORDERNUMBER,
PARENT_PART,
ITEM_IDNFR,
PROJECTNAME,
CLASS_NM,
CHILD_OBID,
CHILD_NAME,
CHILD_REV,
TEXTM,
LANGUAGE_CODE,
TEXT_REMARK,
SECURITY_STATE,
ORIGINATED_DATE,
CREATOR_SSO,
PART_LIFECYCLESTATE,
CHILD_T2APPROVEDDATE,
DOCUMENTTYPE,
DFSORDER
,FINDNUMBER
,TRELEASEDLANG_CODE
,T2RELEASEDLANG
)

SELECT DISTINCT
VT.LVL+1 AS LVL
,CAST('Described by for Order (ODscB)' AS VARCHAR(150)) AS REL_TYPE
,VT.T2SPUNUMBER
,VT.T2SPUNAME
,VT.TOP_PART_IDNFR
,VT.T3ORDERNUMBER
,VT. CHILD_NAME
,CAST(T2STRPUB.PARTNUMBER|| ', ' ||T2STRPUB.REVISION|| ', ' ||T2STRPUB.SEQUENCE  AS VARCHAR(250)) AS  ITEM_IDNFR
,T2STRPUB.PROJECTNAME AS PROJECTNAME
,CASE WHEN  T3ODASDC.CLASS2= 'T2StrDoc' THEN CAST('Document' AS VARCHAR(30))
WHEN T3ODASDC.CLASS2= 'T2PubStd' THEN CAST('Public Standard' AS VARCHAR(30))
END AS CLASS_NM

--,CAST('Document' AS VARCHAR(30)) AS CLASS_NM
,T2STRPUB.OBID AS CHILD_OBID
,T2STRPUB.PARTNUMBER AS CHILD_NAME
,T2STRPUB.REVISION AS CHILD_REV
,COALESCE(T2STRPUB.T2TEXTEN, T2STRPUB.T2TEXTDE ,T2STRPUB.T2TEXTPL,T2STRPUB.T2TEXTSV, T2STRPUB.T2TEXTFR , T2STRPUB.T2TEXTIT
,T2STRPUB.T2TEXTES, T2STRPUB.T2TEXTRU,   T2STRPUB.T2TEXTNO, T2STRPUB.T2TEXTPT,T2STRPUB.T2TEXTRO, T2STRPUB.T2TEXTCS,T2STRPUB.T2TEXTCN) AS TEXTM
,CASE 
                                                                                WHEN T2STRPUB.T2TEXTEN  IS NOT NULL THEN 'EN'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS NOT NULL THEN  'DE'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS NOT NULL THEN  'PL'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS NOT NULL THEN 'SV'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS NOT NULL THEN  'FR'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS NOT NULL THEN 'IT' 
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS NOT NULL THEN  'ES'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS NOT NULL THEN 'RU' 
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS NOT NULL THEN        'NO'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS  NULL  
                                                                                AND T2STRPUB.T2TEXTPT IS NOT NULL THEN                'PT'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS  NULL  
                                                                                AND T2STRPUB.T2TEXTPT IS  NULL  AND T2STRPUB.T2TEXTRO IS NOT NULL THEN 'RO'             

   
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS  NULL  
                                                                                AND T2STRPUB.T2TEXTPT IS  NULL  AND T2STRPUB.T2TEXTRO IS  NULL AND                 

T2STRPUB.T2TEXTCS IS NOT NULL THEN 'CS'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS  NULL  
                                                                                AND T2STRPUB.T2TEXTPT IS  NULL  AND T2STRPUB.T2TEXTRO IS  NULL AND                 

T2STRPUB.T2TEXTCS IS  NULL AND  T2STRPUB.T2TEXTCN IS NOT NULL THEN        'CN'
                                                                                END AS LANGUAGE_CODE
,T2STRPUB.T2REMARKEN AS TEXT_REMARK

,T2STRPUB.T2SECURITYSTATE AS SECURITY_STATE      
,T2STRPUB.CREATIONDATE AS ORIGINATED_DATE 
,T2STRPUB.CREATOR AS CREATOR_SSO
,T2STRPUB.LIFECYCLESTATE AS PART_LIFECYCLESTATE
,T2STRPUB.T2APPROVEDDATE AS CHILD_T2APPROVEDDATE
,T2STRPUB.DOCUMENTTYPE AS DOCUMENTTYPE
,CAST(VT.DFSORDER || '/' || T2STRPUB.PARTNUMBER AS VARCHAR(500))  AS  DFSORDER 
,T3ODASDC.FINDNUMBER 
,CASE WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps41' THEN 'EN + ZH'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps60' THEN 'EN + DE + PL'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps61' THEN 'PL + RU'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps67' THEN 'PL + DE'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps70' THEN 'FR + ES'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps81' THEN 'EN + DE + SV'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps82' THEN 'EN + SV'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps83' THEN 'EN + DE'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps84' THEN 'EN + FR + DE'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps85' THEN 'EN + FR'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps86' THEN 'EN + PL'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps87' THEN 'EN + IT'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps88' THEN 'EN + ES'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps89' THEN 'EN + RU'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps90' THEN 'DE + FR'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsen' THEN 'EN'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsde' THEN 'DE'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpspl' THEN 'PL'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpssv' THEN 'SV'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsfr' THEN 'FR'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsit' THEN 'IT'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpses' THEN 'ES'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsru' THEN 'RU'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsno' THEN 'NO'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpspt' THEN 'PT'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsro' THEN 'RO'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpscs' THEN 'CS'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpscn' THEN 'ZH'
							ELSE  T2STRPUB.T2RELEASEDLANG
END 		TRELEASEDLANG_CODE	
,T2STRPUB.T2RELEASEDLANG		
FROM VT_ORD_POC_DATA_DTTMRP VT
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2ASSM PART
ON VT.CHILD_OBID=PART.OBID
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T3ODASDC T3ODASDC
ON PART.OBID=T3ODASDC.LEFT1  AND  VT.T3ORDERNUMBER=T3ODASDC.T3ORDERNUMBER
AND VT.ORDERREVISION=T3ODASDC.REVISION
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2STRPUB  T2STRPUB
ON T3ODASDC.RIGHT1=T2STRPUB.OBID AND   T3ODASDC.CLASS2 IN ('T2StrDoc', 'T2PubStd')
WHERE VT.CLASS_NM = 'PART';

COLLECT STATISTICS on VT_ORD_POC_DATA_DTTMRP  INDEX (CHILD_OBID);

---I+T Step to Documents

---I+T Step to Documents

---I+T Step to Documents
INSERT  INTO VT_ORD_POC_DATA_DTTMRP
(
LVL,
REL_TYPE,
T2SPUNUMBER,
T2SPUNAME,
TOP_PART_IDNFR,
T3ORDERNUMBER,
PARENT_PART,
ITEM_IDNFR,
PROJECTNAME,
CLASS_NM,
CHILD_OBID,
CHILD_NAME,
CHILD_REV,
TEXTM,
LANGUAGE_CODE,
TEXT_REMARK,
SECURITY_STATE,
ORIGINATED_DATE,
CREATOR_SSO,
PART_LIFECYCLESTATE,
CHILD_T2APPROVEDDATE,
DOCUMENTTYPE,
DFSORDER,
TRELEASEDLANG_CODE,
T2RELEASEDLANG
)
SELECT DISTINCT
P.LVL
,P.REL_TYPE
,T.T2SPUNUMBER
,T.T2SPUNAME
,T.TOP_PART_IDNFR
,T.T3ORDERNUMBER
,T.PARENT_PART
,P.ITEM_IDNFR
,P.PROJECTNAME
,p.CLASS_NM
,P.CHILD_OBID
,P.CHILD_NAME
,P.CHILD_REV
,P.TEXTM
,P.LANGUAGE_CODE
,P.TEXT_REMARK
,P.SECURITY_STATE
,P.ORIGINATED_DATE
,P.CREATOR_SSO
,P.PART_LIFECYCLESTATE
,P.CHILD_T2APPROVEDDATE
,P.DOCUMENTTYPE
,P.DFSORDER
,TRELEASEDLANG_CODE
,T2RELEASEDLANG
FROM
(
SELECT DISTINCT
VT.TOP_PART_IDNFR
,VT.T2SPUNUMBER
,VT.T2SPUNAME
,VT.T3ORDERNUMBER
,IT_PLAN.PARTNUMBER AS PARENT_PART
,T2IStep.OBID AS STEP_OBID
FROM VT_ORD_POC_DATA_DTTMRP VT
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2TstPln IT_PLAN
ON VT.CHILD_OBID = IT_PLAN.OBID
--AND IT_PLAN.SUPERSEDED = '-'
AND IT_PLAN.PARTNUMBER NOT LIKE '%#%'
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2TplIsR T2TplIsR
ON IT_PLAN.OBID = T2TplIsR.LEFT1 --AND IT_PLAN.SUPERSEDED = '-' --AND VT.TOP_PART=T2TplIsR.T3ORDERNUMBER
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2IStep T2IStep
ON T2TplIsR.RIGHT1=T2IStep.OBID  AND T2IStep.SUPERSEDED = '-'
where vt.class_nm='I+T Plan'
) T
INNER JOIN
(
SELECT DISTINCT
VT.LVL+1 AS LVL
,CAST('has Documents for Order (ODscB)' AS VARCHAR(150)) AS REL_TYPE
,VT.T2SPUNUMBER
,VT.TOP_PART_IDNFR
,VT.T3ORDERNUMBER
,CAST(T2STRPUB.PARTNUMBER|| ', ' ||T2STRPUB.REVISION|| ', ' ||T2STRPUB.SEQUENCE  AS VARCHAR(250)) AS  ITEM_IDNFR
,T2STRPUB.PROJECTNAME AS PROJECTNAME
,CASE WHEN  T3ODISDC.CLASS2 = 'T2StrDoc' THEN CAST('Document' AS VARCHAR(30))
WHEN  T3ODISDC.CLASS2 = 'T2PubStd' THEN CAST('Public Standard' AS VARCHAR(30))
END AS CLASS_NM
--,CAST('Document' AS VARCHAR(30)) AS CLASS_NM
,T2STRPUB.OBID AS CHILD_OBID
,T2STRPUB.PARTNUMBER AS CHILD_NAME
,T2STRPUB.REVISION AS CHILD_REV
,COALESCE(T2STRPUB.T2TEXTEN, T2STRPUB.T2TEXTDE ,T2STRPUB.T2TEXTPL,T2STRPUB.T2TEXTSV, T2STRPUB.T2TEXTFR , T2STRPUB.T2TEXTIT
,T2STRPUB.T2TEXTES, T2STRPUB.T2TEXTRU,   T2STRPUB.T2TEXTNO, T2STRPUB.T2TEXTPT,T2STRPUB.T2TEXTRO, T2STRPUB.T2TEXTCS,T2STRPUB.T2TEXTCN) AS TEXTM
,CASE 
                                                                                WHEN T2STRPUB.T2TEXTEN  IS NOT NULL THEN 'EN'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS NOT NULL THEN  'DE'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS NOT NULL THEN  'PL'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS NOT NULL THEN 'SV'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS NOT NULL THEN  'FR'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS NOT NULL THEN 'IT' 
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS NOT NULL THEN  'ES'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS NOT NULL THEN 'RU' 
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS NOT NULL THEN        'NO'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS  NULL  
                                                                                AND T2STRPUB.T2TEXTPT IS NOT NULL THEN                'PT'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS  NULL  
                                                                                AND T2STRPUB.T2TEXTPT IS  NULL  AND T2STRPUB.T2TEXTRO IS NOT NULL THEN 'RO'             

   
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS  NULL  
                                                                                AND T2STRPUB.T2TEXTPT IS  NULL  AND T2STRPUB.T2TEXTRO IS  NULL AND                 

T2STRPUB.T2TEXTCS IS NOT NULL THEN 'CS'
                                                                                WHEN  T2STRPUB.T2TEXTEN  IS  NULL  AND T2STRPUB.T2TEXTDE  IS  NULL  AND   

T2STRPUB.T2TEXTPL IS  NULL  AND T2STRPUB.T2TEXTSV IS  NULL AND   T2STRPUB.T2TEXTFR IS  NULL 
                                                                                AND T2STRPUB.T2TEXTIT IS  NULL AND  T2STRPUB.T2TEXTES IS  NULL  AND                 

T2STRPUB.T2TEXTRU IS  NULL AND T2STRPUB.T2TEXTNO IS  NULL  
                                                                                AND T2STRPUB.T2TEXTPT IS  NULL  AND T2STRPUB.T2TEXTRO IS  NULL AND                 

T2STRPUB.T2TEXTCS IS  NULL AND  T2STRPUB.T2TEXTCN IS NOT NULL THEN        'CN'
                                                                                END AS LANGUAGE_CODE
,T2STRPUB.T2REMARKEN AS TEXT_REMARK

,T2STRPUB.T2SECURITYSTATE AS SECURITY_STATE      
,T2STRPUB.CREATIONDATE AS ORIGINATED_DATE 
,T2STRPUB.CREATOR AS CREATOR_SSO
,T2STRPUB.LIFECYCLESTATE AS PART_LIFECYCLESTATE
,T2STRPUB.T2APPROVEDDATE AS CHILD_T2APPROVEDDATE
,T2STRPUB.DOCUMENTTYPE AS DOCUMENTTYPE
,CAST(VT.DFSORDER || '/' || T2STRPUB.PARTNUMBER AS VARCHAR(500))  AS  DFSORDER  
,T2ISTEP.OBID AS STEP_ID
,CASE WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps41' THEN 'EN + ZH'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps60' THEN 'EN + DE + PL'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps61' THEN 'PL + RU'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps67' THEN 'PL + DE'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps70' THEN 'FR + ES'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps81' THEN 'EN + DE + SV'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps82' THEN 'EN + SV'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps83' THEN 'EN + DE'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps84' THEN 'EN + FR + DE'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps85' THEN 'EN + FR'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps86' THEN 'EN + PL'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps87' THEN 'EN + IT'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps88' THEN 'EN + ES'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps89' THEN 'EN + RU'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bps90' THEN 'DE + FR'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsen' THEN 'EN'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsde' THEN 'DE'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpspl' THEN 'PL'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpssv' THEN 'SV'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsfr' THEN 'FR'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsit' THEN 'IT'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpses' THEN 'ES'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsru' THEN 'RU'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsno' THEN 'NO'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpspt' THEN 'PT'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpsro' THEN 'RO'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpscs' THEN 'CS'
							WHEN   T2STRPUB.T2RELEASEDLANG = 'Bpscn' THEN 'ZH'
							ELSE  T2STRPUB.T2RELEASEDLANG
END 		TRELEASEDLANG_CODE	
,T2STRPUB.T2RELEASEDLANG		
FROM VT_ORD_POC_DATA_DTTMRP VT
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2IStep T2IStep
ON VT.CHILD_OBID=T2IStep.OBID  
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T3ODISDC T3ODISDC
ON T2IStep.OBID=T3ODISDC.LEFT1  AND  VT.T3ORDERNUMBER=T3ODISDC.T3ORDERNUMBER
--AND VT.ORDERREVISION=T3ODISDC.REVISION
INNER JOIN GEEDW_Q_PLP_BULK_V.CDR_RPDM_T2STRPUB  T2STRPUB
ON T3ODISDC.RIGHT1=T2STRPUB.OBID AND   T3ODISDC.CLASS2 IN ('T2StrDoc', 'T2PubStd')  AND   T3ODISDC.CLASS1='T2IStep'
WHERE VT.CLASS_NM='I+T STEP'
)P
ON T.STEP_OBID=P.STEP_ID;

INSERT INTO GEEDW_Q_PLP_BULK_T.MT_RPDM_SYS_POC_DATA
(
LVL	,
REL_TYPE	,
T2SPUNUMBER	,
T2SPUNAME	,
TOP_PART_IDNFR	,
T3ORDERNUMBER	,
ORDERREVISION	,
PARENT_PART	,
ITEM_IDNFR	,
PROJECTNAME	,
CLASS_NM	,
CHILD_OBID	,
CHILD_NAME	,
CHILD_REV	,
QUANTITY	,
TEXTM	,
LANGUAGE_CODE	,
POSTXT1	,
TEXT_REMARK	,
WEIGHT	,
T2POSITIONNO	,
SECURITY_STATE	,
ORIGINATED_DATE	,
T2DECISIONCODE	,
UNITOFMEASURE	,
CREATOR_SSO	,
PART_LIFECYCLESTATE	,
CHILD_T2APPROVEDDATE	,
FINDNUMBER	,
DFSORDER	,
TRELEASEDLANG_CODE	,
T2RELEASEDLANG	,
DOCUMENTTYPE,
DW_LOAD_DTTM,
DW_CREATED_BY,
DW_UPDATED_DTTM,
DW_UPDATED_BY
)
SELECT
LVL	,
REL_TYPE	,
T2SPUNUMBER	,
T2SPUNAME	,
TOP_PART_IDNFR	,
T3ORDERNUMBER	,
ORDERREVISION	,
PARENT_PART	,
ITEM_IDNFR	,
PROJECTNAME	,
CLASS_NM	,
CHILD_OBID	,
CHILD_NAME	,
CHILD_REV	,
QUANTITY	,
TEXTM	,
LANGUAGE_CODE	,
POSTXT1	,
TEXT_REMARK	,
WEIGHT	,
T2POSITIONNO	,
SECURITY_STATE	,
ORIGINATED_DATE	,
T2DECISIONCODE	,
UNITOFMEASURE	,
CREATOR_SSO	,
PART_LIFECYCLESTATE	,
CHILD_T2APPROVEDDATE	,
FINDNUMBER	,
DFSORDER	,
TRELEASEDLANG_CODE	,
T2RELEASEDLANG	,
DOCUMENTTYPE,
CAST(current_timestamp(0 )AS timestamp(0) FORMAT 'MM/DD/YYYYBHH:MI:SS')  AS DW_LOAD_DTTM,
'CDR' AS DW_CREATED_BY,
CAST(current_timestamp(0 )AS timestamp(0) FORMAT 'MM/DD/YYYYBHH:MI:SS') AS DW_UPDATED_DTTM,
'CDR'    AS DW_UPDATED_BY  	
FROM  VT_ORD_POC_DATA_DTTMRP;

COLLECT STATISTICS ON GEEDW_Q_PLP_BULK_T.MT_RPDM_SYS_POC_DATA  INDEX (CHILD_NAME);

DROP TABLE VT_ORD_POC_DATA_DTTMRP;

eof

done < $UPLOAD_FILE

fi
