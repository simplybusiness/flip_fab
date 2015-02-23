require 'rack/test'

module FlipFab
  describe Helper do
    include Rack::Test::Methods
    let(:app) { TestApp.new }
    after  { FlipFab.features.clear  }

    it 'runs the feature' do
      feature
    end

    step 'there is a feature with a default state of :default_state' do |default_state|
      FlipFab.define_feature :example_feature, { default: default_state.to_sym, persistence_adapters: [TestPersistence] }
    end

    step 'there are two contexts' do
      @first_context  = TestContext.new
      @second_context = TestContext.new
    end

    step 'the feature is :expected_state_in_first_context in the first context, :expected_state_in_second_context in the second context' do |expected_state_in_first_context, expected_state_in_second_context|
      expect(@first_context.features[:example_feature].enabled?).to eq(expected_state_in_first_context == 'enabled')
      expect(@second_context.features[:example_feature].enabled?).to eq(expected_state_in_second_context == 'enabled')
    end

    step 'I :enable_or_disable the feature in the first context' do |enable_or_disable|
      @first_context.features[:example_feature].send(enable_or_disable.to_sym)
    end

    step 'there is a feature with a default state of :default_state with cookie persistence' do |default_state|
      FlipFab.define_feature :example_feature, { default: default_state.to_sym }
    end

    step 'I override the state in the URL parameters with :overridden_state' do |overridden_state|
      get "/?example_feature=#{overridden_state}"
    end

    step 'the feature is :state for the user' do |state|
      expect(app.contextual_features[:example_feature].enabled?).to eq(state=='enabled')
    end

    step 'I :enable_or_disable the feature for the user' do |enable_or_disable|
      app.contextual_features[:example_feature].send(enable_or_disable.to_sym)
    end

    describe '#features' do
      let(:params)         {{}}
      let(:feature_states) {{ example_feature: :enabled }}
      let(:context)        { (TestContext.new feature_states, params) }
      before { FlipFab.define_feature :example_feature, { persistence_adapters: [TestPersistence] } }
      subject { context.features }

      it 'maps the features to contextual features by feature name' do
        expect(subject[:example_feature]).to be_a ContextualFeature
      end

      it 'is a FeaturesByName' do
        expect(subject).to be_a FeaturesByName
      end

      context 'when the feature is overridden in the params' do
        let(:params) {{'example_feature' => 'disabled'}}

        it 'applies the override to the feature' do
          expect(subject[:example_feature].disabled?).to be_truthy
        end

        it 'prevents the feature\'s state from being changed' do
          expect{ subject[:example_feature].enable }.not_to change{ subject[:example_feature].enabled? }.from(false)
        end
      end

      context 'passing the context to the feature' do

        it 'feature toggling is applied to the context' do
          expect{ subject[:example_feature].disable }.to change{ subject[:example_feature].enabled? }.from(true).to(false)
        end

        it 'feature toggling is persisted in the context' do
          expect{ subject[:example_feature].disable }.to change{ feature_states }.from({ example_feature: :enabled }).to({ example_feature: :disabled })
        end
      end

      it 'caches the features' do
        expect(subject).to eq(context.features)
      end
    end
  end
end
