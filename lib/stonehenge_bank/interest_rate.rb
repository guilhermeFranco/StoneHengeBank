module StonehengeBank
  class InterestRate
    attr_reader :value, :period

    def initialize(value, period)
      @value, @period = value, period
    end

    def method_missing(method_name)
      if matches_real_period? method_name
        @period.start_with? method_name.to_s.chomp('?')
      else
        super
      end
    end

    private

    def matches_real_period?(period)
      period =~ /annual|daily|month|semiannual|quarter/
    end
  end
end
