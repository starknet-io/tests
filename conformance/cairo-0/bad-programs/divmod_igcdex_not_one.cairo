struct MyStruct0 {
	high: felt,
    low: felt,
}

func main() {
	let a = MyStruct0(high=1, low=340282366920938463463374607431768211456);
	let b = MyStruct0(high=1, low=1);
	let p = MyStruct0(high=1, low=1);
	let (a, b, p, b_inverse_mod_p) = hint_func(a, b, p);

	return();
}

func hint_func(a: MyStruct0, b: MyStruct0, p: MyStruct0) -> (MyStruct0, MyStruct0, MyStruct0, MyStruct0) {
	alloc_locals;
	local b_inverse_mod_p: MyStruct0;
    %{
        from starkware.python.math_utils import div_mod

        def split(a: int):
            return (a & ((1 << 128) - 1), a >> 128)

        def pack(z, num_bits_shift: int) -> int:
            limbs = (z.low, z.high)
            return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

        a = pack(ids.a, 128)
        b = pack(ids.b, 128)
        p = pack(ids.p, 128)
        # For python3.8 and above the modular inverse can be computed as follows:
        # b_inverse_mod_p = pow(b, -1, p)
        # Instead we use the python3.7-friendly function div_mod from starkware.python.math_utils
        b_inverse_mod_p = div_mod(1, b, p)

        b_inverse_mod_p_split = split(b_inverse_mod_p)

        ids.b_inverse_mod_p.low = b_inverse_mod_p_split[0]
        ids.b_inverse_mod_p.high = b_inverse_mod_p_split[1]
    %}
	return(a, b, p, b_inverse_mod_p);
}
