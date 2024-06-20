const MAX_HIGH = 1;
const MAX_LOW = 1;

func main() {
	let value =1;
	hint_func(MAX_HIGH, MAX_LOW, value);
	return();
}
func hint_func(MAX_HIGH: felt, MAX_LOW: felt, value: felt) -> (felt, felt) {
	alloc_locals;
	local low: felt;
	local high: felt;
    %{
        from starkware.cairo.common.math_utils import assert_integer
        assert ids.MAX_HIGH < 2**128 and ids.MAX_LOW < 2**128
        assert PRIME - 1 == ids.MAX_HIGH * 2**128 + ids.MAX_LOW
        assert_integer(ids.value)
        ids.low = ids.value & ((1 << 128) - 1)
        ids.high = ids.value >> 128
    %}
	return(low, high);
}
