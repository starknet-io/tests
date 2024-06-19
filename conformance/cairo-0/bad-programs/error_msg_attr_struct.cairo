%builtins range_check
from starkware.cairo.common.math import assert_le

struct Cat {
    paws: felt,
    lives: felt,
}

func main{range_check_ptr}() {
    alloc_locals;
    local cat: Cat = Cat(2, 10);
    with_attr error_message("Cats cannot have more than nine lives: {cat}") {
        assert_le(cat.lives, 9);
    }
    return();
}
