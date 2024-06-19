
struct MyStruct0 {
	low: felt,
	high: felt,
}
func main() {
	let a = MyStruct0(low=54987052180710815841462937121160005261203577276882008045698301095581843457, high=10);
	let b = MyStruct0(low=2, high=3618502788666131213697322783095070105623107215331596699973087835080668217346);
	let res = MyStruct0(low=1, high=1);
	hint_func(a, b, res);
	return();
}

func hint_func(a: MyStruct0, b: MyStruct0, res: MyStruct0) -> (MyStruct0, MyStruct0, MyStruct0) {
	alloc_locals;

%{
def split(num: int, num_bits_shift: int = 128, length: int = 2):
    a = []
    for _ in range(length):
        a.append( num & ((1 << num_bits_shift) - 1) )
        num = num >> num_bits_shift
    return tuple(a)

def pack(z, num_bits_shift: int = 128) -> int:
    limbs = (z.low, z.high)
    return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

a = pack(ids.a)
b = pack(ids.b)
res = (a - b)%2**256
res_split = split(res)
ids.res.low = res_split[0]
ids.res.high = res_split[1]
%}
	return(a, b, res);
}
