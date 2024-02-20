require 'securerandom'

class Wallet < ApplicationRecord

  belongs_to :owner, polymorphic: true
  has_many :accounts, dependent: :destroy
  has_many :entries, through: :accounts, class_name: "Entry", extend: Extensions::Entries

  validates :number, presence: true, uniqueness: { allow_blank: true }
  validates :owner_id, presence: true, uniqueness: { allow_blank: true, scope: [:owner_type] }

  before_validation :generate_number

  def as_json options={}
    res = super **options
    res[:accounts] = accounts.as_json
    res
  end

  def deposit amount: nil, currency: nil, description: nil, date: nil
    _deposit = Entries::Deposit.new(
      target: { amount: amount, wallet_number: number },
      currency: currency.to_s.upcase,
      date: date,
      description: description
    )
    with_lock do
      _deposit.save
    end
    _deposit
  end

  def withdraw amount: nil, currency: nil, description: nil, date: nil
    _withdraw = Entries::Withdraw.new(
      source: { amount: amount, wallet_number: number },
      currency: currency.to_s.upcase,
      date: date,
      description: description
    )
    with_lock do
      _withdraw.save
    end
    _withdraw
  end

  def transfer amount: nil, currency: nil, description: nil, date: nil, target_wallet_number: nil
    _transfer = Entries::Transfer.new(
      source: { amount: amount, wallet_number: number },
      target: { amount: amount, wallet_number: target_wallet_number },
      currency: currency.to_s.upcase,
      date: date,
      description: description
    )
    with_lock do
      _transfer.save
    end
    _transfer
  end

  protected

    def generate_number
      self.number = loop do
        proposed_number = SecureRandom.random_number(10**12).to_s.rjust(12, '0')
        break proposed_number unless self.class.exists?(number: proposed_number)
      end
    end


end
