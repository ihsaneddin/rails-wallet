module Entries
  class Withdraw < ::Entry

    def amounts_credit?
      unless persisted?
        unless self.source.present?
          errors.add(:source, :source_is_invalid, message: "Source is missing")
        end
      end
    end

    def amounts_debit?
      unless persisted?
        if self.target.present?
          errors.add(:target, :target_is_invalid, message: "Target is invalid")
        end
      end
    end

    def amounts_cancel?
      if source
        account = source.account
        if account.balance < source.amount
          errors.add(:source, :source_account_balance_is_insufficient, message: "Source account balance is insufficient")
        end
        unless account
          errors.add(:target, :source_account_is_required, message: "Source wallet is missing the currency")
        end
      end
    end

    def as_json options={}
      res = super(**options)
      res[:source] = source.as_json
      res
    end

  end
end