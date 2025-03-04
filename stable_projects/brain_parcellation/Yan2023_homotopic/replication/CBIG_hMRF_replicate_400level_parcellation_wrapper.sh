#!/bin/bash
# Example:
#     sh CBIG_hMRF_replicate_400level_parcellation_wrapper.sh ~/storage/temporary/CBIG_hMRF_replication_output
#
# Written by Xiaoxuan Yan and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

out_dir=`realpath $1` # to be handled in CBIG_hMRF_generate_parcellation.sh
if [ -d $out_dir ]; then
    rm -r $out_dir
fi
mkdir -p $out_dir

rep_code_folder="${CBIG_CODE_DIR}/stable_projects/brain_parcellation/Yan2023_homotopic/replication"

#################################
# Step 1: generate subject path #
#################################
subject_list_path="${rep_code_folder}/input/GSP_subject_list_qc_passed.csv"
lh_out_file="${out_dir}/lh_GSP_subject_fullpath.csv"
rh_out_file="${out_dir}/rh_GSP_subject_fullpath.csv"
sh ${rep_code_folder}/CBIG_hMRF_generate_subject_fullpath_GSP.sh  ${subject_list_path} ${lh_out_file} ${rh_out_file}

################################
# Step 2: replicate PMM matrix #
################################
step1_job_name="pmm_rep"
sh ${rep_code_folder}/CBIG_hMRF_generate_premultiplied_matrix.sh ${out_dir} ${step1_job_name}\
 ${lh_out_file} ${rh_out_file}
sh $CBIG_CODE_DIR/utilities/scripts/CBIG_check_job_status -n "${step1_job_name}"
lhrh_avg_file="${out_dir}/premultiplied_matrix_single.mat"

############################################
# Step 3: replicate level 400 parcellation #
############################################
start_seed=835
num_cluster=400
c=140000
d=50000
w_xyz=150000
decrease_d=true
decrease_c=false
premature_stopping=true

sh ${rep_code_folder}/CBIG_hMRF_generate_parcellation.sh ${out_dir} ${start_seed} ${num_cluster}\
 ${c} ${d} ${w_xyz} ${decrease_d} ${decrease_c} ${premature_stopping} ${lhrh_avg_file}