module AptosFramework::SystemAddresses {
    use Std::Errors;
    use Std::Signer;

    /// The address/account did not correspond to the core resource address
    const ENOT_CORE_RESOURCE_ADDRESS: u64 = 0;
    /// The operation can only be performed by the VM
    const EVM: u64 = 1;

    public fun assert_core_resource(account: &signer) {
        assert_core_resource_address(Signer::address_of(account))
    }
    spec assert_core_resource {
        pragma opaque;
        include AbortsIfNotCoreResource {addr: Signer::address_of(account) };
    }

    public fun assert_core_resource_address(addr: address) {
        assert!(is_core_resource_address(addr), Errors::requires_address(ENOT_CORE_RESOURCE_ADDRESS))
    }
    spec assert_core_resource_address {
        pragma opaque;
        include AbortsIfNotCoreResource;
    }

    /// Specifies that a function aborts if the account does not have the root address.
    spec schema AbortsIfNotCoreResource {
        addr: address;
        aborts_if addr != @CoreResources with Errors::REQUIRES_ADDRESS;
    }

    public fun is_core_resource_address(addr: address): bool {
        addr == @CoreResources
    }

    /// Assert that the signer has the VM reserved address.
    public fun assert_vm(account: &signer) {
        assert!(Signer::address_of(account) == @VMReserved, Errors::requires_address(EVM))
    }
    spec assert_vm {
        pragma opaque;
        include AbortsIfNotVM;
    }

    /// Specifies that a function aborts if the account does not have the VM reserved address.
    spec schema AbortsIfNotVM {
        account: signer;
        aborts_if Signer::address_of(account) != @VMReserved with Errors::REQUIRES_ADDRESS;
    }
}
