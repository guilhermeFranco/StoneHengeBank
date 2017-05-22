require 'spec_helper'

module StonehengeBank
  module Cli
    describe InterfaceDSL do
      let(:investment)    { double(:investment) }
      let(:interest_rate) { double(:interest_rate) }
      let(:rate_builder)  { double(:interest_rate_builder) }
      let(:equivalency)   { double(:equivalency) }
      let(:decorator)     { double(:decorator) }
      let(:dsl_object)    { double(:dsl) }

      describe '.simple_calculations &block' do
        it 'sets SimpleCalculationsBuilder and yields to receive its commands' do
          expect(SimpleCalculationsBuilder).to receive(:new).once

          expect { |b| described_class.simple_calculations(&b) }.to yield_control
        end

        it 'returns any errors raised on evaluation' do
          expect(
            described_class.simple_calculations do
              with_interest_rate '2.14'
            end
          ).to match /Interest rate used is not parseable/
        end
      end
    end
  end
end
