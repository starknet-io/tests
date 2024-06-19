struct MyStruct0 {
	low: felt,
	high: felt,
}
func main() {
	let a = MyStruct0(low=0, high=0);
	let b = MyStruct0(low=0, high=0);
	let div = MyStruct0(low=0, high=0);
	hint_func(a, b, div);
	return();
}
func hint_func(a: MyStruct0, b: MyStruct0, div: MyStruct0) -> (MyStruct0, MyStruct0, MyStruct0) {
	alloc_locals;
	local quotient_low: MyStruct0;
	local quotient_high: MyStruct0;
	local remainder: MyStruct0;
    %{
        a = (ids.a.high << 128) + ids.a.low
        b = (ids.b.high << 128) + ids.b.low
        div = (ids.div.high << 128) + ids.div.low
        quotient, remainder = divmod(a * b, div)

        ids.quotient_low.low = quotient & ((1 << 128) - 1)
        ids.quotient_low.high = (quotient >> 128) & ((1 << 128) - 1)
        ids.quotient_high.low = (quotient >> 256) & ((1 << 128) - 1)
        ids.quotient_high.high = quotient >> 384
        ids.remainder.low = remainder & ((1 << 128) - 1)
        ids.remainder.high = remainder >> 128
    %}
	return(quotient_low, quotient_high, remainder);
}
