%builtins range_check

func check_range{range_check_ptr: felt*}(num: felt) {
    with_attr error_message("Failed range-check") {
        [range_check_ptr] = num;
    }
    return();
}

func sub_1_check_range{range_check_ptr: felt*}(num: felt) -> felt {
    check_range(num - 1);
    return num - 1;
}

func sub_by_1_check_range{range_check_ptr: felt*}(num: felt, sub_amount: felt) {
    if (sub_amount == 0) {
        return();
    }
    return sub_by_1_check_range(sub_1_check_range(num), sub_amount -1);
}

func main{range_check_ptr: felt*}() {
    sub_by_1_check_range(6, 7);
    return ();
}
