ADMIN_PRINCIPAL=$(dfx identity get-principal)
ADMIN_ACCOUNTID=$(dfx ledger account-id)
TEST_PRINCIPAL='i3o4q-ljrhf-s4evb-ux72j-qdb6g-wzq66-73nfa-h2k3x-dw7zj-4cxkd-zae'
echo $ADMIN_PRINCIPAL
echo $ADMIN_ACCOUNTID
echo $TEST_PRINCIPAL

dfx deploy --network=local METAMIX_backend --argument "(principal \"$ADMIN_PRINCIPAL\")" --mode reinstall