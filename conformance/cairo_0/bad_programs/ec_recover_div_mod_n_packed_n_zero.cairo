struct BigInt3 {
    d0: felt,
    d1: felt,
    d2: felt,
}

func main() {
    let x = BigInt3(d0=0, d1=0, d2=1);
    let s = BigInt3(d0=0, d1=0, d2=1);
    let n = BigInt3(d0=0, d1=0, d2=0);
    ec_recover_product(x, s, n);
    return();
}

func ec_recover_product(x:BigInt3, s:BigInt3, n:BigInt3) {
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack
        from starkware.python.math_utils import div_mod, safe_div

        N = pack(ids.n, PRIME)
        x = pack(ids.x, PRIME) % N
        s = pack(ids.s, PRIME) % N
        value = res = div_mod(x, s, N)
    %}
    return();
}
