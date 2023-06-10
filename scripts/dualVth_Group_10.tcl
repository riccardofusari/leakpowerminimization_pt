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
## Swap cells procedures
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
    # For checking the slack I need the most critical path 
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
            
            if {$cell_fanout_endpoint_cost >= $maxFanoutEndpointCost} {
                # Fanout Constraint violated
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
proc sort_cells_by_priority_dec {hvt_cells} {

    set sorted_cells ""

    foreach_in_collection cell $hvt_cells {
        set cell_path [get_timing_paths -through $cell]
        set cell_slack [get_attribute $cell_path slack] 
        set cell_name [get_attribute $cell full_name]
        set cell_leak [get_attribute $cell leakage_power]
        set cell_priority [expr {$cell_slack * $cell_leak}]
        lappend sorted_cells "$cell_name $cell_priority"
    }
    set sorted_cells [lsort -real -decreasing -index 1 $sorted_cells]

    return $sorted_cells
}

proc sort_cells_by_priority_inc {hvt_cells} {

    set sorted_cells ""

    foreach_in_collection cell $hvt_cells {
        set cell_path [get_timing_paths -through $cell]
        set cell_slack [get_attribute $cell_path slack] 
        set cell_name [get_attribute $cell full_name]
        set cell_leak [get_attribute $cell leakage_power]
        set cell_priority [expr {$cell_slack * $cell_leak}]
        lappend sorted_cells "$cell_name $cell_priority"
    }
    set sorted_cells [lsort -real -increasing -index 1 $sorted_cells]

    return $sorted_cells
}

proc sort_cells_by_slack_inc {hvt_cells} {

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



proc sort_cells_by_slack_dec {hvt_cells} {

    set sorted_cells ""

    foreach_in_collection cell $hvt_cells {
        set cell_path [get_timing_paths -through $cell]
        set cell_slack [get_attribute $cell_path slack] 
        set cell_name [get_attribute $cell full_name]
        lappend sorted_cells "$cell_name $cell_slack"
    }


    

    set sorted_cells [lsort -real -decreasing -index 1 $sorted_cells]

    return $sorted_cells
}



proc cells_swapping {cellName_list Vt_type} {

    foreach cellName $cellName_list {
        set cell [get_cells $cellName]
        set ref_name [get_attribute $cell ref_name]
        set original_vt [get_attribute $cell lib_cell.threshold_voltage_group]

        if {$original_vt != $Vt_type} {
            set library_name "CORE65LP${Vt_type}"
            if {$original_vt == "LVT"} {
                regsub {_LL} $ref_name "_LH" new_ref_name
            } elseif {$original_vt == "HVT"} {
                regsub {_LH} $ref_name "_LL" new_ref_name
            } 
            size_cell $cell "${library_name}/${new_ref_name}"
        }
    }
}

################################################################################################
##
## Main procedure
##
################################################################################################
#
#proc dualVth {slackThreshold maxFanoutEndpointCost} {
#
#    swap_to_hvt 
#
#    set cell_num [sizeof_collection [get_cells]]
#    set cell_group_num [expr {int($cell_num * 0.05)}]
#
#    while {[check_contest_constraints $slackThreshold $maxFanoutEndpointCost] == 0} {
#
#        set hvt_cells [get_cells -filter "lib_cell.threshold_voltage_group == HVT"]
#        set sorted_cells [sort_cells_by_slack_inc $hvt_cells]
#
#        # Extract the first 20% elements from the sorted list
#        set cell_group [lrange $sorted_cells 0 $cell_group_num]
#
#        # Iterate over the extracted elements and perform swaps
#        foreach cells $cell_group {
#            set cell_name [lindex $cells 0]
#            swap_cell_to_lvt [get_cells $cell_name]
#        }
#    }
#
#    return 1
#}
#
proc dualVth {slackThreshold maxFanoutEndpointCost} {
    
    #swap_to_hvt
    #################################################################################
    # Set to HVT
    #################################################################################
    # sort_by_slack decreasing order
    set all_cells [get_cells]
    #set sorted_cells_by_slack_dec [sort_cells_by_slack_dec $all_cells]
    set sorted_cells_by_priority_dec [sort_cells_by_priority_dec $all_cells]

    ## Take the 30%
    set cell_num [sizeof_collection [get_cells]]
    set cell_group_num [expr {int($cell_num * 0.3)}]
    set cell_group [lrange $sorted_cells_by_priority_dec 0 $cell_group_num]

    # Iterate over the extracted elements and perform swaps
    foreach cells $cell_group {
        set cell_name [lindex $cells 0]
        swap_cell_to_hvt [get_cells $cell_name]
    }

    #sort lvt cells by decreasing slack
    #set lvt_cells [get_cells -filter "lib_cell.threshold_voltage_group == LVT"]
    #set sorted_cells_by_slack_dec [sort_cells_by_slack_dec $lvt_cells]
    set list_count  $cell_group_num
    set tmp $cell_group_num
    set tmp [expr {$tmp + $cell_group_num}]

    while {[check_contest_constraints $slackThreshold $maxFanoutEndpointCost] == 1} {   
        #index the group sorted before
        set cell_group [lrange $sorted_cells_by_priority_dec $list_count [expr {$tmp - 1}]]

        #update the indexes
        set list_count [expr {$list_count + $cell_group_num}]
        set tmp [expr {$tmp + $cell_group_num}]

        # Iterate over the extracted elements and perform swaps
        foreach cells $cell_group {
            set cell_name [lindex $cells 0]
            swap_cell_to_hvt [get_cells $cell_name]
        }        
    }

    set cell_num [sizeof_collection [get_cells]]

    #################################################################################
    # Set to LVT
    #################################################################################

    #take the 2% of the HVT cells and sort by increasing slack
    set cell_group_num [expr {int($cell_num * 0.01)}]
    set hvt_cells [get_cells -filter "lib_cell.threshold_voltage_group == HVT"]
    set sorted_cells [sort_cells_by_slack_inc $hvt_cells]

    # Extract the first 2% elements from the sorted list
    set cell_group [lrange $sorted_cells 0 $cell_group_num]

    # Iterate over the extracted elements and perform swaps
    foreach cells $cell_group {
        set cell_name [lindex $cells 0]
        swap_cell_to_lvt [get_cells $cell_name]
    }

    #sort lvt cells by decreasing slack
    set hvt_cells [get_cells -filter "lib_cell.threshold_voltage_group == HVT"]
    set sorted_cells_by_slack_inc [sort_cells_by_slack_inc $hvt_cells]
    set list_count  0
    # 10%
    set tmp $cell_group_num


    #set cell_group_num [expr {int($cell_num * 0.02)}]
    while {[check_contest_constraints $slackThreshold $maxFanoutEndpointCost] == 0} {
        set cell_group [lrange $sorted_cells_by_slack_inc $list_count [expr {$tmp - 1}]]
        
        #update the indexes
        set list_count [expr {$list_count + $cell_group_num}]
        set tmp [expr {$tmp + $cell_group_num}]
        # Extract the first 20% elements from the sorted list
        #set cell_group [lrange $sorted_cells 0 $cell_group_num]
        # Iterate over the extracted elements and perform swaps
        foreach cells $cell_group {
            set cell_name [lindex $cells 0]
            swap_cell_to_lvt [get_cells $cell_name]
        }
    }

    return 1
}
