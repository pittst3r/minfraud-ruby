require 'spec_helper'

describe Minfraud do

  describe '.configure' do
    it 'yields the Minfraud module' do
      Minfraud.configure do |c|
        expect(c).to eql(Minfraud)
      end
    end
  end

  describe '.license_key' do
    let(:license_key) { 'asdf' }
    before { Minfraud.remove_class_variable(:@@license_key) if Minfraud.class_variable_defined?(:@@license_key) }

    it 'gets license key attribute set on Minfraud module' do
      Minfraud.class_variable_set(:@@license_key, license_key)
      expect(Minfraud.license_key).to eq(license_key)
    end

    it 'returns nil when license key attribute is not set' do
      expect(Minfraud.license_key).to eq(nil)
    end
  end

  describe '.license_key=' do
    let(:license_key) { 'asdf' }
    before { Minfraud.remove_class_variable(:@@license_key) if Minfraud.class_variable_defined?(:@@license_key) }

    it 'sets license key attribute on Minfraud module' do
      Minfraud.license_key = license_key
      expect(Minfraud.class_variable_get(:@@license_key)).to eq(license_key)
    end
  end

  describe '.uri' do
    it 'returns the minFraud service uri' do
      expect(Minfraud.uri).to eq('https://minfraud.maxmind.com/app/ccv2r')
    end
  end

end
