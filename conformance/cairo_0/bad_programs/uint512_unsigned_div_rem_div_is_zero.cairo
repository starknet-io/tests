
struct MyStruct1 {
	d0: felt,
	d1: felt,
	d2: felt,
	d3: felt,
}
struct MyStruct0 {
	low: felt,
	high: felt,
}
func main() {
	let x =MyStruct1(d0=1, d1=1, d2=1, d3=1);
	let div = MyStruct0(low=0, high=0);
	hint_func(x, div);
	return();
}

func hint_func(x: MyStruct1, div: MyStruct0) {
	alloc_locals;
    local quotient: MyStruct1;
    local remainder: MyStruct0;

%{
def split(num: int, num_bits_shift: int, length: int):
    a = []
    for _ in range(length):
        a.append( num & ((1 << num_bits_shift) - 1) )
        num = num >> num_bits_shift
    return tuple(a)

def pack(z, num_bits_shift: int) -> int:
    limbs = (z.low, z.high)
    return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

def pack_extended(z, num_bits_shift: int) -> int:
    limbs = (z.d0, z.d1, z.d2, z.d3)
    return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

x = pack_extended(ids.x, num_bits_shift = 128)
div = pack(ids.div, num_bits_shift = 128)

quotient, remainder = divmod(x, div)

quotient_split = split(quotient, num_bits_shift=128, length=4)

ids.quotient.d0 = quotient_split[0]
ids.quotient.d1 = quotient_split[1]
ids.quotient.d2 = quotient_split[2]
ids.quotient.d3 = quotient_split[3]

remainder_split = split(remainder, num_bits_shift=128, length=2)
ids.remainder.low = remainder_split[0]
ids.remainder.high = remainder_split[1]
%}
	return();
}
