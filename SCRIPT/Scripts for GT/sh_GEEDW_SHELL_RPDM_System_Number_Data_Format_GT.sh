chmod 0777 /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_SYSTEM_NUMBERS_GT.DAT
sed -i ':a;N;$!ba;s/\n/,/g' /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_SYSTEM_NUMBERS_GT.DAT
sed -i 's/\(\([^,]*,\)\{2\}[^,]*\),/\1\n/g' /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_SYSTEM_NUMBERS_GT.DAT
chmod 0777 /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_SYSTEM_NUMBERS_GT.DAT
