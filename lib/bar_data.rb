# a bar data encapsulates data for a single stock over the Bar period
class BarData
  FIELDS = %i{ symbol date open high low close volume adj_close }

  def initialize data
    data.slice(*FIELDS).each do |k, v|
      class_eval { attr_accessor k }
      instance_variable_set "@#{k}", v
    end
  end
end
