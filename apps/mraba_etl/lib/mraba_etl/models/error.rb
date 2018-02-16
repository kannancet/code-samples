class Error

  TYPES = {
            account_invalid: "{ACTIVITY_ID}: AccountTransfer validation error(s): {MESSAGE}",
            account_not_found: "{ACTIVITY_ID}: AccountTransfer not found {MESSAGE}",
            account_invalid_state: "{ACTIVITY_ID}: AccountTransfer state expected 'pending' but was {MESSAGE}",
            bank_transfer_invalid: "{ACTIVITY_ID}: BankTransfer validation error(s): {MESSAGE}",
            invalid_sender: "{ACTIVITY_ID}: BLZ/Konto not valid, csv fiile not written {MESSAGE}"
          }
end
