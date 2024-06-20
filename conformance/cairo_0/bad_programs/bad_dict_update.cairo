from starkware.cairo.common.dict import dict_update, dict_write
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict_access import DictAccess

func main() {
    alloc_locals;
    let (local my_dict: DictAccess*) = default_dict_new(7);
    dict_write{dict_ptr=my_dict}(key=2, new_value=5);
    // This call should fail as the current value for key 2 is 5, not 3
    dict_update{dict_ptr=my_dict}(key=2, prev_value=3, new_value=4);
    return ();
}
