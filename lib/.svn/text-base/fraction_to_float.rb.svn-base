# only handles positive fractions - at least tested
# only handles single digit fractions
class FractionToFloat
  def initialize fraction
    # de-normalize the fraction - 1 1/2 becomes 11/2
    # this class assumes that you can't have fractions like 11/2 that mean 5 1/2 - 5 1/2 would be de-normalized to 51/2
    fraction.gsub!(/\s/, '')
    num, den = fraction.split(/\//).collect{|i| i.to_i}

    #normalize fraction
    if (den.to_i == 0)
      @num = num
      @den = 0
    elsif (num > den)
      @den = den
      @num = (num/10 * @den) + num % 10
    else
      @num, @den = num, den
    end
  rescue
  end

  def to_f
    if @den != 0
      @num / (@den * 1.0)
    else
      @num * 1.0
    end
  rescue
    0.0
  end
end
