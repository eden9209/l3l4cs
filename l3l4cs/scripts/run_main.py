#!/usr/bin/python3.6

import click
import subprocess
import random
import sys
import os
#cwd = os.getcwd()
#print("cwd (current working directory):", cwd)
#exit(0)

###########################
### Configured by user: ###
###########################

#timeout = "5000000ns"
timeout = "5000000000000ns"
timeout = "8000000000ns"
timeout = "78000000ns"

#WS="/mnt/apps/myshare/edens/L3L4CS_0/"
#project="CE_proj/"
env="l3l4cs"

env_compile_list="$WS/"+env+"/dv/dfile/dfile_tb"

#env_compile_list=$WS+project+env+"/dv/dfile/dfile_tb"
compile_list=" -f "+env_compile_list+" "

testbench_top="$WS/"+env+"/dv/tb/"+env+"_tb.sv"
tcl_file= "$WS/"+env+"/dv/tb/"+env+"_tb.tcl"
simulate_do="$WS/"+env+"/dv/tb/simulate.do"
top= env+"_tb"


# vcs dump file (recorded waves + collected coverage (functional+code)): prefix 'fsdb' will be added later in the code:
vcs_dump_name = "dump"

# vcs directory for simulation outputs:
vcs_simv_dir_name = "simv" ; # note: 'simv' is also the default name in vcs

# Xilinx Compiled Libreries:
xilinx_compiled_libs = "/mnt/apps/srm/Xilinx_how_to/Xilinx_compiled_vcs/"
xilinx_compiled_libs = "/mnt/apps/srm/vcs_envs/commE__comm_engine_full/commE__comm_engine_full__02/dut/commengine_a_sample/sim/outputs/Xilinx_compiled_vcs/"
xilinx_compiled_libs = "" ; # for environments that compiled libs are not needed

def list_of_tests () -> list:
    global tests
    global tests_xrun
    global tests_vcs
    tests = [
    #env+_test"
    env+"_direct_testing"
            ]
    tests_xrun = tests
    tests_vcs = tests
    print_list_of_tests()
    print("---")


###########################
###   check and remove the previous compilation   ###############
###########################

def check_and_remove_previous_compilation():
    # Get the current directory
    current_directory = os.getcwd()

    # Specify the filename of the script
    script_filename = os.path.basename(__file__)

    # Check if the script is being executed under 'sim/run_*' directory
    if "sim/run_" not in current_directory:
        print("This script should be executed under 'sim/run_*' directory.")
        return

    # Confirm with the user before proceeding
  ##response = input("This will remove all files and directories in the current directory. Are you sure you want to proceed? (y/n): ")
  ##if response.lower() != "y":
  ##    print("Aborted.")
  ##    return

    # Remove all files and directories (except the script itself) in the current directory
    for root, dirs, files in os.walk(current_directory, topdown=False):
        for name in files:
            file_path = os.path.join(root, name)
            if file_path != os.path.abspath(__file__):
                try:
                    os.remove(file_path)
                except OSError as e:
                    print(f"Error occurred while removing file '{file_path}': {str(e)}")

        for name in dirs:
            dir_path = os.path.join(root, name)
            if dir_path != os.path.abspath(current_directory):
                try:
                    os.rmdir(dir_path)
                except OSError as e:
                    print(f"Error occurred while removing directory '{dir_path}': {str(e)}")

    print("All files and directories (except the script itself) have been removed.")


###########################
###   imc   ###############
###########################

def run_imc() -> None:
    #cmd = "imc -gui &"
    #process = subprocess.call(cmd, shell=True)
    print("\n*** -I- '-imc' : Currently no command is executed. Please view the code. ***\n")
    pass

###########################
###  Tests  ###############
###########################

def print_list_of_tests() -> None:
    global tests
    i=0
    for test_name in tests:
        i += 1
        print("{:<3} : {}".format(i, test_name))


#def run_test (test_num: str, coverage: bool, nof_tests: int, dump: str) -> None:
def run_test_xrun (test_num: str, coverage: str, nof_tests: int, dump: str, gui, execute) -> None:
    global tests
    # run all tests:
  ##if test_num == 1:
  ##    print("\n###############")
  ##    print("Running all tests")
  ##    print("###############\n")
  ##    for i in range(2, len(tests)+1):
  ##        test_name = tests[i-1]
  ##        print("\n###############")
  ##        print("{:<3} : {}".format(i, test_name))
  ##        print("###############\n")
  ##        run_test_xrun_nof_tests(coverage=coverage, nof_tests=nof_tests, test_name=test_name, dump=dump, gui=gui, execute=execute)
  ##else:
    if 1:
        test_name = tests[test_num-1]
        #print("\n###############")
        #print("{:<3} : {}".format(test_num, test_name))
        #print("###############\n")
        run_test_xrun_nof_tests(coverage=coverage, nof_tests=nof_tests, test_name=test_name, dump=dump, gui=gui, execute=execute)


def run_test_xrun_nof_tests(coverage: str, nof_tests: int, test_name: str, dump: str, gui, execute) -> None:
    global seed
    print("run_test_nof_tests")
    list_of_seeds = list()
    for i in range (1, nof_tests+1):  # random number between 1 (included) to nof_tests+1 (not included)
        current_seed = 0
        # is random seed?
        if seed == -1:
            current_seed = run_test_get_random_seed(list_of_seeds)
            list_of_seeds.append(current_seed)
        else:
            current_seed = seed
            seed+=1
        print("\n---------------\n")
        print("current_seed =", current_seed)
        # execute test:
        exec_test_xrun(seed=current_seed, test_name=test_name, dump=dump, coverage=coverage, gui=gui, execute=execute)


def run_test_get_random_seed(list_of_seeds: list) -> None:
    current_seed = random.randrange(1, 2147483647)  ; # randrange between seed=1 to seed=2^31-1
    while current_seed in list_of_seeds:
        current_seed = random.randrange(1, 2147483647)  ; # randrange between seed=1 to seed=2^31-1
    return current_seed


def exec_test_xrun(seed: int, test_name: str, dump: str, coverage: str, gui, execute) -> None:
    logfile = "my_log__seed" + str(seed)
    if gui == False:
        uvmnocdnsextra = "-uvmnocdnsextra"
        gui_ = ""
        #input_ = "../run_w_sim_wo_gui.tcl"
        linedebug = ""
    else:
        uvmnocdnsextra = ""
        gui_ = "-gui"
        #input_ = "../run_wo_sim_w_gui.tcl"
        # -I- if gui, there is no coverage:
        coverage = ""
        linedebug = "-linedebug"
    cmd = "xrun -clean -uvm -64bit -unbuffered -timescale 1ns/1ps -sysv -access +rw " + uvmnocdnsextra + " -uvmhome CDNS-1.2 "+compile_list+" -logfile " + logfile + ".log +UVM_TESTNAME=" + test_name +" "+ testbench_top + " " + gui_ + " -seed " + str(seed) + " -messages " + linedebug + " -define SYNCHRONOUS_RESET +UVM_NO_SUMMARY +UVM_VERBOSITY=UVM_HIGH +UVM_TIMEOUT=" + timeout + " -warn_multiple_driver " + dump + " -status " + coverage + "-define  UVM_REPORT_DISABLE_FILE_LINE" + " -coverage A"   # + " -input " + tcl_file
    print("Xcelium executed command:\n    ", cmd)

    # Coverage:
    # ---------
    print("Merge tests:\n     imc -batch")
    print("     imc> merge test1 test2 test3 -out all")
    print("     imc> merge * -out all")
    print("     imc> merge * -out all -override")
    
    # Waves:
    # ------
    # 1. watch waves in interactive mode: waves are open after 'cmd' is executed. (requires simulator simulation (xrun)).
    # 2. watch waves in post simulation mode: (requires 'simvision' license):
    cmd_waves = "simvision waves.shm/ &"
    print("Watch waves - post simulation (with simvision):\n    ", cmd_waves)

    # Coverage - GUI:
    # ---------------
    xrun_cov_work_dir = "cov_work/scope/test_sv" + str(seed) + "/"
    cmd_coverage_gui = "imc -load " + xrun_cov_work_dir + " &"
    print("Coverage - open GUI:\n    ", cmd_coverage_gui)
    print("Coverage - Note:")
    print("     If does not work, it because of imc version (imc -version).")
    print("     Version 15.20 does not know how to load coverage files, version 20.09 and later is able to do that.")
    print("     (Source: https://community.cadence.com/cadence_technology_forums/f/functional-verification/49374/imc-exception-on-opening-ucm-from-xrun-coverage-generation).")
    print("     -->")
    print("     In this case: imc & --> File --> Load... --> " + xrun_cov_work_dir)

    if execute == True :
        exec_cmd_in_shell(cmd)
    #print("-------------------")
    #print("Command to be executed:", cmd)
    #print("-------------------")
    #process = subprocess.call(cmd, shell=True)
    #print("-------------------")
    #print("Command executed (finished):", cmd)
    #print("-------------------")


#def exec_test_with_coverage(seed: int, test_name: str, dump: str) -> None:
#    cmd = "xrun -clean -uvm -64bit -unbuffered -timescale 1ns/1ps -sysv -access +rw -uvmnocdnsextra -uvmhome CDNS-1.2 -f ../compile_list.txt -logfile my_log__seed" + str(seed) + ".log +UVM_TESTNAME=" + test_name + testbench_top + " -input ../run_w_sim_wo_gui.tcl -seed " + str(seed) + " -messages -define SYNCHRONOUS_RESET +UVM_TIMEOUT=" + timeout + " -warn_multiple_driver " + dump + " -status"
#    process = subprocess.call(cmd, shell=True)



##########################
###  Tests - vcs  ########
##########################

def run_test_vcs (test_num: str, coverage: str, nof_tests: int, faster: str, gui, xilinx_compiled_libs: str, execute, codecoverage: str, profiling, solver, synopsys_workaround) -> None:
    global tests_vcs
    
    # create synopsys_sim.setup
    create_synopsys_sim_setup(xilinx_compiled_libs=xilinx_compiled_libs)
    
    tests = tests_vcs
    # run all tests:
  ##if test_num == 1:
  ##    print("\n###############")
  ##    print("Running all tests")
  ##    print("###############\n")
  ##    for i in range(2, len(tests)+1):
  ##        test_name = tests[i-1]
  ##        print("\n###############")
  ##        print("{:<3} : {}".format(i, test_name))
  ##        print("###############\n")
  ##        run_test_vcs_nof_tests(coverage=coverage, nof_tests=nof_tests, test_name=test_name, faster=faster, gui=gui, execute=execute, codecoverage=codecoverage, profiling=profiling, solver=solver, synopsys_workaround=synopsys_workaround)
  ##else:
    if 1:
        test_name = tests[test_num-1]
       #print("\n###############")
       #print("{:<3} : {}".format(test_num, test_name))
       #print("###############\n")
        run_test_vcs_nof_tests(coverage=coverage, nof_tests=nof_tests, test_name=test_name, faster=faster, gui=gui, execute=execute, codecoverage=codecoverage, profiling=profiling, solver=solver, synopsys_workaround=synopsys_workaround)

def create_synopsys_sim_setup(xilinx_compiled_libs: str) -> None:
    with open("synopsys_sim.setup", "w") as file_open:
        file_open.write("work > default\n")
        file_open.write("default:vcs_lib/work\n")
        file_open.write("uvm:vcs_lib/uvm\n")
        if xilinx_compiled_libs != "":
            file_open.write("OTHERS=" + xilinx_compiled_libs + "synopsys_sim.setup")

def run_test_vcs_nof_tests(coverage: str, nof_tests: int, test_name: str, faster: str, gui, execute, codecoverage: str, profiling, solver, synopsys_workaround) -> None:
    global seed
    print("run_test_vcs_nof_tests")
    list_of_seeds = list()
    for i in range (1, nof_tests+1):  # random number between 1 (included) to nof_tests+1 (not included)
        current_seed = 0
        # is random seed?
        if seed == -1:
            current_seed = run_test_get_random_seed(list_of_seeds)
            list_of_seeds.append(current_seed)
        else:
            current_seed = seed
            seed+=1
        print("\n---------------\n")
        print("current_seed =", current_seed)
        # execute test:
        exec_test_vcs(seed=current_seed, test_name=test_name, faster=faster, coverage=coverage, gui=gui, execute=execute, codecoverage=codecoverage, profiling=profiling, solver=solver, synopsys_workaround=synopsys_workaround)

def exec_test_vcs(seed: int, test_name: str, faster: str, coverage: str, gui, execute, codecoverage: str, profiling, solver, synopsys_workaround) -> None:
    global vcs_dump_name
    global vcs_simv_dir_name
    comp_logfile = "compile__seed" + str(seed) + ".log"
    elab_logfile = "elaborate__seed" + str(seed) + ".log"
    sim_logfile = "simulate__seed" + str(seed) + ".log"
    vcs_dump_name_local = vcs_dump_name + "__seed" + str(seed) + ".fsdb"

    # Pre-command for UVM:
    # --------------------
    cmd_for_uvm = "vlogan -sverilog -ntb_opts uvm -work uvm -timescale=1ns/1ps"
    print("Pre compilation for UVM:\n    ", cmd_for_uvm)
    
    # COMPILATION:
    # ------------
    #
    snps_wa = ""
    if synopsys_workaround == True:
        snps_wa = "+define+SNPS_WA"
    #
    #cmd_vlogan = "vlogan -work xil_defaultlib +v2k -full64 -timescale=1ns/1ps +define+SYNCHRONOUS_RESET -sv_net_ports -sverilog"
    cmd_comp_vlogan = "vlogan -kdb -full64 -timescale=1ns/1ps +define+SYNCHRONOUS_RESET -sverilog -f "+compile_list +" -l " + comp_logfile + " -ntb_opts uvm -search_incl_file_path " + snps_wa
    # -search_incl_file_path - if using a file-name (like in file_open): without this flag, it searches in the run-directory; with this flag, it searches in the source directory (from the directory the file called 'file_open').
    # +v2k - no need
    # -sv_net_ports - no need
    # -work work - not necessary, since in 'synopsys_sim.setup' its default is 'work'
    print("Compilation command line:\n    ", cmd_comp_vlogan)
    
    # ELABORATION:
    # ------------
    cmd_elab_vcs__mid = ""
    codecoverage_ = ""
    if gui == False:
        cmd_elab_vcs__mid = "-debug_access+pp+dmptf"
    else:
        # gui == True: 
        cmd_elab_vcs__mid = "-debug_access+all+reverse -debug_region=cell+lib"
        # -debug_region=cell+lib : when using -y (-y <directory> - in the directory there are a lot of modules, but we want to use only a module with a specific instance) or -v (-v <file> - in the file there are a lot of modules, but we want to use only a module with a specific instance)
    codecoverage_ = ""
    if codecoverage != "":
        codecoverage_ = "-cm $codecoverage"
    #
    profiler = ""
    if profiling == True:
        profiler = "-simprofile"
    #
    cmd_elab_vcs__full = "vcs "+ top +" -kdb -full64 " + cmd_elab_vcs__mid + " -licqueue -xlrm -o " + vcs_simv_dir_name + " " + faster + " -l " + elab_logfile + " -ntb_opts uvm -timescale=1ns/1ps " + codecoverage_ + " " + profiler
    # Notes:
    #        1. basic 2-step flow for v files only:             vcs file.v
    #        2. basic 2-step flow for sv files only:            vcs -sverilog file.sv
    #        3. adding -kdb and -full64 for all runnings:       vcs -sverilog file.sv -kdb -full64
    #        4. for list of files:                              vcs -sverilog -f list.txt -kdb -full64
    #        5. for uvm files + who is the top*:                vcs -sverilog -f list.txt -kdb -full64 -ntb_opts uvm name_top
    #        6. and then come the other flags as necessary.
    # *Note for #5 from above:
    #        1. If top is in -f list.txt - run as #6 from above:
    #              vcs -sverilog -f list.txt -kdb -full64 -ntb_opts uvm name_top
    #           for example:
    #              vcs -sverilog -f compile_list.txt -kdb -full64 -ntb_opts uvm pde_top
    #        1. If top is in -f list.txt - run the following command line:
    #              vcs -sverilog -f list.txt -kdb -full64 -ntb_opts uvm relative_path/file_top.sv
    #           for example:
    #              vcs -sverilog -f compile_list.txt -kdb -full64 -ntb_opts uvm ../testbench_top/pde_testbench_top.sv
    print("Elaboration command line:\n    ", cmd_elab_vcs__full)

    # SIMULATION:
    # -----------
    do_ = ""
    gui_ = ""
    if gui == False:
        do_ = simulate_do
    else:
        # gui == True: 
        do_ = "../simulate_interactive.do"
        gui_ = "-gui"
    codecoverage_ = ""
    if codecoverage != "":
        codecoverage_ = "-cm $codecoverage"
    #
    profiler = ""
    if profiling == True:
        profiler = "-simprofile time"
        #profiler = "-simprofile mem"
        #profiler = "-simprofile time+mem"
    #
    cmd_sim__full = "./" + vcs_simv_dir_name + " -ucli -licqueue -l " + sim_logfile + " +UVM_TESTNAME=" + test_name + " -do " + do_ + " " + gui_ + " +ntb_random_seed=" + str(seed) + " " + codecoverage_ + " +UVM_TIMEOUT=" + timeout + " " + " +ntb_solver_mode=" + solver + " " + profiler
    # 'ntb_random_seed' --> 'ntb_random_seed_automatic' for random seed automatically
    print("Simulation command line:\n    ", cmd_sim__full)

    # Coverage:
    # ---------
    # in VCS:
    #   1. functional coverage is collected automatically.
    #   2. code coverage should be by switches, as elaborated and fully detailed above.
    #   3. Merge is as following:
    print("Merge tests:\n     urg -dir simv1.vdb simv2.vdb -dbname merged.vdb -show tests")
    print("             and then open GUI (explenation bellow) with merged.vdb")
    
    # Waves:
    # ------
    # 1. watch waves in interactive mode: waves are open after 'cmd_sim__full' is executed. (requires simulator (vcs) license).
    # 2. watch waves in post simulation mode: (requires Verdi license):
    cmd_waves = "verdi -ssf " + vcs_dump_name_local + " &" + "  -or- verdi -ssf dump.fsdb &"
    print("Watch waves - post simulation (with Verdi, not DVE):\n    ", cmd_waves)

    # Coverage - GUI:
    # ---------------
    cmd_coverage_gui = "verdi -cov -covdir " + vcs_simv_dir_name + ".vdb &"
    print("Coverage - open GUI:\n    ", cmd_coverage_gui)

    # Profiling:
    # ----------
    if profiling == True:
        cmd_profiling = "profrpt -view time_all simprofile_dir"
        #cmd_profiling = "profrpt -view mem_all simprofile_dir"
        print("Profiling:\n    ", cmd_profiling)
        print("     firefox profileReport.html &  ( --> Note: if 'warning' pops-up, follow the instructions and refresh the page).")

    # Execute (if -exec):
    # -------------------
    if execute == True:
        exec_cmd_in_shell(cmd_for_uvm)
        exec_cmd_in_shell(cmd_comp_vlogan)
        exec_cmd_in_shell(cmd_elab_vcs__full)
        exec_cmd_in_shell(cmd_sim__full)


def exec_cmd_in_shell (cmd: str) -> None:
    print("-------------------")
    print("Command to be executed:\n    ", cmd)
    print("-------------------")
    process = subprocess.call(cmd, shell=True)
    print("-------------------")
    print("Command executed (finished):\n    ", cmd)
    print("-------------------")



# Questions for Eugene:
# 1. Are these command lines correct?
# 2. how do I select a specific testname?
# 3. how do I add coverage?
# 


def exec_test_vcs__prev(seed: int, test_name: str) -> None:
    # _v2k is to verilog2001
    cmd = "vcs +vcs+lic+wait -sverilog +cli+4 -M -f "+compile_list+" -full64 -ntb_opts uvm -debug_access -kdb -lca +warn=noLCA_FEATURES_ENABLED -l my_log_vcs__seed" + str(seed) + ".log -timescale=1ns/1ps ../testbench_top/pde_testbench_top.sv"
    exec_cmd_in_shell(cmd)
    #print("-------------------")
    #print("Command to be executed:", cmd)
    #print("-------------------")
    #process = subprocess.call(cmd, shell=True)
    #print("-------------------")
    #print("Command executed (finished):", cmd)
    #print("-------------------")



#############################
###   MAIN                ###
#############################



@click.command()
#@click.option('-seed', '--seed', 'seed_start', prompt="seed to start (other seeds will be sequentials)", help="seed to start (other seeds will be sequentials), default is 1", default=1, show_default=True)
@click.option('-seed', '-s', '--seed', 'seed_start', help="seed to start.\nif entered- other seeds (if more than one test) will be sequentials,\nif not- default is -1, which means random seed", default=-1, show_default=True)
@click.option('-test', '-t', '--test', 'test', help="Choose one of the tests from the list prompted (choose '1' for all tests)", prompt="Choose one of the tests above", default=1, show_default=True)
@click.option('-num', '-n', '--nof_tests', 'nof_tests', help="Number of tests to run. If 'all tests' is chosen, nof_tests is the number of times each test will run.", default=1, show_default=True)
@click.option('-cov', '--cov', 'coverage', help="Needed only if the user would like to run with coverage.", default=False, show_default=True, is_flag=True)
@click.option('-codecoverage', '--codecoverage', 'codecoverage', help="For code coverage. Should be 'line', 'tgl' (for toggle), 'fsm', 'cond' (for condition), 'branch', 'assert' (for assertion), or any other combination with '+' (for example: 'line+tgl').", show_default=True, default="")
@click.option('-profiling', '--profiling', '-profiler', '--profiler', 'profiling', help="In VCS only: When you want to analyze how much time took each type of steps (constraint, verilog, ucli, kernel, etc).", show_default=True, default=False, is_flag=True)
@click.option('-solver', '--solver', 'solver', help="In VCS only: the solver is used when the running is slow. The solver allows you to choose between one of two constraint solver modes: when set to 1, the solver spends more processing time in analyzing the constratints during the first call to 'randomize()' on each class. Therefore, subsequence calls to 'randomize()' on that class are very fast. When set to 2, the solver does minimal processing, and analyzes the constraint in each call to 'randomize()'. When set to 3, the tool chooses which is better according to inner analysis. Default tool is 3. For PDE Extractor (PDE) - recommended is 2.", show_default=True, default="2")
@click.option('-faster', '-dump', '--faster', '--dump', 'mcdump', help="Adds a '-mcdump' flag, in order to split the simulation into 2 cores/threads. This makes the simulation run faster only in case we dump all signals to waves.", default=True, show_default=True, is_flag=True)
@click.option('-imc', '--imc', 'imc', help="'imc' is the GUI of cadence for coverage results. If the switch is on, all other flags are ignored and 'imc' command is executed (please enter 'python3 run_main.py -imc -t 1').", default=False, show_default=True, is_flag=True)
@click.option('-cdns', '-cadence', '-xrun', '--cdns', '--cadence', '--xrun', 'cadence', help="'cadence' switch means - run with 'xrun'. (if both 'xrun' and 'vcs are on/off - 'xrun' is the default).", default=False,  show_default=True, is_flag=True)
@click.option('-vcs', '-synopsys', '--vcs', '--synopsys', 'vcs', help="'vcs' switch means - run with 'vcs' by Synopsys. (if both 'xrun' and 'vcs are on/off - 'xrun' is the default).", default=False, show_default=True, is_flag=True)
@click.option('-gui', '--gui', '-active', '-active_mode', '-interactive', '-interactive_mode', 'gui', help="'gui' switch means 'interactive mode' - run with 'xrun' by Cadence, compilation and elaboration, without simulation. Open Xcelium GUI for the simulation. (1. cannot have 'gui' and 'vcs' together - vcs is taken. 2. If GUI, then coverage is off).", default=False, show_default=True, is_flag=True)
@click.option('-exec', '--exec', 'execute', help="execute - if switch is on, the script execute all command lines; if switch is off (if not added), the command lines are only printed to the screen.", default=False, show_default=True, is_flag=True)
@click.option('-snps_wa', '--snps_wa', '-synopsys_workaround', '--synopsys_workaround', 'synopsys_workaround', help="randomization is TOO slow, so this is workaround to solve this issue, until synopsys will make a permanent and stable solution in their simulation tool.", default=True, show_default=True, is_flag=True)
def start(seed_start, coverage, test, nof_tests, mcdump, imc, cadence, vcs, gui, execute, codecoverage, profiling, solver, synopsys_workaround) -> None:
    global seed
    global xilinx_compiled_libs
    seed = seed_start
    test_num = test
    #
    simulator = ""
    if cadence:
        simulator = "xrun"
    elif vcs:
        simulator = "vcs"
    else:
        simulator = "xrun"
    #
    dump = "-mcdump" if (mcdump == True and simulator == "xrun") else ""  ; # dump = (mcdump == True) ? "-mcdump" : ""
    dump = "-j4 -partcomp -fastpartcomp=j2" if (mcdump == True and simulator == "vcs") else ""  ; # dump = (mcdump == True) ? "-mcdump" : ""
    #
    cov = coverage
    cov = "-covfile ../coverage/covfile.ccf -covoverwrite -coverage U" if (coverage == True and simulator == "xrun") else ""
    #test_name = "c_pde_tst__pdu_length_1B_and_up__pdu_meta_data_ignore_checksum__pdu_only"
    if imc:
        run_imc()
    else:
        if simulator == "xrun":
            run_test_xrun (test_num=test_num, coverage=cov, nof_tests=nof_tests, dump=dump, gui=gui, execute=execute)
        else:
            run_test_vcs (test_num=test_num, coverage=cov, nof_tests=nof_tests, faster=dump, gui=gui, xilinx_compiled_libs=xilinx_compiled_libs, execute=execute, codecoverage=codecoverage, profiling=profiling, solver=solver, synopsys_workaround=synopsys_workaround)


if __name__ == '__main__':
    check_and_remove_previous_compilation()
    list_of_tests()
    start()


##############
##############
### HOW TO ###
##############
##############

# Help:
# ./run_main.py --help

# Run all tests (-test 1) + no coverage (no -cov) + random seed (no -s):
# Note: each test will get a different seed number:
# ./run_main.py -test 1
# ./run_main.py --test 1
# ./run_main.py -t 1

# Run all tests (-test 1) + with coverage (-cov) + random seed (no -s):
# ./run_main.py -test 1 -cov
# ./run_main.py -test 1 -cov
# ./run_main.py -test 1 --cov

# Run all tests (-test 1) + no coverage (no -cov) + specific seed (-s #):
# Note: each test will get a sequential seed number (for example: xrun -seed 4 ..., xrun -seed 5 ..., xrun -seed 6 ..., etc.):
# ./run_main.py -test 1 -s 4
# ./run_main.py -test 1 -seed 4
# ./run_main.py -test 1 --seed 4

# Run test from a list (no -test) + no coverage (no -cov) + random seed (no -s):
# ./run_main.py --> opens a list of tests --> choose a number ('Enter' with no number will choose '1' (all tests)).

# Run a specific test (-test #) + no coverage (no -cov) + random seed (no -s):
# ./run_main.py -test 3
# ./run_main.py -test 3
# ./run_main.py -test 3

# Run a specific test (-test #) + run the test X times + specific seed:
# Note: test3 will run with sequential seeds 50,51,52,...,59 -- since we specified a specific seed
# ./run_main.py -test 3 -num 10       -seed 50
# ./run_main.py -test 3 -n 10         -seed 50
# ./run_main.py -test 3 -nof_tests 10 -seed 50

# Run all tests (-test 1) + run each test X times + specific seed:
# Note: 'each test will run X times' means with sequential seeds (since we specified a specific seed):
#        test2 will run with seeds 50,51,52,...,59
#        test3 will run with seeds 60,61,62,...,69
#        test4 will run with seeds 70,71,72,...,79
#        etc.
# ./run_main.py -test 1 -num 10       -seed 50
# ./run_main.py -test 1 -n 10         -seed 50
# ./run_main.py -test 1 -nof_tests 10 -seed 50


# Run all tests (-test 1) + run each test X times + specific seed + faster(!):
# Note: 'each test will run X times' means with sequential seeds (since we specified a specific seed):
#        test2 will run with seeds 50,51,52,...,59
#        test3 will run with seeds 60,61,62,...,69
#        test4 will run with seeds 70,71,72,...,79
#        etc.
# ./run_main.py -test 1 -num 10 -seed 50 -faster
# ./run_main.py -test 1 -n 10   -seed 50 -faster
# ./run_main.py -test 1 -n 10   -seed 50 -dump

# vcs:
# ./run_main.py -s 1 -n 1 -vcs -t 2
# ./run_main.py -s 1 -n 1 -vcs -t 2 -gui
# ./run_main.py -s 1 -n 1 -vcs -t 2 -exec
# ./run_main.py -s 1 -n 1 -vcs -t 2 -gui -exec

