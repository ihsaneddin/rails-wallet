module Extensions
  module Amounts

    def balance(from: nil,to: Date.today)
      if from && to
        from_date = from.kind_of?(Date) ? from : Date.parse(from)
        to_date = to.kind_of?(Date) ? to : Date.parse(to)
        includes(:entry).where('entries.date' => from_date..to_date).sum(:amount)
      elsif from && to.nil?
        from_date = from.kind_of?(Date) ? from : Date.parse(from)
        includes(:entry).where('entries.date >= ?', from_date).sum(:amount)
      elsif from.nil? && to
        to_date = to.kind_of?(Date) ? to : Date.parse(to)
        includes(:entry).where('entries.date <= ?', to_date).sum(:amount)
      else
        sum(:amount)
      end
    end

  end
end
