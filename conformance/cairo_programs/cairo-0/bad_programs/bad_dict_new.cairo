from starkware.cairo.common.dict import dict_new
from starkware.cairo.common.dict_access import DictAccess

func main() {
    alloc_locals;
    // This call should fail as there is no initial dictionary
    let (local my_dict: DictAccess*) = dict_new();
    return ();
}
