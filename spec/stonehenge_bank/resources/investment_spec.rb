module StonehengeBank
  module Resources
    describe Investment do
      let(:interest_rate) { double(:interest_rate) }
      let(:interest_equivalency) { double(:calculator) }

      context 'a newly created investment' do
        subject { described_class.new(present_value: 100.0) }

        it { is_expected.to have_attributes(present_value: 100.0, future_value: nil) }
      end

      context 'can be created with a future value instead' do
        subject { described_class.new(future_value: 100.0) }

        it { is_expected.to have_attributes(present_value: nil, future_value: 100.0) }
      end

      subject { described_class.new(present_value: 100.0) }

      before do
        allow(
          Calculators::YearInterestEquivalency
        ).to receive(:new).with(interest_rate).and_return(interest_equivalency)
      end

      describe '#calculated_future_value equivalency, quantity' do
        it 'returns the calculated future value based on the period asked' do
          allow(interest_equivalency).to receive(:transformed_rate).
                                          and_return(0.006)

          expect(
            subject.calculated_future_value(interest_equivalency, 2)
          ).to eql(101.20)
        end
      end

      describe '#calculated_present_value equivalency, quantity' do
        let(:investment) { Investment.new(future_value: 150.0) }

        it 'returns the calculated present value based on the period asked' do
          allow(interest_equivalency).to receive(:transformed_rate).
                                          and_return(0.006)

          expect(
            investment.calculated_present_value(interest_equivalency, 2)
          ).to eql(148.22)
        end
      end

      describe '#calculated_investment_period equivalency' do
        it 'returns the period in which an investment takes place to a determined value and rate' do
          investment = Investment.new(present_value: 100.0, future_value: 1450.0)

          allow(interest_equivalency).to receive(:transformed_rate).
                                          and_return(0.1248)

          expect(
            investment.calculated_investment_period(interest_equivalency)
          ).to eql 23
        end

        it 'returns an error if present value is not set' do
          investment = Investment.new(future_value: 1450.0)

          expect {
            investment.calculated_investment_period(interest_equivalency)
          }.to raise_error('Cannot calculate period with null values.')
        end

        it 'returns an error if future value is not set' do
          investment = Investment.new(present_value: 1450.0)

          expect {
            investment.calculated_investment_period(interest_equivalency)
          }.to raise_error('Cannot calculate period with null values.')
        end
      end
    end
  end
end
