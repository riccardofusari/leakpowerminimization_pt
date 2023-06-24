##################################################################################################
##
## Title        : Dual VTH Prime Time command
## Project      : Low Power Contest
##
##################################################################################################
## File         : dualVth.tcl
## Authors      : Riccardo Fusari
##
##################################################################################################
## Description  : This script implements a Leakage power minimization procedure in Prime time
##                by swapping LVT cells to HVT cells under slack and max fanout end point 
##                constraints 
##
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

proc swap_to_lvt {} {
    foreach_in_collection cell [get_cells] {
        set ref_name [get_attribute $cell ref_name]
        set library_name "CORE65LPLVT"
        regsub {_LH} $ref_name "_LL" new_ref_name
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
## Sort procedure
## This procedure sort a list by increasing slack
## 
################################################################################################


proc sort_cells_by_slack {hvt_cells} {

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
## List management procedures
## 
################################################################################################
proc leak_slack_list {hvt_cells} {
    set sorted_cells ""
    foreach_in_collection cell $hvt_cells {
        set cell_path [get_timing_paths -through $cell]
        set cell_slack [get_attribute $cell_path slack] 
        set cell_name [get_attribute $cell full_name]
        set cell_leak [get_attribute $cell leakage_power]
        lappend sorted_cells "$cell_name $cell_leak $cell_slack"
    }
    return $sorted_cells
}


proc priority_list {lvt_list hvt_list} {
    set result ""

    foreach element1 $lvt_list element2 $hvt_list {
        set leak_lvt [lindex $element1 1]
        set leak_hvt [lindex $element2 1]
        set slack_lvt [lindex $element1 2]
        set slack_hvt [lindex $element2 2]
        set name [lindex $element1 0]
        set priority [expr {($leak_lvt - $leak_hvt) / ($slack_lvt - $slack_hvt)}]

        lappend result "$name $priority"
    }
    return $result
}


################################################################################################
##
## Main procedure
##
################################################################################################

proc dualVth {slackThreshold maxFanoutEndpointCost} {
    #Take the collection and the number of cells
    set all_cells [get_cells]
    set cell_num [sizeof_collection [get_cells]]

    #Prepare a list containing the priority of each cell in terms of slack and leakage power
    set lvt_list [leak_slack_list $all_cells]
    swap_to_hvt
    set hvt_list [leak_slack_list $all_cells]
    swap_to_lvt 
    set priority [priority_list $lvt_list $hvt_list]
    set priority [lsort -real -decreasing -index 1 $priority]

    ## Take a certain amount of cell depending how big the design is
    if {$cell_num < 300} {
        set cell_group_num [expr {int($cell_num * 0.8)}]
        set cell_group [lrange $priority 0 $cell_group_num]
    } else {
        set cell_group_num [expr {int($cell_num * 0.3)}]
        set cell_group [lrange $priority 0 $cell_group_num]
    }
    #################################################################################
    # Set to HVT
    #################################################################################
    # Iterate over the extracted elements and perform swaps
    foreach cells $cell_group {
        set cell_name [lindex $cells 0]
        swap_cell_to_hvt [get_cells $cell_name]
    }

    # Indexes
    set list_count  $cell_group_num
    set tmp [expr {2 * $cell_group_num}]

    # Check if we can do other swaps
    while {[check_contest_constraints $slackThreshold $maxFanoutEndpointCost]} {   
        #index the group sorted before
        set cell_group [lrange $priority $list_count [expr {$tmp - 1}]]

        #update the indexes
        set list_count [expr {$list_count + $cell_group_num}]
        set tmp [expr {$tmp + $cell_group_num}]

        # Iterate over the extracted elements and perform swaps
        foreach cells $cell_group {
            set cell_name [lindex $cells 0]
            swap_cell_to_hvt [get_cells $cell_name]
        }        
    }

    #################################################################################
    # Set to LVT
    #################################################################################

    #take the 1.5% and sort by increasing slack
    set cell_group_num [expr {int($cell_num * 0.015)}]
    set hvt_cells [get_cells -filter "lib_cell.threshold_voltage_group == HVT"]
    set sorted_cells [sort_cells_by_slack $hvt_cells]

    # Extract the elements from the sorted list
    set cell_group [lrange $sorted_cells 0 [expr {$cell_group_num - 1}]]

    # Iterate over the extracted elements and perform swaps
    foreach cells $cell_group {
        set cell_name [lindex $cells 0]
        swap_cell_to_lvt [get_cells $cell_name]
    }
    
    set list_count  $cell_group_num
    set tmp [expr {2 * $cell_group_num}]

    #Swap to LVT until constraints are met
    while {[check_contest_constraints $slackThreshold $maxFanoutEndpointCost] == 0} {
        set cell_group [lrange $sorted_cells $list_count [expr {$tmp - 1}]]
        
        #update the indexes
        set list_count [expr {$list_count + $cell_group_num}]
        set tmp [expr {$tmp + $cell_group_num}]

        foreach cells $cell_group {
            set cell_name [lindex $cells 0]
            swap_cell_to_lvt [get_cells $cell_name]
        }
    }
    return 1
}