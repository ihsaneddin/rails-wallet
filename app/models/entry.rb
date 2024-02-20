class Entry < ApplicationRecord

  has_many :amounts, inverse_of: :entry, dependent: :destroy
  has_one :amounts_credit, class_name: "Amounts::Credit", inverse_of: :entry, dependent: :destroy
  has_one :amounts_debit, class_name: "Amounts::Debit", inverse_of: :entry, dependent: :destroy
  has_one :account, through: :amounts_credit

  validates :currency, presence: true

  accepts_nested_attributes_for :amounts_credit, allow_destroy: true
  accepts_nested_attributes_for :amounts_debit, allow_destroy: true

  alias_method :source=, :amounts_credit_attributes=
  alias_method :target=, :amounts_debit_attributes=
  alias_method :source, :amounts_credit
  alias_method :target, :amounts_debit

  validate :amounts_cancel?
  validate :amounts_credit?
  validate :amounts_debit?

  before_save :default_date

  def default_date
    unless self.date
      today = ApplicationRecord.default_timezone == :utc ? Time.now.utc : Time.now
      self.date= today
    end
  end


  def amounts_credit?
    raise "Must be implemented"
  end

  def amounts_debit?
    raise "Must be implemented"
  end

  def amounts_cancel?
    raise "Must be implemented"
  end

  def as_json options={}
    res = super(**options)
    res[:type] = type
    res
  end

end
