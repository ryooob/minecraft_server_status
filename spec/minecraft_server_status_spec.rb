require 'spec_helper'

describe MinecraftServerStatus do
  it 'has a version number' do
    expect(MinecraftServerStatus::VERSION).not_to be nil
  end

  describe 'initialize' do
    it 'should initialize' do
      expect { MinecraftServerStatus::Query.new("example.com") }.not_to raise_error
    end

    it 'should initialize(not default port)' do
      query = MinecraftServerStatus::Query.new("example.com", 25560)
      expect(query.port).to eq 25560
    end

    it 'should raise' do
      expect { MinecraftServerStatus::Query.new }.to raise_error
    end

    it 'should raise' do
      expect { MinecraftServerStatus::Query.new(nil) }.to raise_error
    end
  end

  describe 'execute' do
    it 'should not alive' do
      query = MinecraftServerStatus::Query.new("example.com")
      result = query.execute
      expect(result.alive?).to eq false
    end

    it 'should not alive(3 times)' do
      query = MinecraftServerStatus::Query.new("example.com")
      result = query.execute(timeout_sec: 1, retry_limit: 3)
      expect(result.errors.size).to eq 3
    end
  end
  
end
