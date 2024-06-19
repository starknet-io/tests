struct BigInt3 {
    d0: felt,
    d1: felt,
    d2: felt,
}

func main() {
    let a = BigInt3(d0=0, d1=0, d2=1);
    let b = BigInt3(d0=0, d1=0, d2=1);
    let m = BigInt3(d0=0, d1=0, d2=0);
    ec_recover_product(a, b, m);
    return();
}

func ec_recover_product(a:BigInt3, b:BigInt3, m:BigInt3) {
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack
        from starkware.python.math_utils import div_mod, safe_div

        a = pack(ids.a, PRIME)
        b = pack(ids.b, PRIME)
        product = a * b
        m = pack(ids.m, PRIME)

        value = res = product % m
    %}
    return();
}
