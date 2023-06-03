##################################################################################################
## Dual VTH Prime Time command
## This script implement a Leakage power minimization procedure in Prime time
##
## 1. Start with changing all the cells to HVT 
## 2. While the timing and fanout constraints are not met
##    a. sort cells
##    b. size first cells from previous list to LVT
##################################################################################################


################################################################################################
##
## Swap cells procedure
## This procedure swap all the cells into HVT
##
################################################################################################
proc swap_to_hvt {} {
    foreach_in_collection cell [get_cells] {
        set ref_name [get_attribute $cell ref_name]
        set library_name "CORE65LPHVT"
        regsub {_LL} $ref_name "_LH" new_ref_name
        size_cell $cell "${library_name}/${new_ref_name}"
    }
}

################################################################################################
##
## Swap cell procedure
## This procedure swap one cell into LVT
##
################################################################################################
proc swap_cell_to_lvt {cell} {
    set ref_name [get_attribute $cell ref_name]

    set library_name "CORE65LPLVT"

    regsub {_LH} $ref_name "_LL" new_ref_name
    size_cell $cell "${library_name}/${new_ref_name}"

}

################################################################################################
##
## Check constraints
## This procedure check the slack and the fanout
##
################################################################################################
proc check_contest_constraints {Threshold maxFanoutEndpointCost} {
    #Essential otherwise the extimation later can be wrong. This is CPU expensive
    update_timing -full 
    
    # Check Slack
    # For checking the slack I need the most critical path 
    set msc_slack [get_attribute [get_timing_paths] slack]

    if ($msc_slack < 0) {
        # Threshold Constraint violated
        return 0
    }

    # Check Fanout endpoint cost
    foreach_in_collection cell [get_cells] {

        set paths [get_timing_paths -through $cell -nworst 1 -max_paths 10000 -slack_lesser_than $slackThreshold]
        set cell_fanout_endpoint_cost 0.0
        
        foreach_in_collection path $paths {
            set this_cost [expr $slackThreshold - [get_attribute $path slack]]
            set cell_fanout_endpoint_cost [expr $cell_fanout_endpoint_cost + $this_cost]
        }

        if {$cell_fanout_endpoint_cost >= $maxFanoutEndpointCost} {
            # Fanout Constraint violated
            set cell_name [get_attribute $cell full_name]
            set cell_ref_name [get_attribute $cell ref_name]    
            return 0
        }
    }

    return 1
}


################################################################################################
##
## Sort procedure
## Create a list of cells sorted by increasing slack
##
################################################################################################

proc sort_cell_by_slack {hvt_cells} {

    set sorted_cells ""

    foreach_in_collection cell $hvt_cells {
        set cell_path [get_timing_paths -through $cell]
        set cell_slack [get_attribute $cell_path slack] 
        set cell_name [get_attribute $cell full_name]
        lappend sorted_cells "$cell_name $cell_slack"

    }

    set sorted_cells [lsort -real -increasing -index 1 $sorted_cells]

    return $sorted_cells
}


################################################################################################
##
## Main procedure
##
################################################################################################

proc dualVth {slackThreshold maxFanoutEndpointCost} {

    swap_to_hvt 

    while {check_contest_constraints $slackThreshold $maxFanoutEndpointCost} {

        set hvt_cells [get_cells -filter "lib_cell.threshold_voltage_group == HVT"]

        set sorted_cells [sort_cells_by_slack $hvt_cells]

        set cell_name [lindex $sorted_cells 0 0]

        # Here we are swapping one cell at the time.. suggestion is to change multiple cells and then check constraints
        swap_cell_to_lvt [get_cells $cells_name ]
        
    }

    return 1
}
 

