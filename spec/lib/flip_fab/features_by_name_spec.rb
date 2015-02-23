module FlipFab
  describe FeaturesByName do
    let(:feature)  { Feature.new :example_feature }
    let(:features) { { example_feature: feature } }
    subject{ described_class.new features }

    describe '#[]' do

      context 'when the feature exists' do

        it 'returns the feature' do
          expect(subject[:example_feature]).to eq(feature)
        end
      end

      context 'when the feature does not exist' do

        it 'raises' do
          expect{ subject[:no_feature] }.to raise_error 'no feature has been defined with the name: no_feature'
        end
      end
    end

    describe '#with_context' do
      let(:context) { double(:context) }

      it 'returns contextual features by name' do
        expect(subject.with_context context).to be_a described_class
        expect((subject.with_context context)[:example_feature]).to be_a ContextualFeature
        expect((subject.with_context context)[:example_feature].feature).to eq(feature)
      end
    end
  end
end
