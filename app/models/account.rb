class Account < ApplicationRecord


  belongs_to :wallet, touch: true
  has_many :amounts
  has_many :entries, through: :amounts, :class_name => 'Entry', extend: Extensions::Entries, dependent: :destroy
  has_many :amounts_credits, extend: Extensions::Amounts, dependent: :destroy, class_name: "Amounts::Credit"
  has_many :amounts_debits, extend: Extensions::Amounts, dependent: :destroy, class_name: "Amounts::Debit"
  has_many :credit_entries, :through => :amounts_credits, :source => :entry, :class_name => 'Entry'
  has_many :debit_entries, :through => :amounts_debits, :source => :entry, :class_name => 'Entry'

  validates :currency, presence: true, uniqueness: { allow_blank: true, scope: [:wallet_id] }

  delegate :number, to: :wallet

  before_validation do
    self.currency = currency.to_s.upcase
  end

  def balance(options={})
    debit_balance(options) - credit_balance(options)
  end

  def credit_balance(options={})
    amounts_credits.balance(**options)
  end

  def debit_balance(options={})
    amounts_debits.balance(**options)
  end

  def as_json options={}
    opts = options.extract! :from, :to
    res = super(**options)
    res[:balance] = balance(opts)
    res
  end

end
