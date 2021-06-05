cd build/
sims -sys=manycore -ariane  -vcs_build -x_tiles=4 -y_tiles=4 -rtl_timeout=10000000000000000  -vcs_build_args="-full64 -debug_pp -kdb -lca -LDFLAGS -rdynamic -P ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a"
sims -sys=manycore -ariane  -vcs_run hello_world_many.c -x_tiles=4 -y_tiles=4 -rtl_timeout=10000000000000000  -vcs_build_args="-full64" -sim_run_args="-gui=verdi"
