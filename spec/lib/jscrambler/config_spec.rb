require 'spec_helper'

describe JScrambler::Config do

  describe '#initialize' do

    it 'should load default config file' do
      expect(JScrambler::Config.new).to be_a JScrambler::Config
    end

    it 'should load custom config file' do
      expect(JScrambler::Config.new('spec/fixtures/jscrambler_config.json')).to be_a JScrambler::Config
    end

    context 'when API details are not provided' do

      it 'should raise an error' do
        expect{(JScrambler::Config.new('spec/fixtures/jscrambler_invalid_config.json'))}.to raise_error(JScrambler::MissingKeys)
      end
    end

    context 'when config file not found' do
      it 'should raise if config file not found' do
        stub_const('JScrambler::Config::DEFAULT_CONFIG_FILE', 'spec/fixtures/not_found.json')
        expect{JScrambler::Config.new}.to raise_error JScrambler::ConfigError
      end
    end
  end
end
