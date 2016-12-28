describe FlipFab do
  let(:name) { :example_feature }

  feature do
    step 'I define a feature that is :enabled_or_disabled' do |enabled_or_disabled|
      described_class.define_feature name, { default: enabled_or_disabled.to_sym }
    end

    step 'the feature is :enabled_or_disabled' do |enabled_or_disabled|
      expect(described_class.features[name].enabled?).to eq(enabled_or_disabled == 'enabled')
    end
  end

  it 'initializes features' do
    expect(described_class.features).to be_a FlipFab::FeaturesByName
  end

  context '.define_feature' do
    subject{ described_class.define_feature name }
    after{ described_class.features.clear }

    it 'returns the feature' do
      expect(subject).to be_a FlipFab::Feature
      expect(subject.name).to eq(:example_feature)
    end

    context 'when the feature exists' do

      it 'overwrites the existing feature' do
        existing_feature = described_class.define_feature name
        expect{ subject }.not_to change{ described_class.features.count }.from(1)
        expect(subject).not_to eq(existing_feature)
      end
    end

    context 'when the feature does not exist' do

      it 'saves the feature' do
        expect{ subject }.to change{ described_class.features.count }.from(0).to(1)
        expected_feature = subject
        expect(described_class.features[:example_feature]).to eq(expected_feature)
      end
    end
  end
end
