module StonehengeBank
  module Cli
    class InterfaceDSL
      attr_reader :investment, :interest_rate, :period, :equivalency

      def simple_calculations(&block)
        @calculation_klass = Decorators::InvestmentDecorator
        instance_eval(&block)
      rescue => e
        e.message
      end

      def an_investment(with_present_value: nil, with_future_value: nil)
        @investment = Resources::Investment.new(
          present_value: with_present_value,
          future_value: with_future_value
        )
      end

      def with_interest_rate(rate_description)
        @interest_rate = Builders::InterestRateBuilder.new(
          rate_description
        ).construct_interest_rate
      end

      def on_period(period = nil, periodicity)
        @period      = period

        @equivalency = Calculators.const_get(
          "#{periodicity.capitalize}InterestEquivalency"
        ).new(interest_rate) if interest_rate
      end

      def future_value(verbosity)
        @calculation_klass.new(investment).public_send(
          define_method_by_verbosity(:future_value, verbosity),
          equivalency, period
        )
      end

      def present_value(verbosity)
        @calculation_klass.new(investment).public_send(
          define_method_by_verbosity(:present_value, verbosity),
          equivalency, period
        )
      end

      private

      def define_method_by_verbosity(calculation, verbosity)
        "calculated_#{calculation}".tap do |meth|
          meth << "_with_message" if verbosity
        end
      end
    end
  end
end
