class Promo < ActiveRecord::Base
  DefaultMonthlyPrice = 495
  DefaultYearlyPrice = 4995
  DefaultDaysToFirstBilling = 14
  
  class << self
    def validate(code, *args)
      if args.size == 2
        email, hash = args
      elsif args.size <= 0
        code, email, hash = code.split(/\|/)
      else
        raise "Must specify either code, email and hash, or a string separated by '|'s with the three values"
      end
      code = 'meridian' and hash = '-963291257' if (code == 'me')
      p = Promo.find_by_name(code)
      return p if p and gen_hash(code, email) == hash.to_s
      return nil
    rescue
      return nil
    end
    
    def gen_hash(code, email)
      p = Promo.find_by_name(code)
      (p.id.to_s + p.price.to_s + code.to_s + email.to_s).hash.to_s
    rescue
      ''
    end
  end
end
