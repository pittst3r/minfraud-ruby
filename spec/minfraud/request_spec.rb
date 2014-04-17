require 'spec_helper'

describe Minfraud::Request do
  subject(:request) { Minfraud::Request.new(transaction) }
  let(:transaction) { double(Minfraud::Transaction, attributes: {}) }
  let(:success_response) { double(Minfraud::Response, errored?: false, body: '') }
  let(:exception) { Minfraud::ResponseError.new('Message from MaxMind: INVALID_LICENSE_KEY') }

  describe '.new' do
    it 'binds the @transaction instance variable' do
      expect(request.instance_variable_get(:@transaction)).to eql(transaction)
    end
  end

  describe '#get' do
    it 'sends appropriately encoded transaction data to minFraud service' do
      Minfraud.stub(:license_key).and_return('6')
      Minfraud::Response.stub(:new).and_return(success_response)
      trans = Minfraud::Transaction.new do |t|
        t.ip = '1'
        t.city = '2'
        t.state = '3'
        t.postal = '4'
        t.country = '5'
      end
      request_body = {
        'i' => '1',
        'city' => '2',
        'region' => '3',
        'postal' => '4',
        'country' => '5',
        'license_key' => '6'
      }
      expect(Net::HTTP).to receive(:get_response) do |uri|
        expect(uri.to_s).to include(Minfraud.uri.to_s)
        expect(uri.query).to include(URI.encode_www_form(request_body))
      end
      Minfraud::Request.new(trans).get
    end

    it 'creates Response object out of raw response' do
      expect(request).to receive(:send_get_request)
      expect(Minfraud::Response).to receive(:new).and_return(success_response)
      request.get
    end

    it 'returns Response object' do
      request.stub(:send_get_request)
      Minfraud::Response.stub(:new).and_return(success_response)
      expect(request.get).to eql(success_response)
    end
  end

end
