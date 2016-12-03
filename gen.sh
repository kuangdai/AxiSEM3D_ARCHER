# model
export model=prem_ani_spherical_2D_10s.e
export att_spec=true
# source
export cmt=CMTSOLUTION_XJCh_GCMT
export station=STATIONS_XJCh
# simulation
export nproc=1536
export wtime="3:0:0"
export subdir="nxj"
export jname=gcmt_10_oldatt


# copy
mkdir ../AxiSEM3D_RUNS/${subdir}
mkdir ../AxiSEM3D_RUNS/${subdir}/${jname}
rsync -r --force --delete template/ ../AxiSEM3D_RUNS/${subdir}/${jname}/

# model
perl -pi -w -e "s/__model__/${model}/g;"      ../AxiSEM3D_RUNS/${subdir}/${jname}/input/inparam.model
if [ ${att_spec} == true ]; then
    perl -pi -w -e "s/__att_specfem__/true/g;"      ../AxiSEM3D_RUNS/${subdir}/${jname}/input/inparam.advanced
    perl -pi -w -e "s/__att_kappa__/false/g;"      ../AxiSEM3D_RUNS/${subdir}/${jname}/input/inparam.advanced
    cp meshes_nr3/${model} ../AxiSEM3D_RUNS/${subdir}/${jname}/input/
else
    perl -pi -w -e "s/__att_specfem__/false/g;"      ../AxiSEM3D_RUNS/${subdir}/${jname}/input/inparam.advanced
    perl -pi -w -e "s/__att_kappa__/true/g;"      ../AxiSEM3D_RUNS/${subdir}/${jname}/input/inparam.advanced
    cp meshes_nr5/${model} ../AxiSEM3D_RUNS/${subdir}/${jname}/input/
fi

# source
cp template/cmt_sta/${cmt} ../AxiSEM3D_RUNS/${subdir}/${jname}/input/CMTSOLUTION
cp template/cmt_sta/${station} ../AxiSEM3D_RUNS/${subdir}/${jname}/input/STATIONS

# simulation
if [ $((${nproc}%24)) -gt 0 ]; then
    export nnode=$((${nproc}/24+1))
else
    export nnode=$((${nproc}/24))    
fi
perl -pi -w -e "s/__NPROC__/${nproc}/g;"      ../AxiSEM3D_RUNS/${subdir}/${jname}/axi.bolt
perl -pi -w -e "s/__NNODE__/${nnode}/g;"      ../AxiSEM3D_RUNS/${subdir}/${jname}/axi.bolt
perl -pi -w -e "s/__JOBNAME__/${jname}/g;"    ../AxiSEM3D_RUNS/${subdir}/${jname}/axi.bolt
perl -pi -w -e "s/__SUBDIR__/${subdir}/g;"    ../AxiSEM3D_RUNS/${subdir}/${jname}/axi.bolt
perl -pi -w -e "s/__WALLTIME__/${wtime}/g;"   ../AxiSEM3D_RUNS/${subdir}/${jname}/axi.bolt
perl -pi -w -e "s/__JOBNAME__/${jname}/g;"    ../AxiSEM3D_RUNS/${subdir}/${jname}/tar.bolt
perl -pi -w -e "s/__SUBDIR__/${subdir}/g;"    ../AxiSEM3D_RUNS/${subdir}/${jname}/tar.bolt
