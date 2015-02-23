module FlipFab
  describe FeaturesByName do
    let(:features) { { example_feature: 'double' } }
    subject{ described_class.new features }

    describe '#[]' do

      context 'when the feature exists' do

        it 'returns the feature' do
          expect(subject[:example_feature]).to eq('double')
        end
      end

      context 'when the feature does not exist' do

        it 'raises' do
          expect{ subject[:no_feature] }.to raise_error 'no feature has been defined with the name: no_feature'
        end
      end
    end
  end
end
