module FlipFab
  describe Helper do
    before { FlipFab.define_feature :example_feature, {persistence_adapters: [TestPersistence]} }
    after  { FlipFab.features.clear }

    describe '#features' do
      let(:feature_states) {{ example_feature: :enabled }}
      let(:context)        { (TestContext.new feature_states) }
      subject { context.features }

      it 'maps the features to contextual features by feature name' do
        expect(subject[:example_feature]).to be_a ContextualFeature
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
