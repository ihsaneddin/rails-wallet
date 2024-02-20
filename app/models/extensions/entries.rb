module Extensions
  module Entries

    def search(from: nil, to: nil, currency: nil)
      query = where.not(id: nil)
      if from && to
        from_date = from.kind_of?(Date) ? from : Date.parse(from)
        to_date = to.kind_of?(Date) ? to : Date.parse(to)
        query = query.where('date' => from_date..to_date)
      elsif from && to.nil?
        from_date = from.kind_of?(Date) ? from : Date.parse(from)
        query = query.where('date >= ?', from_date)
      elsif from.nil? && to
        to_date = to.kind_of?(Date) ? to : Date.parse(to)
        query = query.where('date <= ?', to_date).sum(:amount)
      end
      query = query.where(currency: currency.to_s.upcase) if currency
      query
    end

  end
end
