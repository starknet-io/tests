#[starknet::interface]
trait ITestUint256DivMod<TContractState> {
    fn test_uint256_div_mod_max(ref self: TContractState);
    fn test_uint256_div_mod(ref self: TContractState, a: u128, b: u128) -> felt252;
}

#[starknet::contract]
mod TestUint256DivMod {
    use zeroable::IsZeroResult;
    use zeroable::NonZeroIntoImpl;
    use zeroable::NonZero;
    use core::traits::Into;
    use traits::TryInto;
    use integer::BoundedInt;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl TestUint256DivMod of super::ITestUint256DivMod<ContractState> {
        fn test_uint256_div_mod_max(ref self: ContractState) {
            let a = BoundedInt::max();

            let b = as_u256(1_u128, 0);
            let b = integer::u256_as_non_zero(b);

            let (div, _, _) = integer::u256_safe_divmod(a, b);

            assert(div == a, 'div failed');
        }

        fn test_uint256_div_mod(ref self: ContractState, a: u128, b: u128) -> felt252 {
            let a = as_u256(a, 0);
            let b = as_u256(b, 0);

            let b = integer::u256_as_non_zero(b);

            let (div, _, _) = integer::u256_safe_divmod(a, b);

            return div.low.into();
        }
    }

    fn as_u256(a: u128, b: u128) -> u256 {
        u256 { low: a, high: b }
    }
}
