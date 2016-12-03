# model
export model=prem_ani_spherical_2D_1s.e
export att_spec=false
# source
export cmt=CMTSOLUTION_MEGA
export station=STATIONS_MEGA
# simulation
export nproc=384
export wtime="3:0:0"
export subdir="ulvz_2D"
export jname=prem_1

# Axisymmetric:
# 1) PREM
# 2) PREM + ULVZ (in-plane)
# 3) s40rts (in-plane)
# 4) s40rts + ULVZ (in-plane)
# 
# 3D:
# 1) PREM + ULVZ
# 2) s40rts
# 3) s40rts + ULVZ


# copy
mkdir ../AxiSEM3D_RUNS/${subdir}
mkdir ../AxiSEM3D_RUNS/${subdir}/${jname}
rsync -r --force --delete template_ulvz/ ../AxiSEM3D_RUNS/${subdir}/${jname}/

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
cp template_ulvz/cmt_sta/${cmt} ../AxiSEM3D_RUNS/${subdir}/${jname}/input/CMTSOLUTION
cp template_ulvz/cmt_sta/${station} ../AxiSEM3D_RUNS/${subdir}/${jname}/input/STATIONS

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
