from starkware.starknet.core.os.contract_class.deprecated_compiled_class import (
    DeprecatedCompiledClass,
    DeprecatedCompiledClassFact
)
from starkware.cairo.common.alloc import alloc

func main() {
    alloc_locals;
    local compiled_class_facts: DeprecatedCompiledClassFact*;
    %{ ids.compiled_class_facts = segments.add() %}
    let compiled_class_fact = compiled_class_facts;
    let compiled_class = compiled_class_fact.compiled_class;
    %{  
        from starkware.starknet.services.api.contract_class.contract_class import DeprecatedCompiledClass
        from starkware.starknet.core.os.contract_class.deprecated_class_hash import (
            get_deprecated_contract_class_struct,
        )
        with open("test_contract.json", "r") as f:
            compiled_class = DeprecatedCompiledClass.loads(f.read())
         
        cairo_contract = get_deprecated_contract_class_struct(
            identifiers=ids._context.identifiers, contract_class=compiled_class)
        ids.compiled_class = segments.gen_arg(cairo_contract)
    %}
    local compiled_class: DeprecatedCompiledClass* = compiled_class;
    local destination: felt* = compiled_class.bytecode_ptr;
    %{
        vm_load_program(compiled_class.program, ids.compiled_class.bytecode_ptr)
    %}
    call abs destination;
    return ();
}
