module ActsAsWalletOwner
  extend ActiveSupport::Concern

  DEFAULT_CURRENCIES = ["IDR"]

  included do
    has_one :wallet, as: :owner
    has_many :accounts, through: :wallet
    has_many :entries, through: :accounts
    after_create :generate_wallet
    delegate :deposit, :withdraw, :transfer, to: :wallet
  end

  def make_wallet
    generate_wallet
  end

  protected

    def generate_wallet
      if wallet.blank?
        build_wallet.save
        if wallet.persisted?
          DEFAULT_CURRENCIES.each do |curr|
            wallet.accounts.create(currency: curr)
          end
        end
      end
    end

end