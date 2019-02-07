# --------------------------------------------------------------------------------------------------------------#
# File: sh_GEEDW_BTEQ_RPDM_TOP_PART_ORDER.sh									#
# Creation Date: 23-JAN-2019											#
# Last Modified: 23-JAN-2019											#
# Purpose: Populate list of TOP PART to load the Order Data        				                #
# Created By: Sumanta Bhujabal											#
# --------------------------------------------------------------------------------------------------------------#

. /data/informatica/ETCOE/EEDW01/SrcFiles/dbenv.sh
bteq << eof 
/*.RUN File = /apps/informatica/product/pc/bin/td_geedw_plp.mlbt; */
 .RUN File = /data/informatica/ETCOE/EEDW01/SrcFiles/td_plp.mlbt 
database ${Bulk_database};

.set titledashes off;
.set width 10000;
.if errorcode != 0 then .exit 1;
.os rm /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_TOP_PART_ORDER.DAT;

.export report file = /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_TOP_PART_ORDER.DAT


SELECT DISTINCT  
''''||PART1.PARTNUMBER||'''' (TITLE '') 
FROM GEEDW_Q_PLP_BULK_T.MT_RPDM_SYS_ORD_LVL1_DATA VT
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
WHERE CLASS_NM='Order';

.export reset;
.IF ERRORCODE <> 0 THEN .EXIT ERRORCODE;
.LOGOFF;
.EXIT;
eof
chmod 0777 /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_TOP_PART_ORDER.DAT
