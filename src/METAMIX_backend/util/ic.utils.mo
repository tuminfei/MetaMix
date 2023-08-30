import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";

import IC "../service/ic";

module {

    public class ICUtils() {
        private let ic : IC.Self = actor "aaaaa-aa";
        public func transferCycles(caller : Principal) : async () {
            let balance : Nat = Cycles.balance();
            let cycles : Nat = balance - 100_000_000_000;
            if (cycles > 0) {
                Cycles.add(cycles);
                await ic.deposit_cycles({ canister_id = caller });
            };
        };

        public func deleteCanister(canister_id : Principal) : async () {
            let canister = actor (Principal.toText(canister_id)) : actor {
                transferCycles : () -> async ();
            };
            await canister.transferCycles();
            await ic.stop_canister({ canister_id = canister_id });
            await ic.delete_canister({ canister_id = canister_id });
        };
    };
};
