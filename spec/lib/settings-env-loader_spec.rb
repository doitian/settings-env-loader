require 'settings-env-loader'

describe SettingsEnvLoader do
  let(:hash) do
    {
      :float => 1.2,
      :fixnum => 20,
      :array => [1, 2],
      :hash => {
        key: 'name',
        value: 'settings-env-loader'
      }
    }
  end

  subject { hash }

  before do
    hash.extend SettingsEnvLoader
  end

  before do
    $remember_env = ENV.to_hash
    ENV.replace $remember_env.dup
  end

  after do
    ENV.replace $remember_env
  end

  describe 'merge_env' do
    context 'when prefix is nil' do
      context 'ENV[FIXNUM] = 1' do
        before do
          ENV['FIXNUM'] = '1'
          hash.merge_env
        end

        its([:fixnum]) { should == 1 }
      end
      context 'ENV[FIXNUM] = 1.1' do
        before do
          ENV['FIXNUM'] = '1.1'
          hash.merge_env
        end

        its([:fixnum]) { should == 1 }
      end
      context 'ENV[FLOAT] = 1.5' do
        before do
          ENV['FLOAT'] = '1.5'
          hash.merge_env
        end

        its([:float]) { should == 1.5 }
      end
      context 'ENV[ARRAY] = [10,20]' do
        before do
          ENV['ARRAY'] = '[10,20]'
          hash.merge_env
        end

        its([:array]) { should == [10,20] }
      end
      context 'ENV[HASH_KEY] = key' do
        before do
          ENV['HASH_KEY'] = 'key'
          hash.merge_env
        end

        its([:hash]) { should == { :key => 'key', :value => 'settings-env-loader'} }
      end

      context 'when no ENV' do
        it 'should not be changed' do
          before = hash.dup
          hash.merge_env
          hash.should == before
        end
      end
    end

    context 'when prefix is SETTINGS' do
      context 'ENV[FIXNUM] = 1' do
        before do
          ENV['FIXNUM'] = '1'
          hash.merge_env('SETTINGS')
        end

        its([:fixnum]) { should == 20 }
      end
      context 'ENV[SETTINGS_FIXNUM] = 1' do
        before do
          ENV['SETTINGS_FIXNUM'] = '1'
          hash.merge_env('SETTINGS')
        end

        its([:fixnum]) { should == 1 }
      end
    end
  end

  describe 'each_env' do
    context 'when prefix is nil' do
      subject { Hash[*hash.each_env.to_a.flatten] }
      its(['FLOAT']) { should == '1.2' }
      its(['FIXNUM']) { should == '20' }
      its(['ARRAY']) { should == '[1, 2]' }
      its(['HASH_KEY']) { should == 'name' }
      its(['HASH_VALUE']) { should =='settings-env-loader' }
    end
    context 'when prefix is SETTINGS' do
      subject { Hash[*hash.each_env('SETTINGS').to_a.flatten] }
      its(['FIXNUM']) { should be_nil }
      its(['SETTINGS_FIXNUM']) { should == '20' }
    end
  end
end
