import os
import subprocess

dt=90
timetorun = "0-11:30"  # this _should_ override what is in runModel.sh

for todo in ['OneHill100lowU5N10Amp305f141B059SmNoDrag']:
    day=86400
    ddays = 6
    outstr = f"{todo} queued "
    res = subprocess.check_output(["sbatch", f"-J {todo}",
                         f"--export=start={day*15},stop={day*18 + 180},dt={dt}",
                         f"--time={timetorun}",
                         "runModel.sh"])
    job = res.decode('utf8').split()[-1]
    outstr += f"{job} "
    for i in range(3, 4):
        res = subprocess.check_output(["sbatch", f"-J {todo}",
                         f"--dependency=afterok:{job}",
                         f"--export=start={day*ddays*i},stop={day*ddays*(i+1) + 180},dt={dt}",
                         f"--time={timetorun}",
                         "runModel.sh"])
        job = res.decode('utf8').split()[-1]
        outstr += f"{job} "
    res = subprocess.check_output(["sbatch", f"-J post{todo}",
                         f"--dependency=afterok:{job}",
                         f"../python/rungetWorkMean.sh"])
    job = res.decode('utf8').split()[-1]
    outstr += f"{job} "
    # store info in a file
    print(outstr)
    with open(".joblog", "a") as joblog:
        joblog.write(outstr+"\n")