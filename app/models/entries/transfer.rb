module Entries
  class Transfer < ::Entry

    def amounts_credit?
      if source.present?
        if source.account.blank?
          errors.add(:source, :source_account_is_invalid, message: "Source account is missing")
        end
      else
        errors.add(:source, :source_is_invalid, message: "Source is missing")
      end
    end

    def amounts_debit?
      if self.target.present?
        if target.account.blank?
          errors.add(:source, :target_account_is_invalid, message: "Source account is missing")
        end
      else
        errors.add(:target, :target_is_invalid, message: "Target is missing")
      end
    end

    def amounts_cancel?
      if target
        if source.present? && source.account
          if source.account.balance < source.amount
            errors.add(:source, :source_account_balance_is_insufficient, message: "Source account balance is insufficient")
          end
        end
        account = target.account
        unless account
          errors.add(:target, :target_account_is_required, message: "Target wallet is missing the currency")
        end
      end
    end

    def as_json options={}
      res = super(**options)
      res[:source] = source.as_json
      res[:target] = target.as_json
      res
    end

  end
end