require 'rack'
require 'timecop'

module FlipFab
  describe CookiePersistence do
    let(:cookies) {}
    let(:context) { TestRackContext.new cookies, 'simplybusiness.co.uk' }
    before { FlipFab.define_feature :example_feature }
    after  { FlipFab.features.clear }
    subject { described_class.new :example_feature, context }

    feature do
      step 'the host is :host' do |host|
        @host = host
      end

      step 'the feature name is :feature_name' do |feature_name|
        @feature_name = feature_name
      end

      step 'the time is :current_time' do |current_time|
        Timecop.freeze(Time.parse(current_time))
      end

      step 'the state of the feature is :feature_state' do |feature_state|
        @feature_state = feature_state
      end

      step 'I persist the feature state in a cookie' do
        context = TestRackContext.new '', @host
        (described_class.new @feature_name, context).write @feature_state
        @cookie = context.response_cookies
      end

      step 'the cookie has the path :path' do |path|
        expect(@cookie).to match(/path=#{path};/)
      end

      step 'the cookie does not have domain :domain' do |domain|
        expect(@cookie).not_to match(/domain=#{domain};/)
      end

      step 'the cookie has the name :name' do |name|
        expect(@cookie).to match(/\A#{name}.*/)
      end

      step 'the cookie expires at :expiration' do |expiration|
        expect(@cookie).to match(/expires=#{expiration}\Z/)
      end

      step 'the cookie value is :value' do |value|
        expect(@cookie).to match(/=#{value};/)
      end
    end

    describe '#read' do
      context 'when there is no existing cookie' do
        let(:cookies) {}

        it 'returns nil' do
          expect(subject.read).to be_nil
        end
      end

      context 'when the feature state is defined in the cookie' do
        let(:cookies) { 'flip_fab.example_feature=enabled' }

        it 'returns the feature state' do
          expect(subject.read).to eq(:enabled)
        end
      end
    end

    describe '#write' do
      before { Timecop.freeze(Time.utc(1990)) }
      after  { Timecop.return }

      it 'saves the feature state' do
        expect { subject.write :enabled }.to change { context.response_cookies }.from(nil).to('flip_fab.example_feature=enabled; path=/; expires=Tue, 01 Jan 1991 00:00:00 GMT')
      end
    end
  end
end
