require 'spec_helper'

describe Minfraud::Response do
  let(:http_response_double) { double(Net::HTTPResponse, body: 'firstKey=first value;second_keyName=second value') }
  let(:err) { Faker::HipsterIpsum.word }

  describe '.new' do
    subject(:response) { Minfraud::Response.new(http_response_double) }
    it 'raises exception without an OK response'
    it 'raises exception if minFraud returns an error'
    it 'does not raise an exception if minFraud returns a warning'
    it 'turns raw body keys and values into attributes on the object' do
      expect(response.first_key).to eq('first value')
      expect(response.second_key_name).to eq('second value')
    end
  end

  describe '#errored?' do
    subject(:response) { Minfraud::Response.new(http_response_double) }

    it 'returns true if @error is not nil' do
      response.instance_variable_set(:@error, '')
      expect(response.errored?).to be_true
    end
  end

  describe '#error' do
    subject(:response) { Minfraud::Response.new(http_response_double) }

    it 'returns value of @error' do
      response.instance_variable_set(:@error, err)
      expect(response.error).to eq(err)
    end
  end

end
