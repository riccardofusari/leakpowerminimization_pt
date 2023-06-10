##################################################################################################
## Dual VTH Prime Time command
## This script implement a Leakage power minimization procedure in Prime time
##
##################################################################################################


################################################################################################
##
## Swap cells procedures
##
################################################################################################

proc swap_cell_to_lvt {cell} {
    set ref_name [get_attribute $cell ref_name]
    set library_name "CORE65LPLVT"
    regsub {_LH} $ref_name "_LL" new_ref_name
    size_cell $cell "${library_name}/${new_ref_name}"
}

proc swap_cell_to_hvt {cell} {
    set ref_name [get_attribute $cell ref_name]
    set library_name "CORE65LPHVT"
    regsub {_LL} $ref_name "_LH" new_ref_name
    size_cell $cell "${library_name}/${new_ref_name}"
}

################################################################################################
##
## Check constraints
## This procedure check the slack and the fanout
##
################################################################################################
proc check_contest_constraints {slackThreshold maxFanoutEndpointCost} {
    #Essential otherwise the extimation later can be wrong. This is CPU expensive
    update_timing -full

    # Check Slack
    set msc_slack [get_attribute [get_timing_paths] slack]
    
    if {$msc_slack < 0} {
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
            
            # Fanout Constraint violated
            if {$cell_fanout_endpoint_cost >= $maxFanoutEndpointCost} {
                set cell_name [get_attribute $cell full_name]
                set cell_ref_name [get_attribute $cell ref_name]    
                return 0
            }
        }
    }
    return 1
}

################################################################################################
##
## Sort procedures
## 
##
################################################################################################

proc sort_cells_by_priority_dec {all_cells} {

    set sorted_cells ""

    foreach_in_collection cell $all_cells {

        swap_cell_to_hvt $cell

        set cell_name [get_attribute $cell full_name]
  
        set cell_path [get_timing_paths -through $cell]
        set cell_slack_hvt [get_attribute $cell_path slack] 
        set cell_leak_hvt [get_attribute $cell leakage_power]

        swap_cell_to_lvt $cell

        set cell_path [get_timing_paths -through $cell]
        set cell_slack_lvt [get_attribute $cell_path slack] 
        set cell_leak_lvt [get_attribute $cell leakage_power]

        set cell_priority [expr {($cell_leak_lvt - $cell_leak_hvt) / ($cell_slack_lvt - $cell_slack_hvt)}]

        lappend sorted_cells "$cell_name $cell_priority"
    }

    set sorted_cells [lsort -real -decreasing -index 1 $sorted_cells]
    return $sorted_cells
}

proc sort_cells_by_priority_inc {all_cells} {

    set sorted_cells ""

    foreach_in_collection cell $all_cells {

        set cell_name [get_attribute $cell full_name]
  
        set cell_path [get_timing_paths -through $cell]
        set cell_slack_hvt [get_attribute $cell_path slack] 
        set cell_leak_hvt [get_attribute $cell leakage_power]

        swap_cell_to_lvt $cell

        set cell_path [get_timing_paths -through $cell]
        set cell_slack_lvt [get_attribute $cell_path slack] 
        set cell_leak_lvt [get_attribute $cell leakage_power]

        set cell_priority [expr {($cell_leak_lvt - $cell_leak_hvt) / ($cell_slack_lvt - $cell_slack_hvt)}]

        lappend sorted_cells "$cell_name $cell_priority"
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
    #################################################################################
    # Priority computing
    #################################################################################
    set all_cells [get_cells]
    set sorted_cells ""
    set sorted_cells [sort_cells_by_priority_dec $all_cells]
    #################################################################################
    # Swap to HVT
    #################################################################################
    ## Start taking the 30%
    set cell_num [sizeof_collection [get_cells]]
    set cell_group_num [expr {int($cell_num * 0.3)}]
    set cell_group [lrange $sorted_cells_by_priority_dec 0 [expr {$cell_group_num - 1}]]

    # Iterate over the extracted elements and perform swaps
    foreach cell $cell_group {
        set cell_name [lindex $cell 0]
        swap_cell_to_hvt [get_cells $cell_name]
    }

    set list_count  $cell_group_num
    set tmp [expr {2 * $cell_group_num}]

    # Check if we can do other swaps (expensive)
    while {[check_contest_constraints $slackThreshold $maxFanoutEndpointCost]} {
        #index the group sorted before
        set cell_group [lrange $sorted_cells_by_priority_dec $list_count [expr {$tmp - 1}]]

        #update the indexes
        set list_count [expr {$list_count + $cell_group_num}]
        set tmp [expr {$tmp + $cell_group_num}]

        # Iterate over the extracted elements and perform swaps
        foreach cell $cell_group {
            set cell_name [lindex $cell 0]
            swap_cell_to_hvt [get_cells $cell_name]
        }
    }
    #################################################################################
    # Swap to LVT
    #################################################################################
    #take the 1.5% of the cells 
    set cell_group_num [expr {int($cell_num * 0.015)}]
    set hvt_cells [get_cells -filter "lib_cell.threshold_voltage_group == HVT"]
    #Start with the cells with less impact on power opt
    set sorted_cells [sort_cells_by_priority_inc $hvt_cells]
    # Extract the first 2% elements from the sorted list
    set cell_group [lrange $sorted_cells 0 [expr {$cell_group_num - 1}]]
    # Iterate over the extracted elements and perform swaps
    foreach cell $cell_group {
        set cell_name [lindex $cell 0]
        swap_cell_to_lvt [get_cells $cell_name]
    }
    #Setup indexes for further sizing
    set list_count  $cell_group_num
    set tmp [expr {2 * $cell_group_num}]

    while {[check_contest_constraints $slackThreshold $maxFanoutEndpointCost] == 0} {
        set cell_group [lrange $sorted_cells $list_count [expr {$tmp - 1}]]
        #update the indexes
        set list_count [expr {$list_count + $cell_group_num}]
        set tmp [expr {$tmp + $cell_group_num}]
        # Iterate over the extracted elements and perform swaps
        foreach cell $cell_group {
            set cell_name [lindex $cell 0]
            swap_cell_to_lvt [get_cells $cell_name]
        }
    }
    return 1
}
