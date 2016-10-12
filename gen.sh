export T0=10
export model=prem_ani
export nproc=24
export wtime="1:0:0"
export jname=xx

if [ $((${nproc}%24)) -gt 0 ]; then
    export nnode=$((${nproc}/24+1))
else
    export nnode=$((${nproc}/24))    
fi

rsync -r template/ ../AxiSEM3D_RUNS/${jname}/
perl -pi -w -e "s/__t0__/${T0}/g;"            ../AxiSEM3D_RUNS/${jname}/input/CMTSOLUTION
perl -pi -w -e "s/__t0__/${T0}/g;"            ../AxiSEM3D_RUNS/${jname}/input/inparam.basic
perl -pi -w -e "s/__model__/${model}/g;"      ../AxiSEM3D_RUNS/${jname}/input/inparam.basic
perl -pi -w -e "s/__NPROC__/${nproc}/g;"      ../AxiSEM3D_RUNS/${jname}/axi.bolt
perl -pi -w -e "s/__NNODE__/${nnode}/g;"      ../AxiSEM3D_RUNS/${jname}/axi.bolt
perl -pi -w -e "s/__JOBNAME__/${jname}/g;"    ../AxiSEM3D_RUNS/${jname}/axi.bolt
perl -pi -w -e "s/__WALLTIME__/${wtime}/g;"   ../AxiSEM3D_RUNS/${jname}/axi.bolt

