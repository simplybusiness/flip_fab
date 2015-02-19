module FlipFab
  describe Helper do
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
      if enable_or_disable == 'enable'
        @first_context.features[:example_feature].enable
      else
        @first_context.features[:example_feature].disable
      end
    end

    describe '#features' do
      let(:feature_states) {{ example_feature: :enabled }}
      let(:context)        { (TestContext.new feature_states) }
      before { FlipFab.define_feature :example_feature, { persistence_adapters: [TestPersistence] } }
      subject { context.features }

      it 'maps the features to contextual features by feature name' do
        expect(subject[:example_feature]).to be_a ContextualFeature
      end

      it 'is a FeaturesByName' do
        expect(subject).to be_a FeaturesByName
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
