#!/bin/bash -l
for todo in  OneHill100lowU5N10Amp305f141B059Rough OneHill100lowU5N10Amp305f141B059Sm200 OneHill100lowU5N10Amp305f141B059SmNoDrag
do
    day=86400
    jobid=$(sbatch -J $todo --export=start=$((day*0)),stop=$((day*6 + 180)),dt=90 runModel.sh)
    #echo $jobid
    jobid1=$(sbatch  -J $todo --dependency=afterok:${jobid##* } --export=start=$((day*6)),stop=$((day*12 + 180)),dt=90 runModel.sh)
    jobid2=$(sbatch  -J $todo --dependency=afterok:${jobid1##* } --export=start=$((day*12)),stop=$((day*18 + 180)),dt=90 runModel.sh)
    jobid3=$(sbatch  -J $todo --dependency=afterok:${jobid2##* } --export=start=$((day*18)),stop=$((day*24 + 180)),dt=90 runModel.sh)
    #jobid4=$(sbatch  -J $todo --dependency=afterok:${jobid3##* } --export=start=$((day*24)),stop=$((day*30 + 180)),dt=90 runModelRestarts.sh)
    #jobid5=$(sbatch  -J $todo --dependency=afterok:${jobid4##* } --export=start=$((day*30)),stop=$((day*36 + 180)),dt=90 runModelRestarts.sh)
    jobidEnd=$(sbatch  -J $todo --dependency=afterok:${jobid3##* }  ../python/rungetWorkMean.sh)
    # store info in a file
    echo "$todo queued ${jobid##* } ${jobid1##* } ${jobid2##* } ${jobid3##* } ${jobidEnd##* }" >> .joblog
done



# should add archive step in here once we get going....
