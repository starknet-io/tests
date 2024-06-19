// This file is a copy of common/modulo.cairo + added structs from common/cairo_builtins.cairo so that we can run modulo programs in CI
from starkware.cairo.common.math import safe_div, unsigned_div_rem
from starkware.cairo.common.registers import get_label_location

// Represents a 384-bit unsigned integer d0 + 2**96 * d1 + 2**192 * d2 + 2**288 * d3
// where each di is in [0, 2**96).
struct UInt384 {
    d0: felt,
    d1: felt,
    d2: felt,
    d3: felt,
}

// Specifies the Add and Mul Mod builtins memory structure.
struct ModBuiltin {
    // The modulus.
    p: UInt384,
    // A pointer to input values, the intermediate results and the output.
    values_ptr: UInt384*,
    // A pointer to offsets inside the values array, defining the circuit.
    // The offsets array should contain 3 * n elements.
    offsets_ptr: felt*,
    // The number of operations to perform.
    n: felt,
}

const BATCH_SIZE = 1;

// Returns the smallest felt 0 <= q < rc_bound such that x <= q * y.
func div_ceil{range_check_ptr}(x: felt, y: felt) -> felt {
    let (q, r) = unsigned_div_rem(x, y);
    if (r != 0) {
        return q + 1;
    } else {
        return q;
    }
}

// Fills the first instance of the add_mod and mul_mod builtins and calls the fill_memory hint to
// fill the rest of the instances and the missing values in the values table.
//
// This function uses a hardcoded value of batch_size=8, and asserts the instance definitions use
// the same value.
func run_mod_p_circuit_with_large_batch_size{
    range_check_ptr, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(
    p: UInt384,
    values_ptr: UInt384*,
    add_mod_offsets_ptr: felt*,
    add_mod_n: felt,
    mul_mod_offsets_ptr: felt*,
    mul_mod_n: felt,
) {
    const BATCH_SIZE = 8;
    let add_mod_n_instances = div_ceil(add_mod_n, BATCH_SIZE);
    assert add_mod_ptr[0] = ModBuiltin(
        p=p,
        values_ptr=values_ptr,
        offsets_ptr=add_mod_offsets_ptr,
        n=add_mod_n_instances * BATCH_SIZE,
    );

    let mul_mod_n_instances = div_ceil(mul_mod_n, BATCH_SIZE);
    assert mul_mod_ptr[0] = ModBuiltin(
        p=p,
        values_ptr=values_ptr,
        offsets_ptr=mul_mod_offsets_ptr,
        n=mul_mod_n_instances * BATCH_SIZE,
    );

    %{
        from starkware.cairo.lang.builtins.modulo.mod_builtin_runner import ModBuiltinRunner
        assert builtin_runners["add_mod_builtin"].instance_def.batch_size == ids.BATCH_SIZE
        assert builtin_runners["mul_mod_builtin"].instance_def.batch_size == ids.BATCH_SIZE

        ModBuiltinRunner.fill_memory(
            memory=memory,
            add_mod=(ids.add_mod_ptr.address_, builtin_runners["add_mod_builtin"], ids.add_mod_n),
            mul_mod=(ids.mul_mod_ptr.address_, builtin_runners["mul_mod_builtin"], ids.mul_mod_n),
        )
    %}

    let add_mod_ptr = &add_mod_ptr[add_mod_n_instances];
    let mul_mod_ptr = &mul_mod_ptr[mul_mod_n_instances];
    return ();
}

// Fills the first instance of the add_mod and mul_mod builtins and calls the fill_memory hint to
// fill the rest of the instances and the missing values in the values table.
//
// This function uses a hardcoded value of batch_size=1, and asserts the instance definitions use
// the same value.
func run_mod_p_circuit{add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*}(
    p: UInt384,
    values_ptr: UInt384*,
    add_mod_offsets_ptr: felt*,
    add_mod_n: felt,
    mul_mod_offsets_ptr: felt*,
    mul_mod_n: felt,
) {
    assert add_mod_ptr[0] = ModBuiltin(
        p=p, values_ptr=values_ptr, offsets_ptr=add_mod_offsets_ptr, n=add_mod_n
    );

    assert mul_mod_ptr[0] = ModBuiltin(
        p=p, values_ptr=values_ptr, offsets_ptr=mul_mod_offsets_ptr, n=mul_mod_n
    );

    %{
        from starkware.cairo.lang.builtins.modulo.mod_builtin_runner import ModBuiltinRunner
        assert builtin_runners["add_mod_builtin"].instance_def.batch_size == 1
        assert builtin_runners["mul_mod_builtin"].instance_def.batch_size == 1

        ModBuiltinRunner.fill_memory(
            memory=memory,
            add_mod=(ids.add_mod_ptr.address_, builtin_runners["add_mod_builtin"], ids.add_mod_n),
            mul_mod=(ids.mul_mod_ptr.address_, builtin_runners["mul_mod_builtin"], ids.mul_mod_n),
        )
    %}

    let add_mod_ptr = &add_mod_ptr[add_mod_n];
    let mul_mod_ptr = &mul_mod_ptr[mul_mod_n];
    return ();
}
