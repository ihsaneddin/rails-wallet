class Amount < ApplicationRecord

  belongs_to :entry, inverse_of: :amounts
  belongs_to :account, touch: true

  validates :amount, presence: true, numericality: { greater_than: 0, allow_blank: true }
  validates :account, presence: true

  delegate :number, to: :account

  attr_accessor :wallet_number

  before_validation :get_account_id

  def get_account_id
    if wallet_number
      if entry
        wallet = Wallet.find_by_number(wallet_number)
        curr = entry.currency
        if curr
          self.account= wallet.accounts.find_by(currency: curr.to_s.upcase)
          unless self.account
            errors.add(:account, :account_currency_is_not_yet_created, message: "No account with #{curr} currency in the wallet")
          end
        end
      end
    end
  end

  def as_json options={}
    res = super **options
    res[:wallet_number] = number
    res[:type] = type
    res
  end

end
