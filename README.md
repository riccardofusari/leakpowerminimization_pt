# Leakage power minimization Prime Time plug-in

The following script can be used for minimizing the leakage power of a digital circuit in the post synthesis optimization.

The tree of the repository is explained here

### Benchmarck
This directory contains three circuits along with their respective SDC (Synopsys Design Constraints) and Verilog descriptions. These circuits are used for benchmarking the optimization script.
### Saved
This folder is used to store the post-synthesis netlist, SDC, and reports generated during the synthesis and analysis process.
### Sripts
This directory contains all the scripts required for optimizing a digital circuit.
### tech
Here, the technology library used is provided, specifically the STMicroelectronics 65nm library.

### Scripts overview
Let's provide a brief overview of the different scripts in the repository:
##### synthesis.tcl
This script performs the synthesis of a given circuit using the nominal LVT (Low Voltage Threshold) library. The results of the synthesis process are saved in the "saved/" directory.
##### pt_analysis.tcl
This script is responsible for generating reports and performing post-synthesis analysis. It utilizes the synthesized netlist and SDC files saved in the "saved/" directory.
##### pt_contest.tcl
This script serves as the main entry point for the optimization procedure. It calls the "dualVth" procedure, which is responsible for power optimization.
##### dualVth.tcl
This script is the core component of the power optimization process. It takes the slack threshold and maximum fanout endpoint costs as inputs, which define the constraints of the optimization. The script swaps cells from LVT to HVT (High Voltage Threshold) while ensuring that the specified constraints are met.

If you are using a different technology library, you will need to modify the cell swap procedure in this script accordingly, using the correct cell names from your library.

By following this repository structure and utilizing the provided scripts, you can effectively minimize the leakage power of a digital circuit through post-synthesis optimization.

Please note that this script assumes the use of the STMicroelectronics 65nm library. If you are using a different library, you may need to adapt the scripts accordingly.


### Dual VTH algorithm

The Dual VTH algorithm is designed to minimize leakage power in a design by swapping cells between Low-Voltage Threshold (LVT) and High-Voltage Threshold (HVT) libraries while considering slack and max fanout endpoint constraints.

The algorithm of the procedure is the following
- Initialization: Collect all cells in the design and determine the number of cells.
- Calculate Priority: For each cell in the design, a priority value is calculated based on the difference in leakage power and slack between the LVT and HVT configurations. This calculation helps determine which cells are more suitable for swapping to achieve a balance between power reduction and meeting timing constraints. By evaluating both leakage power and slack differences, the algorithm assigns a priority value to each cell. Higher priority indicates that swapping the cell to the HVT library could potentially yield greater power savings while maintaining acceptable timing margins. The number of cells swapped each time in the algorithm depends on the size of the design and the predefined thresholds. The algorithm aims to strike a balance between the amount of optimization performed and the computational complexity.



$priority = \frac{leak_{lvt} − leak_{hvt}}{slack_{lvt} − slack_{hvt}}$

- Small Design: If the design is relatively small (e.g., fewer than 300 cells), the algorithm swaps a larger portion of cells to the HVT library initially. It selects a percentage of cells with the highest priority and swaps them to HVT. 
  Large Design: For larger designs, the algorithm takes a more conservative approach. It swaps a smaller percentage of cells initially to ensure stability and gradual optimization. The number of cells swapped is typically around 1-3% of the total cell count.
- After the initial swapping, the algorithm reevaluates the constraints and iteratively swaps additional cells as long as the constraints are not violated. The exact number of cells swapped in each iteration depends on the design characteristics and the specific implementation of the algorithm. 
- Swap Cells to LVT: Sort the cells based on slack values and iterate through the list. Swap each cell back to the LVT library. Check if the constraints are satisfied.
- Repeat the process: If the constraints are not satisfied, go back to the swapping step and repeat the process until the constraints are met.


### Usage

After you have modified the swap procedures accordingly to your technology library, modify the circuit name into the synthesis script, pt_analysis script, pt_contest script, you can run all the script using Desing Compiler and Prime Time.

```bash
dc_shell -xg -f ./scripts/synthesis.tcl

---

pt_shell -f ./scripts/pt_analysis.tcl

---

pt_shell -f ./scripts/pt_contest.tcl

```