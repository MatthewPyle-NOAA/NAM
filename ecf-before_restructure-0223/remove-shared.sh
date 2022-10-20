cd /lfs/h1/ops/para/packages/nam.v4.2.0/ecf
for file in `find . -type f |grep \.ecf$|grep -v -e /noused/`
do
   grep -l "%QUEUE%_shared" $file >/dev/null
   err=$?

   if [ $err -eq 0 ]
   then
      echo "Remove shared from queue for $file"
      #grep  "%QUEUE%_shared" $file
      perl -pi -e "s/\%QUEUE\%_shared/\%QUEUE\%/" $file
   fi
done

