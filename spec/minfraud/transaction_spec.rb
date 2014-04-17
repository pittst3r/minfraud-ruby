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

  describe '#risk_score' do
    subject(:transaction) do
      Minfraud::Transaction.new do |t|
        t.stub(:has_required_attributes?).and_return(true)
        t.stub(:validate_attributes).and_return(nil)
      end
    end
    let(:response) { double(risk_score: risk_score) }
    let(:risk_score) { 3.4 }

    before do
      Minfraud::Request.stub(:get).and_return(response)
    end

    context 'transaction has not already been sent to MaxMind' do
      it 'sends transaction to MaxMind' do
        expect(Minfraud::Request).to receive(:get).with(transaction)
        transaction.risk_score
      end

      it 'caches response' do
        transaction.risk_score
        expect(transaction.instance_variable_get(:@response)).to eql(response)
      end

      it 'returns float containing risk score' do
        transaction.risk_score
        expect(transaction.risk_score).to eq(risk_score)
      end
    end

    context 'transaction has already been sent to MaxMind' do
      before { transaction.instance_variable_set(:@response, response) }

      it 'does not send transaction to MaxMind' do
        expect(Minfraud::Request).not_to receive(:get)
        transaction.risk_score
      end

      it 'returns float containing risk score' do
        expect(transaction.risk_score).to eq(risk_score)
      end
    end
  end

  describe '#attributes' do
    subject(:transaction) do
      Minfraud::Transaction.new do |t|
        t.ip = 'ip'
        t.city = 'city'
        t.state = 'state'
        t.postal = 'postal'
        t.country = 'country'
      end
    end

    it 'returns a hash of attributes' do
      expect(transaction.attributes[:ip]).to eq('ip')
      expect(transaction.attributes[:city]).to eq('city')
      expect(transaction.attributes[:state]).to eq('state')
      expect(transaction.attributes[:postal]).to eq('postal')
      expect(transaction.attributes[:country]).to eq('country')
    end
  end

end
