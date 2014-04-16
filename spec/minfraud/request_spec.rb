require 'spec_helper'

describe Minfraud::Request do
  subject(:request) { Minfraud::Request.new(transaction) }
  let(:transaction) { double(Minfraud::Transaction, attributes: {}) }
  let(:error_response) { double(Minfraud::Response, errored?: true, error: exception) }
  let(:success_response) { double(Minfraud::Response, errored?: false) }
  let(:exception) { Minfraud::ResponseError.new('Message from MaxMind: INVALID_LICENSE_KEY') }

  describe '.new' do
    it 'binds the @transaction instance variable' do
      expect(request.instance_variable_get(:@transaction)).to eql(transaction)
    end
  end

  describe '#post' do
    it 'sends request to MaxMind' do
      expect(Net::HTTP).to receive(:start)
      request.post
    end

    it 'sends post request' do
      Net::HTTP.stub(:start) do |host, port, opts, &block|
        http_dbl = double()
        expect(http_dbl).to receive(:request).with(an_instance_of(Net::HTTP::Post))
        block.call http_dbl
      end
      request.post
    end

    it 'sends appropriately encoded transaction data' do
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
      Minfraud.stub(:license_key).and_return('6')
      Net::HTTP.stub(:start) do |host, port, opts, &block|
        expect(Net::HTTP::Post).to receive(:new).with(Minfraud.uri.to_s, request_body)
        block.call double(:http, request: nil)
      end
      Minfraud::Request.new(trans).post
    end

    it 'raises an exception if MaxMind responds with an error' do
      Minfraud::Response.stub(:new).and_return(error_response)
      request.stub(:send_post_request)
      expect { request.post }.to raise_exception(Minfraud::ResponseError, /Message from MaxMind/)
    end

    it 'creates Response object out of raw response' do
      expect(request).to receive(:send_post_request)
      expect(Minfraud::Response).to receive(:new).and_return(success_response)
      request.post
    end

    it 'returns Response object' do
      request.stub(:send_post_request)
      Minfraud::Response.stub(:new).and_return(success_response)
      expect(request.post).to eql(success_response)
    end
  end

end
