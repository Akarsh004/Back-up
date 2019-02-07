chmod 0777 /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_TOP_PART_ORDER.DAT
sed -i ':a;N;$!ba;s/\n/,/g' /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_TOP_PART_ORDER.DAT
sed -i 's/\(\([^,]*,\)\{9\}[^,]*\),/\1\n/g' /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_TOP_PART_ORDER.DAT
chmod 0777 /data/informatica/ETCOE/EEDW01/SrcFiles/RPDM_TOP_PART_ORDER.DAT
