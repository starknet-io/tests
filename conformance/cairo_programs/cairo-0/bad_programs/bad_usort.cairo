%builtins range_check
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_lt, assert_nn

func usort{range_check_ptr}(input_len: felt, input: felt*) -> (
    output_len: felt, output: felt*, multiplicities: felt*
) {
    alloc_locals;
    local output_len;
    local output: felt*;
    local multiplicities: felt*;
    %{ vm_enter_scope(dict(__usort_max_size = globals().get('__usort_max_size'))) %}
    %{
        from collections import defaultdict

        input_ptr = ids.input
        input_len = int(ids.input_len)
        if __usort_max_size is not None:
            assert input_len <= __usort_max_size, (
                f"usort() can only be used with input_len<={__usort_max_size}. "
                f"Got: input_len={input_len}."
            )

        positions_dict = defaultdict(list)
        for i in range(input_len):
            val = memory[input_ptr + i]
            positions_dict[val].append(i)

        output = sorted(positions_dict.keys())
        ids.output_len = len(output)
        ids.output = segments.gen_arg(output)
        ids.multiplicities = segments.gen_arg([len(positions_dict[k]) for k in output])
    %}

    let output_start = output;
    verify_usort{output=output}(
        input_len=input_len, input=input, total_visited=0, multiplicities=multiplicities, prev=-1
    );

    %{ vm_exit_scope() %}
    return (output_len=output - output_start, output=output_start, multiplicities=multiplicities);
}

func verify_usort{range_check_ptr, output: felt*}(
    input_len: felt, input: felt*, total_visited: felt, multiplicities: felt*, prev: felt
) {
    alloc_locals;

    if (total_visited == input_len) {
        return ();
    }

    local value = [output];
    let output = &output[1];
    assert_lt(prev, value);

    local multiplicity = [multiplicities];
    assert_nn(multiplicity - 1);

    %{
        last_pos = 0
        positions = positions_dict[ids.value][::-1]
    %}
    verify_multiplicity(multiplicity=multiplicity, input_len=input_len, input=input, value=value);

    return verify_usort(
        input_len=input_len,
        input=input,
        total_visited=total_visited + multiplicity,
        multiplicities=&multiplicities[1],
        prev=value,
    );
}

func verify_multiplicity{range_check_ptr}(
    multiplicity: felt, input_len: felt, input: felt*, value: felt
) {
    alloc_locals;
    %{ assert len(positions) == 0 %}
    assert_nn(input_len);
    return ();
}

func main{range_check_ptr}() -> () {
    alloc_locals;
    let (input_array: felt*) = alloc();
    assert input_array[0] = 2;
    assert input_array[1] = 1;
    assert input_array[2] = 0;

    let (output_len, output, multiplicities) = usort(input_len=3, input=input_array);

    return ();
}
