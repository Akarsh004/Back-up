# --------------------------------------------------------------------------------------------------------------#
# File: sh_GEEDW_BTEQ_RPDM_SYSTEM_NUMBER_GT.sh									#
# Creation Date: 10-JAN-2018											#
# Last Modified: 10-JAN-2018											#
# Purpose: Populate list of RPDM System numbers	by joining with Assert into BV					#
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
.os rm /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_SYSTEM_NUMBERS_ST.DAT;

.export report file = /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_SYSTEM_NUMBERS_ST.DAT

collect stats column ( SYSTEM_NM ) on GEEDW_PLP_BULK_T.MT_RPDM_T2SYSTEM_INSTANCE_ST;
collect stats column ( T2SPUNUMBER ) on GEEDW_PLP_BULK_T.MT_RPDM_T2SYSTEM_INSTANCE_ST;


SELECT DISTINCT    ''''||INSTNCE.PARTNUMBER||'''' (TITLE '') 
FROM GEEDW_PLP_BV.ASSETINFO A
INNER JOIN GEEDW_PLP_BULK_V.CDR_RPDM_T2SYSTEM B
ON (A.EQUIPMENT_SYS_ID=B.T2SPUNUMBER OR A.EQUIPMENT_SYS_ID=B.T2POSEIDONNUMBER)
INNER JOIN  	GEEDW_PLP_BULK_V.CDR_RPDM_T4SyAS  T4SyAS		
ON 	B.OBID=T4SyAS.LEFT1 AND T4SyAS.CLASS1='T2System'
INNER JOIN  GEEDW_PLP_BULK_V.CDR_RPDM_T4ASSM INSTNCE
ON T4SyAS.RIGHT1=INSTNCE.OBID  AND T4SyAS.CLASS2='T4Assm'
WHERE B.T2SYSTEMCODE LIKE '%ST%'
--AND INSTNCE.PARTNUMBER='INS001011902729'
MINUS
SELECT DISTINCT    ''''||GT1.T2SPUNUMBER||'''' (TITLE '') 
FROM GEEDW_PLP_BV.ASSETINFO A
INNER JOIN GEEDW_PLP_BULK_V.CDR_RPDM_T2SYSTEM B
ON (A.EQUIPMENT_SYS_ID=B.T2SPUNUMBER OR A.EQUIPMENT_SYS_ID=B.T2POSEIDONNUMBER)
INNER JOIN  	GEEDW_PLP_BULK_V.CDR_RPDM_T4SyAS  T4SyAS		
ON 	B.OBID=T4SyAS.LEFT1 AND T4SyAS.CLASS1='T2System'
INNER JOIN  GEEDW_PLP_BULK_V.CDR_RPDM_T4ASSM INSTNCE
ON T4SyAS.RIGHT1=INSTNCE.OBID  AND T4SyAS.CLASS2='T4Assm'
INNER JOIN  GEEDW_PLP_BULK_V.MT_RPDM_T2SYSTEM_INSTANCE_ST GT1
ON  INSTNCE.PARTNUMBER=GT1.T2SPUNUMBER
WHERE B.T2SYSTEMCODE LIKE '%ST%'
AND GT1.LVL=1;

.export reset;
.IF ERRORCODE <> 0 THEN .EXIT ERRORCODE;
.LOGOFF;
.EXIT;
eof
chmod 0777 /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_SYSTEM_NUMBERS_ST.DAT
