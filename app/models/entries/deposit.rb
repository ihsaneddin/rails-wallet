module Entries
  class Deposit < ::Entry

    def amounts_credit?
      if self.source.present?
        errors.add(:source, :source_is_invalid, message: "Source is invalid")
      end
    end

    def amounts_debit?
      if self.target.blank?
        errors.add(:target, :target_is_invalid, message: "Target is missing")
      end
    end

    def amounts_cancel?
      if target
        account = target.account
        unless account
          errors.add(:target, :target_account_is_required, message: "Target wallet is missing the currency")
        end
      end
    end

    def as_json options={}
      res = super(**options)
      res[:target] = target.as_json
      res
    end

  end
end