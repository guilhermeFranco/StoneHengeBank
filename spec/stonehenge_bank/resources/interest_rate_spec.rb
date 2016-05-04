module StonehengeBank
  module Resources
    describe InterestRate do
      subject { described_class.new(0.06, @period) }

      it 'has a float-value attribute as its absolute value' do
        expect(subject).to have_attributes(value: 0.06)
      end

      it 'has a period string attached' do
        @period = 'monthly'

        expect(subject).to have_attributes(period: 'monthly')
      end

      describe '#method_missing predicate_period' do
        it 'returns true if interest is in months' do
          @period = 'monthly'

          expect(subject.monthly?).to be_truthy
        end

        it 'returns true if interest is in days' do
          @period = 'daily'

          expect(subject.daily?).to be_truthy
        end

        it 'returns true if interest is in quarters' do
          @period = 'quarterly'

          expect(subject.quarterly?).to be_truthy
        end

        it 'returns true if interest is in semesters' do
          @period = 'semiannually'

          expect(subject.semiannually?).to be_truthy
        end

        it 'returns true if interest is in years' do
          @period = 'annually'

          expect(subject.annually?).to be_truthy
        end

        it 'raises an exception if unknown periods are set' do
          @period = 'foo'

          expect { subject.foo? }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
