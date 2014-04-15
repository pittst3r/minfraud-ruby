require 'spec_helper'

describe Minfraud::Transaction do

  describe '.new' do
    it 'yields the current instance module' do
      Minfraud::Transaction.new do |t|
        t.stub(:has_required_attributes?).and_return(true)
        t.stub(:validate_attributes).and_return(nil)
        expect(t).to be_an_instance_of(Minfraud::Transaction)
      end
    end

    it 'raises an exception if required attributes are not set' do
      expect { Minfraud::Transaction.new { |c| true } }.to raise_exception(Minfraud::TransactionError, /required/)
    end

    it 'raises an exception if attributes are invalid' do
      transaction = lambda do
        Minfraud::Transaction.new do |t|
          t.ip = ''
          t.city = 2
          t.state = ''
          t.postal = ''
          t.country = ''
        end
      end
      expect { transaction.call }.to raise_exception(Minfraud::TransactionError, /city must me a string/)
    end
  end

end
